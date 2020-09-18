import 'package:flutter/material.dart';

class GojekService<T> {
  GojekService({this.image, this.title, this.color});
  IconData image;
  Color color;
  String title;
  //void addListener(VoidCallback listener);
}

class Food<T> {
  Food(
      {this.idresto,
      this.idMenu,
      this.nmMmenu,
      this.ketMenu,
      this.hrg,
      this.img_menu});
  String idresto;
  String idMenu;
  String nmMmenu;
  String ketMenu;
  int hrg;
  String img_menu;
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      idresto: json['id_resto'],
      idMenu: json['idMenu'],
      nmMmenu: json['nm_menu'],
      ketMenu: json['ket_menu'],
      hrg: json['hrg'],
      img_menu: json['img'],
    );
  }
}

class ItemMenuResto<T> {
  ItemMenuResto(
      {this.idresto,
      this.idMenu,
      this.nmMenu,
      this.img_menu,
      this.hrg,
      this.qity,
      this.subTotal,
      this.ketMenu,
      this.kategori});
  String idresto;
  String idMenu;
  String nmMenu;
  String img_menu;
  int hrg;
  int qity;
  int subTotal;
  String ketMenu;
  String kategori;
}

class Promo<T> {
  Promo({this.image, this.title, this.content, this.button});
  String image;
  String title;
  String content;
  String button;
}
