import 'package:hive/hive.dart';
part 'snippet.g.dart';
@HiveType(typeId:1)
class Snippet {
  Snippet({this.imageURL, this.name, this.code,this.language});

  @HiveField(0)
  String imageURL;
  @HiveField(1)
  String name;
  @HiveField(2)
  String code;
  @HiveField(3)
  String language;

  @override
  String toString(){
    return imageURL;
  }
  
}
