class Document {

  final String key;
  List<Map<String, String>> values;

  Document({
    required this.key,
    required this.values
  });

  Map<String, List<Map<String, String>>> toJSON() {
    return {
      key: values
    };
  }

}