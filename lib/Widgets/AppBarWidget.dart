import 'package:flutter/material.dart';

class AppBarWidget {
  Widget showAppBar(BuildContext context, Widget widget, Widget centerWidget,
      Widget widget4) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
          child: Padding(
        padding: const EdgeInsets.only(top: 35 , left: 16 , right: 16),
        child: Column(
          children: <Widget>[
             Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget,
                    centerWidget,
                    widget4,
                  ],
                ),
              
           
          ],
        ),
      ),
    );
  }
}
