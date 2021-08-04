import 'dart:convert';
import 'dart:io';

class Client {
  final String path = 'data.json';

  Client({String? path}) {
    if (path != null) path = path;
  }

  Future<int> add(List<Map<String, dynamic>> documents,
      {bool erase = false}) async {
    final map = _documentsAsMap(documents);
    final asJson = jsonEncode(map);
    
    return await _writeToFile(asJson, erase);
  }

  Future<List<dynamic>> search(String query) async {
    final documents = await _readFromFile();
    final keywords = _stringToKeywords(query, length: 0).split(' ');
    var docs = <dynamic>{};

    for (final keyword in keywords) {
      if (documents.containsKey(keyword)) {
        docs.add(documents[keyword]);
      }
    }

    return docs.toList();
  }

  Future<int> _writeToFile(dynamic content, bool erase) async {
    final file = File(path);
    final writed = await file.writeAsString(content,
        mode: erase ? FileMode.write : FileMode.append);
    return await writed.length();
  }

  Future<Map<String, dynamic>> _readFromFile() async {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException(path);
    }

    final content = await file.readAsString();
    final Map<String, dynamic> json = jsonDecode(content);
    return json;
  }

  String _stringToKeywords(String str, {int length = 4}) {
    return str
      .toLowerCase()
      .split(' ')
      .where((String e) => e.length >= length)
      .join(' ')
      .replaceAll('[^A-Za-z0-9]', '');
  }

  Map<String, dynamic> _documentsAsMap(List<Map<String, dynamic>> documents) {
    final map = <String, dynamic>{};
    documents.forEach((doc) {
      final keys = doc.keys;
      final current = {};
      /// Filter document values by length to create 
      /// 4 alpha-numerics characters strings
      keys.forEach((k) {
        if (doc[k] is String) {
          current[k] = _stringToKeywords(doc[k]);
        } else {
          current[k] = doc[k];
        }
      });

      /// Build map to contains words as keys
      /// and all documents that contains this
      /// key as values
      current.entries.forEach((element) {
        final splitted = element.value.split(' ');
        splitted.forEach((word) {
          if (map.containsKey(word)) {
            map[word] = {...map[word], doc}.toList();
          } else {
            map[word] = {doc}.toList();
          }
        });
      });
    });

    return map;
  }
}
