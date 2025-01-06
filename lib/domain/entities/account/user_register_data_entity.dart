class UserRegisterDataEntity {
  String? email;
  String? otpKey;
  String? resendOtpKey;

  UserRegisterDataEntity({
    this.email,
    this.otpKey,
    this.resendOtpKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp_key': otpKey,
      'resend_otp_key': resendOtpKey,
    };
  }

  factory UserRegisterDataEntity.fromJson(Map<String, dynamic> json) {
    return UserRegisterDataEntity(
      email: json['email'],
      otpKey: json['otp_key'],
      resendOtpKey: json['resend_otp_key'],
    );
  }
}
