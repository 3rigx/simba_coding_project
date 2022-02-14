import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/misc/utils.dart';
import 'package:simba_coding_project/models/transaction_model.dart';
import 'package:simba_coding_project/models/users_model.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/services/transaction_service.dart';
import 'package:simba_coding_project/widget/app_large_text.dart';
import 'package:simba_coding_project/widget/app_text.dart';
import 'package:simba_coding_project/widget/responsive_button.dart';

class SendToPage extends StatefulWidget {
  TransactionModel? _transactionModel;

  @override
  _SendToPageState createState() => _SendToPageState();
}

class _SendToPageState extends State<SendToPage> {
  String dropdownValueId = 'Someone Else';
  bool selectedcontact = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionSelectionService transaction =
        Provider.of<TransactionSelectionService>(context, listen: false);
    Service _service = Provider.of<Service>(context, listen: false);

    UsersModel? user = _service.loggedInUser;
    widget._transactionModel = transaction.transactionService;

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLargeText(
                text: 'Select your recipient',
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedcontact = true;
                    transaction.transactionService.receiverUid = user.userId;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Icon(Icons.addchart),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    AppText(text: 'Myself'),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Icon(Icons.people),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where('Id', isNotEqualTo: user.userId)
                            .orderBy('Email')
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              snapshot.hasData != true) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            var data = snapshot.data!.docs;

                            return DropdownButton<String>(
                              value: dropdownValueId,
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                              iconSize: 24,
                              elevation: 16,
                              isExpanded: true,
                              underline: Container(
                                height: 2,
                                color: AppColors.bigTextColor,
                              ),
                              onChanged: (String? newValue) {
                                int myIndex;
                                List<String>? whereAreYou;
                                for (int i = 0; i <= data.length; i++) {
                                  whereAreYou!.add(data[i]['name']);
                                }
                                myIndex = whereAreYou!.indexOf(newValue!);
                                setState(() {
                                  dropdownValueId = newValue;

                                  transaction.transactionService.receiverUid =
                                      data[myIndex]['UserID'];

                                  transaction.transactionService.receiverName =
                                      newValue;

                                  if (dropdownValueId != 'Someone Else') {
                                    selectedcontact = true;
                                  }
                                });
                              },
                              items: [
                                for (int i = 0; i <= data.length; i++)
                                  DropdownMenuItem(
                                    child: Text(data[i]['name']),
                                    value: data[i]['name'],
                                  ),
                              ],
                            );
                          }
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  selectedcontact
                      ? Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(.5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppLargeText(
                                text: 'Confirm Details',
                                color: AppColors.bigTextColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  AppText(
                                    text:
                                        'Sending ${transaction.transactionService.souceCurrency} ${transaction.transactionService.amount} ',
                                  ),
                                  AppText(
                                      text:
                                          'At  ${transaction.transactionService.targetCurrency} ${transaction.transactionService.exchanchangerate}'),
                                  AppText(
                                      text:
                                          'Charges ${transaction.transactionService.charge}'),
                                  AppText(
                                      text:
                                          'To ${transaction.transactionService.receiverName}'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                  onTap: () async {
                                    bool succes = await Service().sendMoney(
                                        user.userId!,
                                        user.displayName,
                                        widget._transactionModel!.receiverName,
                                        widget._transactionModel!.receiverUid,
                                        widget._transactionModel!.souceCurrency,
                                        widget
                                            ._transactionModel!.targetCurrency,
                                        widget._transactionModel!
                                            .exchanchangerate!,
                                        widget._transactionModel!.amount,
                                        widget._transactionModel!.charge);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: CircularProgressIndicator(),
                                        duration: succes
                                            ? const Duration(seconds: 1)
                                            : const Duration(minutes: 10),
                                      ),
                                    );
                                    if (succes) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      Utils.mainAppNav.currentState!
                                          .pushNamed('/mainpage');
                                    }
                                  },
                                  child: ResponsiveButton(
                                    isResponsive: true,
                                    text: 'SEND',
                                  )),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
