import 'package:mysql1/mysql1.dart';

class Database {
  static const String _databaseName = 'project';
  static const String _host =
      'database-1.cd1rocbiih3j.ap-northeast-1.rds.amazonaws.com';
  static const int _port = 3306;
  static const String _username = 'hello';
  static const String _password = '00000000';

  //Database();

  static Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: _host,
        port: _port,
        user: _username,
        password: _password,
        db: _databaseName);
    return await MySqlConnection.connect(settings);
  }

  //登入驗證
  static Future<bool> login(String phone, String password) async {
    MySqlConnection conn = await getConnection();
    var results = await conn.query(
        'SELECT * FROM User WHERE User_Phone = ? AND User_Password = ?',
        [phone, password]);
    await conn.close();
    return results.isNotEmpty; //isNotEmpty檢查結果不為空
  }

  //註冊
  static Future<void> register(String phone, String password, String name,
      int gender, String birthday, int height, int weight) async {
    MySqlConnection conn = await getConnection();
    await conn.query(
        'INSERT INTO User(User_Phone, User_Password, User_Name, User_Gender, User_Birthday, User_Height, User_Weight) VALUES ('
        '?'
        ' , '
        '?'
        ' , '
        '?'
        ', ?, ?, ?, ?)',
        [phone, password, name, gender, birthday, height, weight]);
    await conn.close();
  }

  //檢查手機是否註冊過
  static Future<bool> checkphone(String phone) async {
    MySqlConnection conn = await getConnection();
    var results = await conn
        .query('SELECT COUNT(*) FROM User WHERE User_Phone = ?', [phone]);
    await conn.close();

    if (results.first.first == 1) {
      //傳回results第一行 第一列
      return true; //有註冊過 不可用
    } else {
      return false; //沒註冊過 可用
    }
  }
}
