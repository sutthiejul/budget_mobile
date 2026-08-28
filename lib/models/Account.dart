// ignore_for_file: prefer_const_constructors, file_names
class Account {
  String aid;
  String userid;
  String passwords;
  String firstname;
  String lastname;
  int uid;
  String pic;
  String mobile;
  int uses;
  int login;

  //Account(this.aid, this.userid, this.passwords);
  Account({
    required this.aid,
    required this.userid,
    required this.passwords,
    required this.firstname,
    required this.lastname,
    required this.uid,
    required this.pic,
    required this.mobile,
    required this.uses,
    required this.login,
  });

  @override
  String toString() {
    return "aid=>$aid,userid=>$userid,passwords=>$passwords,firstname=>$firstname,lastname=>$lastname,uid=>$uid,pic=>$pic,mobile=>$mobile,uses=$uses,login=$login";
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      aid: json['aid'],
      userid: json['userid'],
      passwords: json['passwords'],
      firstname: json['firstname'],
      lastname: json['lastname'] ?? '',
      uid: int.parse(json['Uint']),
      pic: json['pic'] ?? '',
      mobile: json['mobile'] ?? '',
      uses: int.parse(json['uses']),
      login: int.parse(json['login']),
    );
  }

  Map<String, dynamic> toJson() => {
    'aid': aid,
    'userid': userid,
    'passwords': passwords,
    'firstname': firstname,
    'lastname': lastname,
    'uid': uid,
    'pic': pic,
    'mobile': mobile,
    'login': login,
    'uses': uses,
  };
}
