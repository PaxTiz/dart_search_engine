# Search engine

## How it works ?

**TODO**

## Usage

The first step is to generate the JSON file. To do this, you need to 
create a client and add documents. Theses documents will be converted
as JSON and written to the file.

```dart
void main() async {
  final client = Client();
  final documents = List.generate(50, (_) => {
    'title': faker.lorem.words(10).join(' '),
    'description': faker.lorem.sentence()
  });
    
  await client.add(documents, merge: false);
}
```

> ### Notes
> - You can specify the path of the file in the `Client` constructor.
> - The `merge` parameter in the `add` method allows you
> to merge documents with these which are already present, or
> erase everything and start from what you're adding.

---

Once it's done, you can now search documents by terms.
```dart
void main() async {
  final client = Client(path: 'mydocuments.json');
  await client.add([...], merge: false);

  final documents = await client.search('lorem');
}
```

The `search` method will returns all documents that contains
the word you pass in parameter somewhere in it's body. 

> ### Note
> It's not yet possible to specify what field of documents are 
> to index or not. Currently, JSON file is created by parsing
> everything.

In our case, `documents` will contains all documents that contains the word **`lorem`** in it's title or description.
