import 'package:isar/isar.dart';

// generate the db file
part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;
  late DateTime createdAt;
  late DateTime updatedAt;

  Note() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
}
