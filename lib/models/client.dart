import 'package:floor/floor.dart';

@Entity(tableName: 'Client')
class Client {
  @PrimaryKey()
  final String userId;

  final String user;
  final String? profilePhoto;

  Client({
    required this.userId,
    required this.user,
    this.profilePhoto,
  });
}
