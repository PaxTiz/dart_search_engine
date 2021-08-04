import 'package:faker/faker.dart';
import 'package:play/client.dart';

void main(List<String> arguments) async {
  final client = Client();
  final documents = List.generate(50, (_) => {
    'title': faker.lorem.words(10).join(' '),
    'description': faker.lorem.sentence()
  });
    
  await client.add(documents, merge: false);
}
