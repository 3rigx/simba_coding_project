import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/misc/utils.dart';
import 'package:simba_coding_project/services/Converter/fecth_rates.dart';
import 'package:simba_coding_project/services/transaction_service.dart';
import 'package:simba_coding_project/widget/app_large_text.dart';
import 'package:simba_coding_project/widget/app_text.dart';
import 'package:simba_coding_project/widget/responsive_button.dart';

class ConvertToWidget extends StatefulWidget {
  final rates;
  final Map currencies;

  ConvertToWidget({
    Key? key,
    @required this.rates,
    required this.currencies,
  }) : super(key: key);

  @override
  _ConvertToWidgetState createState() => _ConvertToWidgetState();
}

class _ConvertToWidgetState extends State<ConvertToWidget> {
  TextEditingController amountController = TextEditingController();

  String dropdownValue1 = 'USD';
  String dropdownValue2 = 'NGN';
  double? answer, rate, charge;
  bool? isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    TransactionSelectionService transactionSelectionService =
        Provider.of<TransactionSelectionService>(context, listen: false);

    return Card(
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
                TextFormField(
                  key: ValueKey('amount'),
                  controller: amountController,
                  decoration: InputDecoration(hintText: 'You send'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: dropdownValue1,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
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
                    items: widget.currencies.keys
                        .toSet()
                        .toList()
                        .map<DropdownMenuItem<String>>((value) {
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
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text('To')),
            SizedBox(height: 10),
            Row(
              children: [
                AppText(
                  text: 'Rate ::$answer',
                  color: AppColors.mainColor,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: dropdownValue2,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
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
                    items: widget.currencies.keys
                        .toSet()
                        .toList()
                        .map<DropdownMenuItem<String>>((value) {
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
            Row(
              children: [
                Container(
                  height: 20,
                  width: 40,
                  margin: EdgeInsets.only(
                    right: 10,
                    left: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        charge = 5 / 100 * double.parse(amountController.text);
                        transactionSelectionService.transactionService.amount =
                            double.parse(amountController.text);
                        rate = convertany(widget.rates, amountController.text,
                            dropdownValue1, dropdownValue2);
                      });
                    },
                    child: ResponsiveButton(
                      text: 'Convert',
                      isResponsive: true,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    setState(() {
                      transactionSelectionService.transactionService.amount =
                          double.parse(amountController.text);
                      transactionSelectionService.transactionService
                          .exchanchangerate = charge! - rate!;

                      transactionSelectionService
                          .transactionService.souceCurrency = dropdownValue1;
                      transactionSelectionService
                          .transactionService.targetCurrency = dropdownValue2;
                      transactionSelectionService.transactionService.charge =
                          charge;
                    });
                    Utils.mainAppNav.currentState!.pushNamed('/sendTo');
                  },
                  child: ResponsiveButton(
                    text: 'Convert',
                    isResponsive: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
