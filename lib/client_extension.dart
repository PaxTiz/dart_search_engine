import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'client.dart';
import 'document.dart';

extension ClientExtension on Client {
  Future<int> writeToFile(dynamic content) async {
    final file = File(path);
    final writed = await file.writeAsString(content, mode: FileMode.write);
    return await writed.length();
  }

  Future<List<Document>> readFromFile() async {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException(path);
    }

    final content = await file.readAsString();
    if (content.isEmpty) {
      return [];
    }

    final Map<String, dynamic> json = jsonDecode(content);
    var documents = <Document>[];
    json.forEach((k, v) {
      var list = List.from(v);
      for (var i = 0; i < list.length; i++) {
        list[i] = Map<String, String>.from(list[i]);
      }

      final asMap = List<Map<String, String>>.from(list);
      documents.add(Document(key: k, values: asMap));
    });

    return documents;
  }

  String stringToKeywords(String str, {int length = 4}) {
    return str
        .toLowerCase()
        .replaceAll('[^A-Za-z0-9]', '')
        .replaceAll('.', '')
        .split(' ')
        .where((String e) => e.length >= length)
        .join(' ');
  }

  List<Document> documentsAsMap(List<Map<String, String>> documents) {
    var list = <Document>[];

    documents.forEach((doc) {
      final keys = doc.keys;
      final current = {};

      keys.forEach((k) {
        if (doc[k] is String) {
          current[k] = stringToKeywords(doc[k]!);
        } else {
          current[k] = doc[k];
        }
      });

      current.entries.forEach((element) {
        final splitted = element.value.split(' ');

        splitted.forEach((word) {
          final exists = list.indexWhere((e) => e.key == word);
          if (exists == -1) {
            list.add(Document(key: word, values: [doc]));
          } else {
            list[exists].values = [...list[exists].values, doc];
          }
        });
      });
    });

    return list;
  }

  List<Document> mergeDocuments(
      List<Document> current, List<Document> documentsAsMap) {
    for (final doc in documentsAsMap) {
      final exists = current.indexWhere((e) => e.key == doc.key);
      if (exists == -1) {
        current.add(doc);
      } else {
        var withoutDuplicates = List<Map<String, String>>.of([]);
        for (final dup in doc.values) {
          for (final cur in current) {
            var contains = false;
            cur.values.forEach((e) {
              if (MapEquality().equals(e, dup)) {
                contains = true;
              }
            });

            if (!contains) {
              withoutDuplicates.add(dup);
              break;
            }
          }
        }
        current[exists].values = withoutDuplicates;
      }
    }

    return current;
  }
}
