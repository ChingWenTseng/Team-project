import 'package:flutter/material.dart';
import 'package:login_register/database/db.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? phone;
  String? password;
  String? phoneErrorText;
  String? passwordErrorText;
  final Logger logger = Logger();
  //final TextEditingController phoneController = TextEditingController();
  //final TextEditingController pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "登入",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 35.0,
            ),
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 96, 157, 187),
              radius: 50.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://en.pimg.jp/065/551/508/1/65551508.jpg'),
                radius: 45.0,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: TextField(
                maxLength: 10,
                //controller: phoneController,
                onChanged: (value) {
                  phone = value;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '輸入手機號碼',
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  errorText: phoneErrorText,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '輸入密碼',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  errorText: passwordErrorText,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Container(
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      if ((phone?.length ?? 0) != 10) {
                        phoneErrorText = "手機號碼格式錯誤";
                      } else {
                        phoneErrorText = null;
                      }
                    });
                    bool logincheck = await Database.login(phone!, password!);
                    setState(() {
                      if (logincheck) {
                        logger.i("登入成功");
                        phoneErrorText = null;
                        passwordErrorText = null; //切畫面
                      } else {
                        logger.i("登入失敗");
                        phoneErrorText = "手機或密碼錯誤，請重新檢查";
                        passwordErrorText = "手機或密碼錯誤，請重新檢查";
                      }
                    });
                  },
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          '登入',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              '----------- 尚未註冊? -----------',
              style: TextStyle(
                  color: Color.fromARGB(189, 123, 147, 159), fontSize: 20),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    if (password != null && phone != null) print('進入使用者註冊畫面');
                  },
                  child: Material(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          '使用者註冊',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    if (password != null && phone != null) print('進入連結者註冊畫面');
                  },
                  child: Material(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10.0),
                    child: const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          '連結者註冊',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








/*import 'package:flutter/material.dart';
import 'package:login_register/database/db.dart';
import 'package:logger/logger.dart';

//import 'package:mysql1/mysql1.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
      debugShowCheckedModeBanner: false, //拿掉右上角debug
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  //var database = new Database();
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle btnstyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final TextEditingController acccontroller = TextEditingController();
    final TextEditingController pwdcontroller = TextEditingController();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: acccontroller,
            keyboardType: TextInputType.text,
            onChanged: (String value) {},
            decoration: const InputDecoration(
              labelText: "帳號",
              hintText: "請輸入帳號",
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: pwdcontroller,
            keyboardType: TextInputType.text,
            onChanged: (String value) {},
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "密碼",
              hintText: "請輸入密碼",
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonBar(children: <Widget>[
                ElevatedButton(
                  style: btnstyle,
                  child: const Text('Login'),
                  onPressed: () async {
                    bool logincheck = await Database.login('test', 'test1234');
                    if (logincheck) {
                      logger.i("登入成功");
                    } else {
                      logger.i("登入失敗");
                    }
                    logger.i(acccontroller.text);
                    logger.i(pwdcontroller.text);
                  },
                ),
                ElevatedButton(
                  style: btnstyle,
                  onPressed: () {},
                  child: const Text('Register'),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}*/
