import 'package:flutter/material.dart';
import 'package:login_register/database/db.dart';
import 'package:logger/logger.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      ),
      home: const RegistPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      locale: const Locale('zh'),
    );
  }
}

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  String? phone;
  String? password;
  String? passwordcheck;
  String? phoneErrorText;
  String? passwordErrorText;
  String? passwordcheckErrorText;
  //final TextEditingController phoneController = TextEditingController();
  //final TextEditingController pwdController = TextEditingController();
  //final TextEditingController pwdcheckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "使用者註冊",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: '手機號碼',
                  counterText: "",
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: phoneErrorText,
                ),
                //controller: phoneController,
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: '密碼',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: passwordErrorText,
                ),
                //controller: pwdController,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: '確認密碼',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: passwordcheckErrorText,
                ),
                //controller: pwdcheckController,
                onChanged: (value) {
                  setState(() {
                    passwordcheck = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: MaterialButton(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                onPressed: () async {
                  bool phoneExists = await Database.checkphone(phone!);
                  setState(() {
                    if (phoneExists) {
                      phoneErrorText = "此手機號碼已被註冊過";
                    } else if ((phone?.length ?? 0) != 10) {
                      phoneErrorText = "手機號碼格式錯誤";
                    } else {
                      phoneErrorText = null;
                    }
                  });
                  setState(() {
                    if ((password?.length ?? 0) < 6) {
                      passwordErrorText = "請輸入6位以上的密碼";
                    } else {
                      passwordErrorText = null;
                    }

                    if ((password != passwordcheck)) {
                      passwordcheckErrorText = "兩次輸入的密碼不一致，請確認密碼";
                    } else {
                      passwordcheckErrorText = null;
                    }
                  });
                  if (phoneErrorText == null &&
                      passwordErrorText == null &&
                      passwordcheckErrorText == null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistPage2(
                          phone: phone,
                          password: password,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  '下一步',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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

class RegistPage2 extends StatefulWidget {
  String? phone;
  String? password;
  RegistPage2({this.phone, this.password});

  _RegistPageState2 createState() => _RegistPageState2();
}

class _RegistPageState2 extends State<RegistPage2> {
  String? name;
  int? gender;
  String? birth;
  int? height;
  int? weight;
  String sexvalue = '性別';
  DateTime? pickedDate;
  String? datefordb;
  String? nameErrorText;
  String? heightErrorText;
  String? weightErrorText;
  String? dateErrorText;
  String? sexErrorText;
  final Logger logger = Logger();
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "使用者註冊",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: '暱稱',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: nameErrorText,
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(17, 4, 17, 4),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                //設置圓角邊框
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.elliptical(4, 4),
                      bottom: Radius.elliptical(4, 4)),
                  color: Colors.white10,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white10)),
                      prefixIcon: const Icon(Icons.transgender),
                      errorText: sexErrorText,
                    ),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        child: Text(
                          '男',
                          style: TextStyle(
                              color:
                                  sexvalue == '男' ? Colors.black : Colors.grey),
                        ),
                        value: '男',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          '女',
                          style: TextStyle(
                              color:
                                  sexvalue == '女' ? Colors.black : Colors.grey),
                        ),
                        value: '女',
                      ),
                    ],
                    hint: Text('$sexvalue'),
                    isExpanded: true,
                    onChanged: (_selectType) {
                      //選中後的回撥
                      setState(() {
                        sexvalue = _selectType!;
                      });
                    },
                    elevation: 10, //設定陰影
                    style: const TextStyle(
                        //設定文字框裡面文字的樣式
                        color: Colors.grey,
                        fontSize: 16),
                    iconSize: 30, //設定三角標icon的大小
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Center(
                child: TextField(
                  controller: dateInput,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.today),
                    labelText: '生日',
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                    errorText: dateErrorText,
                  ),
                  readOnly: true,
                  onTap: () async {
                    pickedDate = await showDatePicker(
                        locale: const Locale('zh'),
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now());
                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String? formattedDate = DateFormat('yyyy年MM月dd日', 'zh_CN')
                          .format(pickedDate!);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      datefordb = DateFormat('yyyy-MM-dd').format(pickedDate!);
                      setState(() {
                        dateInput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }
                  },
                  /*onChanged: (value) {
                  DatePickerDialog(initialDate: DateTime.now(), firstDate: DateTime(1923, 01), lastDate: DateTime(2100, 12));
                  setState(() {
                    birth = value;
                  });
                },*/
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.height),
                  labelText: '身高',
                  hintText: '身高(cm)',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: heightErrorText,
                ),
                onChanged: (value) {
                  setState(() {
                    height = int.tryParse(value);
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.monitor_weight),
                  labelText: '體重',
                  hintText: '體重(kg)',
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: const OutlineInputBorder(),
                  errorText: weightErrorText,
                ),
                onChanged: (value) {
                  setState(() {
                    weight = int.tryParse(value);
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: MaterialButton(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                onPressed: () async {
                  setState(() {
                    if (name == null) {
                      nameErrorText = "請輸入暱稱";
                    } else {
                      nameErrorText = null;
                    }
                    if (height == null || height! < 0 || height! > 300) {
                      heightErrorText = "請輸入正確的身高";
                    } else {
                      heightErrorText = null;
                    }
                    if (weight == null || weight! < 0 || weight! > 300) {
                      weightErrorText = "請輸入正確的體重";
                    } else {
                      weightErrorText = null;
                    }
                    if (sexvalue == "性別") {
                      sexErrorText = "請選擇性別";
                    } else if (sexvalue == "男") {
                      gender = 1;
                      sexErrorText = null;
                    } else {
                      gender = 2;
                      sexErrorText = null;
                    }
                    if (datefordb == null) {
                      dateErrorText = "請選擇日期";
                    } else {
                      dateErrorText = null;
                    }
                  });

                  if (heightErrorText == null &&
                      weightErrorText == null &&
                      sexErrorText == null &&
                      dateErrorText == null &&
                      nameErrorText == null) {
                    await Database.register(widget.phone!, widget.password!,
                        name!, gender!, datefordb!, height!, weight!);

                    //顯示對話框
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("註冊成功\n請重新登入"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text("OK"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  '註冊',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
