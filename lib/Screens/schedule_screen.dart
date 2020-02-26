import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/ScheduleController.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/ScheduleCard.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class ScheduleScreen extends StatefulWidget {
  bool valueMode;
  ScheduleScreen({this.valueMode});
  createState() => ScheduleView();
}

class ScheduleView extends StateMVC<ScheduleScreen> {
  ScheduleView() : super(ScheduleController()) {
    _scheduleController = ScheduleController.con;
  }
  ScheduleController _scheduleController;

  initState() {
    super.initState();

    _scheduleController.getChedule_1();
    _scheduleController.getChedule_2();
    _scheduleController.getChedule_3();
    _scheduleController.getChedule_4();
    _scheduleController.getChedule_5();
    _scheduleController.getChedule_6();
    _scheduleController.getChedule_7();
  }

  Widget arrowBack() {
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.valueMode == true
                    ? "assets/imgs/ic_back@3x.png"
                    : "assets/imgs/Chevron.png"))),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget title() {
    return Text(
      DemoLocalizations.of(context).title['_schedule'],
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/25,
          color: widget.valueMode == false ? Color(0xff585757) : Colors.white),
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBarWidget()
          .showAppBar(context, arrowBack(), title(), nullWedgit()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_saturday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/23, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream1.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Saturday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Saturday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_sunday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream2.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Sunday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Sunday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                 DemoLocalizations.of(context).title['_monday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream3.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Monday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Monday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_tuesday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream4.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Thursday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Thursday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_wednesday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream5.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Wednesday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Wednesday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_thursday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream6.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Thursday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Thursday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DemoLocalizations.of(context).title['_friday'],
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width/25, color: Colors.grey[500]),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                child: StreamBuilder(
                  stream: _scheduleController.getScheduleStream7.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(' that is Friday data ');
                      return _realScheduleData(snapshot.data);
                    } else {
                      print(' Friday has not data :::');
                      return _splashSchedule(snapshot.data);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _realScheduleData(List data) {
    if (data.length!=0) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ScheduleCard(
            data: data[index],
          );
        },
      );
    } else {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height/7,
          width: MediaQuery.of(context).size.width/3.5,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/88.8-Final-logo.png"),
                  )),
        ),
      );
    }
  }

  Widget _splashSchedule(List data) {
    if (data != null) {
      return Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/empty.png"),
                  fit: BoxFit.cover)),
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
