import 'package:flutter/material.dart';
import 'package:simba_coding_project/Screens/convert/widget/convert_to.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/models/ratesmodel.dart';
import 'package:simba_coding_project/services/Converter/fecth_rates.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({Key? key}) : super(key: key);

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  late Future<CurrencyRate> result;
  late Future<Map> allcurrencies;
  final formkey = GlobalKey<FormState>();

  //Getting Rates and All currencies

  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
      allcurrencies = fetchcurencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: FutureBuilder<CurrencyRate>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: FutureBuilder<Map>(
                      future: allcurrencies,
                      builder: (context, currencysnapshot) {
                        if (currencysnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConvertToWidget(
                                rates: snapshot.data!,
                                currencies: currencysnapshot.data!),
                          ],
                        );
                      },
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
