class Promosi {
  Promosi({this.id, this.title, this.message, this.actionClick, this.image});
  final int id;
  final String title;
  final String message;
  final String actionClick;
  final String image;
  factory Promosi.fromJson(Map<String, dynamic> json) {
    return Promosi(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        actionClick: json['action_click'],
        image: json['image']);
  }
}

class TopUp {
  //`id`, `code_transfer`, `user_category`, `user_id`, `bank_id`, `amount`,
  //`is_verification`, `img_struck`, `created_at`, `updated_at`
  TopUp(
      {this.id,
      this.code_transfer,
      this.user_category,
      this.user_id,
      this.bank_id,
      this.no_rek,
      this.nm_short,
      this.nm_long,
      this.owner,
      this.url_logo,
      this.amount,
      this.is_verification,
      this.img_struck,
      this.created_at,
      this.updated_at});
  final int id;
  final String code_transfer;
  final String user_category;
  final int user_id;
  final int bank_id;
  final String no_rek;
  final String nm_short;
  final String nm_long;
  final String owner;
  final String url_logo;
  final int amount;
  final int is_verification;
  final String img_struck;
  final String created_at;
  final String updated_at;
  factory TopUp.fromJson(Map<String, dynamic> json) {
    return TopUp(
        id: json['id'],
        code_transfer: json['code_transfer'],
        user_category: json['user_category'],
        user_id: json['user_id'],
        bank_id: json['bank_id'],
        no_rek: json['banks']['no_rek'],
        nm_short: json['banks']['nm_short'],
        nm_long: json['banks']['nm_long'],
        owner: json['banks']['owner'],
        url_logo: json['banks']['url_logo'],
        amount: json['amount'],
        is_verification: json['is_verification'],
        img_struck: json['img_struck'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }
}

class Bank {
  Bank({this.id, this.nm_long, this.nm_short});
  final int id;
  final String nm_long;
  final String nm_short;
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
        id: json['id'], nm_long: json['nm_long'], nm_short: json['nm_short']);
  }
}

//class untuk data orderan yg di terima oleh driver
class OrderanJson {
  OrderanJson(
      this.category_driver,
      this.total_prices,
      this.pay_categories,
      this.driver,
      this.driver_uid,
      this.driver_avatar,
      this.driver_hp,
      this.driver_bintang,
      this.driver_trip,
      this.driver_gcm,
      this.jemput_judul,
      this.jemput_alamat,
      this.jemput_ket,
      this.tujuan_judul,
      this.tujuan_alamat);

  OrderanJson.fromJson(Map<dynamic, dynamic> json)
      : category_driver = json['category_driver'],
        total_prices = json['total_prices'],
        pay_categories = json['pay_categories'],
        driver = json['driver'],
        driver_uid = json['driver_uid'],
        driver_avatar = json['driver_avatar'],
        driver_hp = json['driver_hp'],
        driver_bintang = json['driver_bintang'],
        driver_trip = json['driver_trip'],
        driver_gcm = json['driver_gcm'],
        jemput_judul = json['jemput_judul'],
        jemput_alamat = json['jemput_alamat'],
        jemput_ket = json['jemput_ket'],
        tujuan_judul = json['tujuan_judul'],
        tujuan_alamat = json['tujuan_alamat'];

  final String category_driver;
  final String total_prices;
  final String pay_categories;
  final String driver;
  final String driver_uid;
  final String driver_avatar;
  final String driver_hp;
  final String driver_bintang;
  final String driver_trip;
  final String driver_gcm;
  final String jemput_judul;
  final String jemput_alamat;
  final String jemput_ket;
  final String tujuan_judul;
  final String tujuan_alamat;
  Map<dynamic, dynamic> toJson() => {
        'category_driver': category_driver,
        'total_prices': total_prices,
        'pay_categories': pay_categories,
        'driver': driver,
        'driver_md5': driver_uid,
        'driver_avatar': driver_avatar,
        'driver_hp': driver_hp,
        'driver_bintang': driver_bintang,
        'driver_trip': driver_trip,
        'driver_gcm': driver_gcm,
        'jemput_judul': jemput_judul,
        'jemput_alamat': jemput_alamat,
        'jemput_ket': jemput_ket,
        'tujuan_judul': tujuan_judul,
        'tujuan_alamat': tujuan_alamat,
      };
}

// clas item kusioner batal
class KusionersList {
  KusionersList({this.name, this.index});
  String name;
  int index;
}

//harga
class DriverPrice {
  DriverPrice(
      {this.id,
      this.category_driver,
      this.charge,
      this.distance_looping_km,
      this.price_per_km,
      this.price_looping_km,
      this.basic_price,
      this.price_cash,
      this.price_deposit,
      this.point_transaction});
  final int id;
  final String category_driver;
  final int charge;
  final int distance_looping_km;
  final int price_per_km;
  final int price_looping_km;
  final int basic_price;
  final int price_cash;
  final int price_deposit;
  final int point_transaction;
  factory DriverPrice.fromJson(Map<String, dynamic> json) {
    return DriverPrice(
        id: json['id'],
        category_driver: json['category_driver'],
        charge: json['charge'],
        distance_looping_km: json['distance_looping_km'],
        price_per_km: json['price_per_km'],
        price_looping_km: json['price_looping_km'],
        //basic_price: 4000, // json['basic_price']
        price_cash: json['price_cash'],
        price_deposit: json['price_deposit'],
        point_transaction: json['point_transaction']);
  }
}

class ChatItem {
  ChatItem(
      {this.id,
      this.idFrom,
      this.idTo,
      this.type,
      this.content,
      this.timestamp});
  final String id;
  final String idFrom;
  final String idTo;
  final int type;
  final String content;
  final String timestamp;

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
        id: json['id'],
        idFrom: json['idFrom'],
        idTo: json['idTo'],
        type: json['type'],
        content: json['content'],
        timestamp: json['timestamp']);
  }
}
