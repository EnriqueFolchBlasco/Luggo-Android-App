import 'package:floor/floor.dart';

@Entity(tableName: 'Chat')
class Chat {
  @PrimaryKey(autoGenerate: true)
  final int? chatId;

  final String user1;
  final String user2;

  Chat(this.chatId, this.user1, this.user2);
}
