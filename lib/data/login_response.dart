import 'package:flutter/material.dart';

@immutable
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String planterId;
  final DateTime expiryDate;

  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.expiryDate,
    this.planterId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        planterId: json['planterId'] as String,
        expiryDate: DateTime.tryParse(json['expiryDate'] as String ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiryDate': expiryDate?.toIso8601String(),
        'planterId': planterId,
      };
}
