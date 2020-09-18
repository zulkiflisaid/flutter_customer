class HistoryCari {
  int _id;
  String _name; 
  String _tgl; 
  // konstruktor versi 1
  HistoryCari(this._name, this._tgl );

  // konstruktor versi 2: konversi dari Map ke HistoryCari
  HistoryCari.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name']; 
    this._tgl = map['tgl']; 
  }
  //getter dan setter (mengambil dan mengisi data kedalam object)
  // getter
  int get id => _id;
  String get name => _name; 
  String get tgl => _tgl; 
  // setter  
  set name(String value) {
    _name = value;
  } 
  set  tgl(String value) {
    _tgl = value;
  }

   
  // konversi dari Contact ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name; 
    map['tgl'] = tgl; 
    return map;
  }  

}