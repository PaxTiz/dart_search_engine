import 'package:faker/faker.dart';

import 'client.dart';

void main(List<String> arguments) async {
  final client = Client();
  await client.add([
    {
      'title': 'hello world',
      'description': "i'm a fake description"
    },
    {
      'title': 'world hello',
      'description': "descrition fake i'm a"
    }
  ], merge: true);

  final result = await client.search('world description');
  print(result);
}
