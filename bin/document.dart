class Document {

  final Map<String, dynamic> content;
  final DateTime createdAt = DateTime.now();

  Document({required Map<String, dynamic> content, DateTime? createdAt}) : content = content {
      if (createdAt != null) createdAt = createdAt;
    }

  Map<String, dynamic> toJSON() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String()
    };
  }

  factory Document.fromJSON(Map<String, dynamic> json) {
    return Document(
      content: json['content'], 
      createdAt: DateTime.parse(json['createdAt'])
    );
  }

}