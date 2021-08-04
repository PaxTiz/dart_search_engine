import 'dart:convert';
import 'document.dart';
import 'client_extension.dart';

class Client {
  final String path = 'data.json';

  Client({String? path}) {
    if (path != null) path = path;
  }

  Future<int> add(List<Map<String, String>> documents,
      {bool merge = false}) async {
    var list = Iterable<Document>.empty();
    if (merge) {
      var current = await readFromFile();
      final documentsList = documentsAsMap(documents);

      list = mergeDocuments(current, documentsList);
    } else {
      list = documentsAsMap(documents);
    }

    var map = {};
    for (final doc in list) {
      map[doc.key] = doc.values;
    }

    final asJson = jsonEncode(map);
    return await writeToFile(asJson);
  }

  Future<Iterable<Document>> search(String query) async {
    final documents = await readFromFile();
    final keywords = stringToKeywords(query, length: 0).split(' ');

    var indexes = [];
    for (var i = 0; i < documents.length; i++) {
      if (keywords.contains(documents[i].key)) {
        indexes.add(i);
      }
    }

    return indexes.map((e) => documents[e]);
  }

}
