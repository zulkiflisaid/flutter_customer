import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZulLib{
   
  bintang(counterReputation, divideReputation)   {
       
        double counterReputation1=0.0;   
        var bintang=0.0; 
        if (counterReputation is int){  
           counterReputation1 = counterReputation.toDouble(); 
           if (counterReputation1!=0.0 && divideReputation!=0 ){

             bintang = counterReputation1  / divideReputation  ;
             int fac = pow(10, 1); 
              bintang = (bintang * fac).round() / fac;  
           }  
        } else{ 
              if (counterReputation!=0.0 && divideReputation!=0 ){
                counterReputation1 = counterReputation;  //-0.5; 
                bintang = counterReputation1  / divideReputation  ;
                int fac = pow(10, 1); 
                bintang = ((bintang ) * fac).round() / fac;  
           }  
        }  
 
        return  bintang;
    }

  Map<String,dynamic>   bukaOrtutup(  bukaData)   {
       var bukaOrtutup=''; 
       
         DateTime date =    DateTime.now();
        TimeOfDay now = TimeOfDay.now();
        // print("weekday is ${now.hour}");
        // print("weekday is ${now.hour}");
        int testDateInMinutes = now.hour * 60 + now.minute;
         //  print("weekday is $testDateInMinutes");
         // print("weekday is ${date.weekday}"); 
            int bukaMinute=0 ;
            int tutupMinute=0;
          
          Map<String,dynamic> bukaJam=  bukaData['${date.weekday}'];
          Map<String,dynamic> tutupJam= bukaData['${date.weekday}'];
          //print("weekday is ${buka['senin']}");  
          
          bukaMinute=bukaJam['a'];
          tutupMinute=tutupJam['b']; 

        //  print(' $testDateInMinutes ${date.weekday}');  
        //  print('a $bukaMinute  ');  
         // print('b $tutupMinute'); 

          if(testDateInMinutes >= bukaMinute && testDateInMinutes <= tutupMinute ){
            bukaOrtutup  ="Buka" ;  
          }else{
            bukaOrtutup  ="Tutup";  
          }
         var jambuka=  bukaMinute  / 60   ;
         int minutbuka= (bukaMinute  % 60);

         var jamtutup=  tutupMinute  / 60   ;
         int minuttutup= (tutupMinute  % 60);
   
         int  buka1=  jambuka.toInt() ;
         int  tutup1=  jamtutup.toInt()   ; 
         var  buka=  buka1.toString().length==1 ? '0${jambuka.toInt()}':'${jambuka.toInt()}'   ;
         var  tutup=  tutup1.toString().length==1 ? '0${jamtutup.toInt()}':'${jamtutup.toInt()}'   ;
       
         var  minutbuka1=  minutbuka.toString().length==1 ? '0$minutbuka':'$minutbuka'   ;
         var  minuttutup1=  minuttutup.toString().length==1 ? '0$minuttutup':'$minuttutup'   ;
       
       
        return  {
                 'status': bukaOrtutup, 
                 'buka': '$buka:$minutbuka1 ' , 
                 'tutup': '$tutup:$minuttutup1 ' ,  
           };
    }

  double calculateDistance( GeoPoint geoNya ,LatLng _initialPosition){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((geoNya.latitude - _initialPosition.latitude) * p)/2 + 
          c(_initialPosition.latitude * p) * c(geoNya.latitude * p) * 
          (1 - c((geoNya.longitude - _initialPosition.longitude) * p))/2;

    var h = 12742 * asin(sqrt(a)) ;    
    int fac = pow(10, 2); 
    h = (h * fac).round() / fac; 
    return   h   ;
  }
  
  getDistansDirectionGoogle() async  {  
       String p = '3.017453292519943295';
        return  p   ;
  }  
 
  Widget widgetResto(String img){ 
   return CachedNetworkImage(
            imageUrl:img,
            fit: BoxFit.cover,filterQuality:FilterQuality.medium ,
            height: 100, 
            width: 100,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
      ) ;
  } 
}   