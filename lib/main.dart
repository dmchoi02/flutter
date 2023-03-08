import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

int pomodoroSumCnt = 0; //여태까지 작업한 뽀모도로의 총 개수
int pomodoroSumTime = 0;
int sum_hour = 0;
int sum_min = 0;

Color c1 = Color(0xffFFFFFF);
Color c2 = const Color(0xff234E70);
String labelError = "Input is required.";

/*
void firtstset() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('sumCnt') ?? 0);
  await prefs.setInt('sumCnt', counter);
  print("카운터 값은 \n");
  print(counter);
  pomodoroSumCnt = counter;
  print("sumCnt카운터 값은 \n");
  print(pomodoroSumCnt);
}
*/

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //비동기로 데이터를 다룬다음 메인을 실행할 때 반드시 적어야함 runApp 메소드의 시작 지점에서 Flutter 엔진과 위젯의 바인딩이 미리 완료되어 있게만들어줍니다
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int sum_counter = (prefs.getInt('sumCnt') ?? 0);
  int sum_time = (prefs.getInt('sumTime') ?? 0);
  pomodoroSumCnt = sum_counter;
  pomodoroSumTime = sum_time;
  sum_hour = pomodoroSumTime ~/ 60;
  sum_min = pomodoroSumTime % 60;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(), //메인에서 파라미터 넘김
  ));
}

class MyApp extends StatefulWidget {
  //SharedPreferences prefs; //myapp에서 this로 받을 prefs변수 선언
  //const MyApp({Key? key}) : super(key: key);

  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
  //myappstate에서 prefs로 파라미터 넘김

}

class _MyAppState extends State<MyApp> {
  //변수
  int onePomodoro = 0; //1개의 뽀모도로의 작업시간
  int breakTime = 0; //휴식시간
  int pomodoroCnt = 1; //작업할 뽀모도로의 개수, 최소 1개는 반드시 해야함
  var pomodoro_controller = TextEditingController();
  var break_controller = TextEditingController();
  //_MyAppState(prefs);

