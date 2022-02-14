class UsersModel {
  String? displayName;
  String? email;
  String? userId;
  String? usdAccont;
  String? ngnAccount;
  String? euAccount;

  UsersModel({
    this.displayName,
    this.email,
    this.euAccount,
    this.ngnAccount,
    this.usdAccont,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'User_Name': displayName,
      'email': email,
      'usd_balance': usdAccont,
      'ngn_balance': ngnAccount,
      'eu_balance': euAccount,
    };
  }
}
