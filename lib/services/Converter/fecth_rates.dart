import 'package:http/http.dart' as http;
import 'package:simba_coding_project/models/allcurrencies.dart';
import 'package:simba_coding_project/models/ratesmodel.dart';
import 'package:simba_coding_project/services/Converter/openexchangekey.dart';

Future<CurrencyRate> fetchrates() async {
  var response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/latest.json?app_id=' +
          openexchangekeykey));

  final result = currencyRateFromJson(response.body);
  return result;
}

Future<Map> fetchcurencies() async {
  var response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/currencies.json?app_id=' +
          openexchangekeykey));
  final allCurrencies = currencyGetFromJson(response.body);
  return allCurrencies;
}

double convertany(
    Map exchangeRates, String amount, String curencybase, currencyFinal) {
  double output = double.parse(amount) /
      exchangeRates[curencybase] *
      exchangeRates[currencyFinal];

  return output;
}
