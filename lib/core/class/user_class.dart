class PUser {
  PUser(
      {this.id,
      this.firstName,
      this.longName,
      this.nip,
      this.email,
      this.phoneNumber,
      this.password,
      this.isPhoneNumberVerified,
      this.isEmailVerified,
      this.role,
      this.refId,
      this.foreignRefId,
      this.address});
  String? id;
  String? firstName;
  String? longName;
  String? nip;
  String? email;
  String? phoneNumber;
  String? password;
  bool? isPhoneNumberVerified;
  bool? isEmailVerified;
  String? role;
  String? refId;
  String? foreignRefId;
  String? address;
}
