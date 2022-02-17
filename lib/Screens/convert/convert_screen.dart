import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simba_coding_project/models/ratesmodel.dart';
import 'package:simba_coding_project/services/Converter/fecth_rates.dart';
import '../../misc/app_colors.dart';
import '../../misc/utils.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';
import '../../widget/app_large_text.dart';
import '../../widget/app_text.dart';
import '../../widget/small_responsive.dart';

class ConvertScreen extends StatefulWidget {
  ConvertScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  Future<CurrencyRate>? result;
  Future<Map>? allcurrencies;
  final formkey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  //Getting Rates and All currencies
  String dropdownValue1 = 'USD';
  String dropdownValue2 = 'NGN';
  double? charge;
  bool? ready = false;

  String? answer;
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
    TransactionSelectionService transactionService =
        Provider.of<TransactionSelectionService>(context, listen: false);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 50,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
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
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppLargeText(
                                      text: 'Convert Currency',
                                    ),
                                    SizedBox(height: 20),

                                    //TextFields for Entering USD
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: TextFormField(
                                              controller: amountController,
                                              key: ValueKey('amount'),
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: 'Amount',
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.textColor1),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.textColor1),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          AppColors.textColor1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            value: dropdownValue1,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_rounded),
                                            iconSize: 24,
                                            elevation: 16,
                                            isExpanded: true,
                                            underline: Container(
                                              height: 2,
                                              color: AppColors.bigTextColor,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue1 = newValue!;
                                              });
                                            },
                                            items: currencysnapshot.data!.keys
                                                .toSet()
                                                .toList()
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text('To')),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: AppText(
                                            text: 'Rate ::$answer',
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: DropdownButton<String>(
                                            value: dropdownValue2,
                                            icon: const Icon(
                                                Icons.arrow_drop_down_rounded),
                                            iconSize: 24,
                                            elevation: 16,
                                            isExpanded: true,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.grey.shade400,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue2 = newValue!;
                                              });
                                            },
                                            items: currencysnapshot.data!.keys
                                                .toSet()
                                                .toList()
                                                .map<DropdownMenuItem<String>>(
                                                    (value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: 10,
                                            left: 10,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (amountController
                                                      .text.length >=
                                                  1) {
                                                setState(() {
                                                  ready = true;
                                                  answer = convertany(
                                                      snapshot.data!.rates,
                                                      amountController.text,
                                                      dropdownValue1,
                                                      dropdownValue2);
                                                });
                                              }
                                            },
                                            child: SmallResponsiveButton(
                                              text: 'Convert',
                                            ),
                                          ),
                                        ),
                                        ready!
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    charge = (5 / 100) *
                                                        double.parse(
                                                            amountController
                                                                .text);
                                                  });
                                                  transactionService
                                                          .transaction =
                                                      TransactionModel(
                                                    amount: double.parse(
                                                        amountController.text),
                                                    charge: charge,
                                                    exchanchangerate:
                                                        double.parse(answer!) -
                                                            charge!,
                                                    souceCurrency:
                                                        dropdownValue1,
                                                    targetCurrency:
                                                        dropdownValue2,
                                                  );

                                                  Utils.mainAppNav.currentState!
                                                      .pushNamed(
                                                    '/sendTo',
                                                  );
                                                  amountController.clear();
                                                },
                                                child: SmallResponsiveButton(
                                                  text: 'Send Funds',

                                                  //
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
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
