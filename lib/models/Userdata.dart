class Userdata{
  String email = "";
  String name = "";

  static const String TABLE = "userdata";
  static final columns = ["email", "name"]; 

  Userdata({this.email, this.name});

  factory Userdata.fromJson(Map<String, dynamic> json) {
    //print(json);
    return Userdata(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

   factory Userdata.fromMap(Map<String, dynamic> data) {
      return Userdata( 
         name: data['name'], 
         email : data['email']
      ); 
   } 
   

  Map<String, dynamic> toMap() => {
      "name": name, 
      "email": email
   };
}