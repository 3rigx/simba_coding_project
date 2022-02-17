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
  late final double amount;
  late final double exchanchangerate;
  late final double souceCurrency;
  late final double targetCurrency;
  late final double charge;

  @override
  _SendToPageState createState() => _SendToPageState();
}

class _SendToPageState extends State<SendToPage> {
  String? dropdownValueId, reciverUID, reciverName;
  bool selectedcontact = false;
  TransactionModel? tran;
  @override
  void initState() {
    super.initState();
  }

  int? myIndex = 0;
  Widget build(BuildContext context) {
    TransactionSelectionService transactionService =
        Provider.of<TransactionSelectionService>(context, listen: false);

    Service _service = Provider.of<Service>(context, listen: false);

    UsersModel? user = _service.loggedInUser;

    tran = transactionService.transaction;

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
                    reciverUID = user.userId;
                    reciverName = user.displayName;
                    if (reciverName != null) {
                      selectedcontact = true;
                    }
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
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where('Id', isNotEqualTo: user.userId)
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

                          List<String>? whereAreYou = [];
                          for (int i = 0; i < data.length;) {
                            if (data[i]['UserName'] != null) {
                              whereAreYou.add(data[i]['UserName']);
                            }

                            i++;
                          }
                          return Container(
                            width: 150,
                            child: DropdownButton<String>(
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
                                  // myIndex = whereAreYou.indexOf(newValue!);
                                  setState(() {
                                    dropdownValueId = newValue;

                                    reciverUID =
                                        data[whereAreYou.indexOf(newValue!)]
                                            ['Id'];

                                    reciverName = newValue;

                                    if (reciverName != null) {
                                      selectedcontact = true;
                                    }
                                  });
                                },
                                items: whereAreYou
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(
                                          e,
                                        ),
                                        value: e,
                                      ),
                                    )
                                    .toList()),
                          );
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              selectedcontact
                  ? Container(
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
                            color: AppColors.mainColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              AppText(
                                text:
                                    'Sending:: ${tran!.souceCurrency} ${tran!.amount} ',
                                size: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AppText(
                                  size: 20,
                                  text:
                                      'At::  ${tran!.targetCurrency} ${tran!.exchanchangerate}'),
                              SizedBox(
                                height: 10,
                              ),
                              AppText(
                                  size: 20,
                                  text:
                                      'Charges::  ${tran!.souceCurrency} ${tran!.charge}'),
                              SizedBox(
                                height: 10,
                              ),
                              AppText(
                                  size: 20, text: 'To User::  $reciverName'),
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
                                    reciverName,
                                    reciverUID,
                                    tran!.souceCurrency,
                                    tran!.targetCurrency,
                                    tran!.exchanchangerate!,
                                    tran!.amount,
                                    tran!.charge);
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
                                      .pushReplacementNamed('/mainpage');
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
        ),
      ),
    );
  }
}
