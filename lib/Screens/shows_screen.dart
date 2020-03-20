import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/ShowsController.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';

import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/Widgets/ShowsCard.dart';
import 'package:q8_pulse/Widgets/local_notification_helper.dart';
import 'package:q8_pulse/utils/app_Localization.dart';


class ShowsScreen extends StatefulWidget {
  bool valueMode ;
  bool notifyOrNo = false ;
  int guestId;

 List<int> listNotificationsId;
  ShowsScreen({this.valueMode,this.listNotificationsId ,this.notifyOrNo , this.guestId});
  createState() => ShowsView();
}

class ShowsView extends StateMVC<ShowsScreen> {
  ShowsView() : super(ShowsController()) {
    _showsController = ShowsController.con;
  }

  ShowsController _showsController;
  @override
  Widget build(BuildContext context) {
   


    Widget title() {
      return Text(
        DemoLocalizations.of(context).title['_shows'],
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/25,
          color:widget.valueMode == false ? Color(0xff585757) : Colors.white 
        ),
      );
    }

    Widget nullWedgit() {
      return Container(
        width: 25,
        height: 25,
      );
    }

    return Scaffold(
      appBar: AppBarWidget()
                  .showAppBar(context, SharedWidget.arrowBack(), title(), nullWedgit()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           
           
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                  stream: _showsController.getAllShowsStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print('shows has data ');
                      return _realPresentersData(snapshot.data);
                    } else {
                      return _splashPresenters();
                    }
                  },
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


    Widget _realPresentersData(List data) {
      if(data.length!=0){
    return   GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    physics: ClampingScrollPhysics(),
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ShowsCard(
                        data: data[index],
                        valueMode: widget.valueMode,
                        listNotificationsId: widget.listNotificationsId,
                        guestId: widget.guestId,


                      );
                    },
                  );}else{
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
  }

  Widget _splashPresenters() {
    return Center(child: CircularProgressIndicator(),);
  }

   initState(){
      print("hello Shows Screen"); 
      _showsController.getAllShows(context);
//      UserLocalStorage().getNotification().then((notificationsList){
//        print( "notifications is " + notificationsList.toString());
//        setState((){
//         widget.notified = notificationsList[1] as bool;
//        });
//      });
     checkPendingNotificationRequests(context)

         .then((listId){
       print("list"+listId.toString());
       if(listId.isEmpty){
         setState((){
           widget.listNotificationsId = [00];
         });
       }else {
         setState(() {
           widget.listNotificationsId = listId;
         });
       }

       print("list2"+widget.listNotificationsId.toString());


     });
        super.initState();
    }


}
