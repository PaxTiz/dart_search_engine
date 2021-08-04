import 'package:faker/faker.dart';

import 'client.dart';

void main(List<String> arguments) async {
  final client = Client();
  await client.add(List.generate(20, (_) => {
      'title': faker.lorem.words(10).join(' '),
      'description': faker.lorem.sentence()
    }), erase: true);

  final result = await client.search('odio enim');
  print(result);
}
