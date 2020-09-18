import 'package:flutter/material.dart';
 
 

class GojekAppBar extends AppBar {
  
 
  //GojekAppBar(this.name, this.age);

  GojekAppBar(): super( 
      titleSpacing: 0.0,  
      automaticallyImplyLeading: false,
      elevation: 0.25, 
      backgroundColor: Colors.white, 
      brightness : Brightness.light,
      flexibleSpace: _buildGojekAppBar()
  ); 

  static Widget _buildGojekAppBar() {
    
    return   Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child:   Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Image.asset(
            'assets/img_gojek_logo.png',
            height: 50.0,
            width: 100.0,
          ),
            Container(
            child:   Row(
              children: <Widget>[
                 /* Container(
                  height: 28.0,
                  width: 28.0,
                  padding: EdgeInsets.all(6.0),
                  decoration:   BoxDecoration(
                      borderRadius:
                            BorderRadius.all(  Radius.circular(100.0)),
                      color: Colors.orangeAccent),
                  alignment: Alignment.centerRight,
                  child:   Icon(
                    Icons.local_bar,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),*/
                  Container(
                  padding: EdgeInsets.all(6.0),
                  decoration:   BoxDecoration(
                      borderRadius: BorderRadius.all(  Radius.circular(5.0)),
                      color: Color(0x50FFD180)),
                  child:   Text(
                    '1.781 poin',
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
