// To parse this JSON data, do
//
//     final currencyRate = currencyRateFromJson(jsonString);

import 'dart:convert';

CurrencyRate currencyRateFromJson(String str) =>
    CurrencyRate.fromJson(json.decode(str));

String currencyRateToJson(CurrencyRate data) => json.encode(data.toJson());

class CurrencyRate {
  CurrencyRate({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  String disclaimer;
  String license;
  int timestamp;
  String base;
  Map<String, double> rates;

  factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
        disclaimer: json["disclaimer"],
        license: json["license"],
        timestamp: json["timestamp"],
        base: json["base"],
        rates: Map.from(json["rates"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "disclaimer": disclaimer,
        "license": license,
        "timestamp": timestamp,
        "base": base,
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