  @override
  Widget build(BuildContext context) {
    //firtstset();

    String lebel_one = "1 Pomodoro Time (1min ~ 99min)";
    String label_two = "Break Time (1min ~ 30min)";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: c2,
          centerTitle: true, //아이폰과 삼성 모두 가운데 정렬로 만듬
          title: Text(
            "Simple Pomodoro",
            style: TextStyle(fontSize: 22, color: c1),
          ),
        ),
        body: Container(
          color: c1,
          child: Padding(
            //안쪽 여백, 앱바와 바디, 네비게이션바의 거리를 두기 위해서.
            padding: const EdgeInsets.all(16),
            //키보드 입력으로 화면이 내려가도 스크롤 할 수 있게 만듬
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                  ),

                  TextField(
                    controller: pomodoro_controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lebel_one,
                      hintText: "Usually, (25min~50min)",
                      labelStyle: TextStyle(color: c2),
                      suffixIcon: IconButton(
                        onPressed: () {
                          pomodoro_controller.clear();
                          onePomodoro = 0;
                        },
                        icon: Icon(Icons.clear),
                        color: c2,
                      ),
                    ),

                    //입력값이 한개라도 바뀔 때 호출됨
                    onChanged: (text) {
                      try {
                        if (int.parse(text) >= 1 && int.parse(text) <= 99) {
                          onePomodoro = int.parse(text);
                        } else {
                          //범위를 벗어나거나 잘못된 값을 입력한 경우 초기화
                          pomodoro_controller.clear();
                          onePomodoro = 0;
                        }
                      } catch (e) {
                        pomodoro_controller.clear();
                        print("Exception Handling.");
                        onePomodoro = 0;
                      }
                    },
                    //엔터 버튼을 눌렀을 때 호출됨
                    onSubmitted: (text) {
                      try {
                        if (int.parse(text) >= 1 && int.parse(text) <= 99) {
                          onePomodoro = int.parse(text);
                        } else {
                          //범위를 벗어나거나 잘못된 값을 입력한 경우 초기화
                          pomodoro_controller.clear();
                          onePomodoro = 0;
                        }
                      } catch (e) {
                        pomodoro_controller.clear();
                        print("Exception Handling.");
                        onePomodoro = 0;
                      }
                    },
                  ),
                  TextField(
                    controller: break_controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: label_two,
                      labelStyle: TextStyle(color: c2),
                      hintText: "Usually, (5min ~ 15min)",
                      suffixIcon: IconButton(
                        onPressed: () {
                          pomodoro_controller.clear();
                          breakTime = 0;
                        },
                        icon: Icon(Icons.clear),
                        color: c2,
                      ),
                    ),
                    //입력값이 한개라도 바뀔 때 호출됨
                    onChanged: (text) {
                      try {
                        if (int.parse(text) >= 1 && int.parse(text) <= 30) {
                          breakTime = int.parse(text);
                        } else {
                          //범위를 벗어나거나 잘못된 값을 입력한 경우 초기화
                          break_controller.clear();
                          breakTime = 0;
                        }
                      } catch (e) {
                        break_controller.clear();
                        breakTime = 0;
                        print("Exception Handling.");
                      }
                    },
                    //엔터 버튼을 눌렀을 때 호출됨
                    onSubmitted: (text) {
                      try {
                        if (int.parse(text) >= 1 && int.parse(text) <= 30) {
                          breakTime = int.parse(text);
                        } else {
                          //범위를 벗어나거나 잘못된 값을 입력한 경우 초기화
                          break_controller.clear();
                          breakTime = 0;
                        }
                      } catch (e) {
                        break_controller.clear();
                        breakTime = 0;
                        print("Exception Handling.");
                      }
                    },
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 60),
                    child: Text(
                      "Total hours worked : " +
                          sum_hour.toString() +
                          "h " +
                          sum_min.toString() +
                          "m",
                      style: TextStyle(fontSize: 22, color: c2),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Total number of pomodoros: " + pomodoroSumCnt.toString(),
                      style: TextStyle(fontSize: 22, color: c2),
                    ),
                  ),

                  //set Pomodoro count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: 64,
                        height: 64,
                        child: IconButton(
                          iconSize: 40,
                          alignment: Alignment.center,
                          onPressed: () {
                            print("Plus Button 클릭");
                            setState(() {
                              if (pomodoroCnt >= 1 && pomodoroCnt <= 98) {
                                pomodoroCnt++;
                              } else {
                                //nothing to do
                              }
                            });
                          },
                          icon: Icon(Icons.add),
                          color: c2,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: 64,
                        height: 64,
                        color: c2,
                        child: Text(
                          pomodoroCnt.toString(),
                          style: TextStyle(fontSize: 50, color: c1),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: 64,
                        height: 64,
                        child: IconButton(
                          iconSize: 40,
                          alignment: Alignment.center,
                          onPressed: () {
                            print("Minus Button 클릭");
                            setState(() {
                              if (pomodoroCnt >= 2 && pomodoroCnt <= 99) {
                                pomodoroCnt--;
                              } else {
                                //nothing to do
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: c2,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin:
                        EdgeInsets.only(top: 50), //위로만 바깥여백, 위에 블록과 거리를 두기 위해서.
                    width: 128,
                    height: 64,
                    color: c2,
                    child: TextButton(
                      onPressed: () async {
                        if (onePomodoro != 0 && breakTime != 0) {
                          final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePage(onePomodoro,
                                  breakTime, pomodoroCnt, pomodoroSumCnt),
                            ),
                          );
                          setState(() {});
                        } else {
                          print("쇼토스트");
                          showToast();
                          //작업을 안함
                        }
                      },
                      child: Text(
                        "Start",
                        style: TextStyle(
                          color: c1,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    color: c1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showToast() {
  Fluttertoast.showToast(
      msg: "Input is required.",
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT);
}

//두번째 페이지
class CreatePage extends StatefulWidget {
  int work_onePomodoro = 0; //작업중의 1개의 뽀모도로의 작업시간
  int work_breakTime = 0; //작업중의 휴식시간
  int work_pomodoroCnt = 0; //작업할 뽀모도로의 개수
  int work_pomodoroSumCnt = 0; //작업중의 여태까지 작업한 뽀모도로의 총 개수

  CreatePage(this.work_onePomodoro, this.work_breakTime, this.work_pomodoroCnt,
      this.work_pomodoroSumCnt,
      {Key? key})
      : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  int work_onePomodoro = 0;
  int work_breakTime = 0;
  int work_pomodoroCnt = 0;
  int work_pomodoroSumCnt = 0;

  String first_work_time_m = 0.toString();
  String second_work_time_m = 0.toString();
  String first_work_time_s = 0.toString();
  String second_work_time_s = 0.toString();

  String first_break_time_m = 0.toString();
  String second_break_time_m = 0.toString();
  String first_break_time_s = 0.toString();
  String second_break_time_s = 0.toString();

  bool alreadybuild = false;
  bool working = false;
  bool resting = false;
  int pomodoro_cnt = 0;

  int sum_workTime = 0;
  int sum_breakTime = 0;

  String stateText = "Start";

  @override
  Widget build(BuildContext context) {
    //Base Variable
    if (!alreadybuild) {
      print("처음 들어옴");
      //처음 들어간 상태라면
      work_onePomodoro = widget.work_onePomodoro;
      work_breakTime = widget.work_breakTime; //작업중의 휴식시간
      work_pomodoroCnt = widget.work_pomodoroCnt; //작업할 뽀모도로의 개수
      work_pomodoroSumCnt =
          widget.work_pomodoroSumCnt; //작업중의 여태까지 작업한 뽀모도로의 총 개수

      alreadybuild = !alreadybuild;
      working = true;

      sum_workTime = work_onePomodoro * 60;
      sum_breakTime = work_breakTime * 60;

      //working time
      first_work_time_m = (work_onePomodoro ~/ 10).toString(); //분을 의미하는 십의자리
      second_work_time_m = (work_onePomodoro % 10).toString(); //분을 의미하는 일의자리
      first_work_time_s = 0.toString(); //초를 의미하는 십의자리
      second_work_time_s = 0.toString(); //초를 의미하는 일의자리

      //break time
      first_break_time_m = (work_breakTime ~/ 10).toString(); //분을 의미하는 십의자리
      second_break_time_m = (work_breakTime % 10).toString(); //분을 의미하는 일의자리
      first_break_time_s = 0.toString(); //초를 의미하는 십의자리
      second_break_time_s = 0.toString(); //초를 의미하는 일의자리
    }

    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          color: c1,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: c2,
        centerTitle: true, //아이폰과 삼성 모두 가운데 정렬로 만듬
        title: Text(
          "Simple Pomodoro",
          style: TextStyle(fontSize: 22, color: c1),
        ),
      ),
      body: Container(
        color: c1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //작업하는 시간 화면 구현
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 120.0, left: 5),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      first_work_time_m.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      second_work_time_m.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 150.0, left: 5, right: 5),
                    child: Text(
                      "m",
                      style: TextStyle(fontSize: 30, color: c2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //SizedBox(width: 40),
                  Container(
                    margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      first_work_time_s.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      second_work_time_s.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 150.0, left: 5, right: 5),
                    child: Text(
                      "s",
                      style: TextStyle(fontSize: 30, color: c2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              //break 텍스트 추가하기

              //

              //휴식시간 화면
              SizedBox(height: 50),
              Row(
                children: [
                  SizedBox(
                    height: 120,
                    width: 5,
                  ),
                  Container(
                    //margin: EdgeInsets.only(top: 120.0, left: 5),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      first_break_time_m.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    //margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      second_break_time_m.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0, left: 5, right: 5),
                    child: Text(
                      "m",
                      style: TextStyle(fontSize: 30, color: c2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //SizedBox(width: 40),
                  Container(
                    // margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      first_break_time_s.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    //margin: EdgeInsets.only(top: 120.0),
                    width: 70,
                    height: 100,
                    color: c2,
                    child: Text(
                      second_break_time_s.toString(),
                      style: TextStyle(fontSize: 85, color: c1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0, left: 5, right: 5),
                    child: Text(
                      "s",
                      style: TextStyle(fontSize: 30, color: c2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // stop 버튼
              Container(
                margin:
                    EdgeInsets.only(top: 100), //위로만 바깥여백, 위에 블록과 거리를 두기 위해서.
                width: 128,
                height: 64,
                color: c2,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _clickButton();
                    });
                  },
                  child: Text(
                    stateText,
                    style: TextStyle(
                      color: c1,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Timer
  late Timer _timer;
  var _time = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // 특정 버튼을 누르면 타이머를 시작합니다.
  void _clickButton() {
    _isRunning = !_isRunning;
    if (stateText == "Start") {
      stateText = "Stop";
    } else {
      stateText = "Start";
    }
    if (_isRunning) {
      _start();
    } else {
      _pause();
    }
  }

  // Timer.periodic을 통해 setInterval과 같은 기능을 사용할 수 있습니다.
  // 여기서는 1초마다 _time을 1씩 증가시키도록 했습니다.
  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //_timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _time++;
        calculation_time();
      });
    });
  }

  // 정지 버튼을 누르면 타이머를 정지합니다.
  void _pause() {
    _timer.cancel();
  }

  void calculation_time() async {
    int min;
    int sec;

    //데이터를 저장하는 인스턴스 불러오기

    if (working) {
      sum_workTime -= 1;
      if (sum_workTime == -1) {
        //pomodoroSumCnt++; //총 뽀모도로 수 증가
        //pomodoroSumTime += work_onePomodoro;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int sum_counter = (prefs.getInt('sumCnt') ?? 0) + 1;
        int sum_time = (prefs.getInt('sumTime') ?? 0) + work_onePomodoro;
        await prefs.setInt('sumCnt', sum_counter);
        await prefs.setInt('sumTime', sum_time);
        print(sum_counter);
        print(sum_time);
        pomodoroSumCnt = sum_counter;
        pomodoroSumTime = sum_time;

        //
        sum_hour = pomodoroSumTime ~/ 60;
        sum_min = pomodoroSumTime % 60;

        if (work_pomodoroCnt == pomodoro_cnt + 1) {
          //모든 뽀모도로를 완료했을 때
          print("모든 뽀모도로 수행 완료");
          //stateText = "Clear"; //필요없는 줄임
          Navigator.pop(context);
        } else {
          sum_workTime = work_onePomodoro * 60;
          pomodoro_cnt++; //작업중인 뽀모도로 1개 완료
          resting = true; //휴식작업 준비
          working = false;
          //working time
          first_work_time_m =
              (work_onePomodoro ~/ 10).toString(); //분을 의미하는 십의자리
          second_work_time_m =
              (work_onePomodoro % 10).toString(); //분을 의미하는 일의자리
          first_work_time_s = 0.toString(); //초를 의미하는 십의자리
          second_work_time_s = 0.toString(); //초를 의미하는 일의자리
          _clickButton();
          print("작업량은 $work_pomodoroCnt");
          print("현재 카운트는 $pomodoro_cnt");

          //효과음 재생
          final player = AudioCache();
          player.play("DING.mp3");
        }
      } else {
        min = (sum_workTime ~/ 60); // ~/를 쓰면 정수형태로 계산함
        sec = sum_workTime % 60;

        first_work_time_m = (min ~/ 10).toString(); //분을 의미하는 십의자리
        second_work_time_m = (min % 10).toString(); //분을 의미하는 일의자리
        first_work_time_s = (sec ~/ 10).toString(); //초를 의미하는 십의자리
        second_work_time_s = (sec % 10).toString(); //초를 의미하는 일의자리
      }
    } else {
      //(breaking)
      //break time
      sum_breakTime -= 1;
      if (sum_breakTime == -1) {
        sum_breakTime = work_breakTime * 60;
        resting = false;
        working = true;
        //break time
        first_break_time_m = (work_breakTime ~/ 10).toString(); //분을 의미하는 십의자리
        second_break_time_m = (work_breakTime % 10).toString(); //분을 의미하는 일의자리
        first_break_time_s = 0.toString(); //초를 의미하는 십의자리
        second_break_time_s = 0.toString(); //초를 의미하는 일의자리
        final player = AudioCache();
        player.play("DING.mp3");
        _clickButton();
      } else {
        min = (sum_breakTime ~/ 60);
        sec = sum_breakTime % 60;

        first_break_time_m = (min ~/ 10).toString(); //분을 의미하는 십의자리
        second_break_time_m = (min % 10).toString(); //분을 의미하는 일의자리
        first_break_time_s = (sec ~/ 10).toString(); //초를 의미하는 십의자리
        second_break_time_s = (sec % 10).toString(); //초를 의미하는 일의자리
      }
    }
  }
}
