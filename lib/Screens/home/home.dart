import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simba_coding_project/misc/app_colors.dart';
import 'package:simba_coding_project/models/users_model.dart';
import 'package:simba_coding_project/services/services.dart';
import 'package:simba_coding_project/widget/app_large_text.dart';
import 'package:simba_coding_project/widget/app_text.dart';
import 'package:simba_coding_project/widget/userName.dart';

import '../../misc/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var balance = {
    'USD': '0',
    'NGN': '0',
    'EUR': '0',
  };

  @override
  Widget build(BuildContext context) {
    Service _service = Provider.of<Service>(context, listen: false);

    UsersModel? user = _service.loggedInUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 70,
                left: 20,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await _service.signOut();

                      Utils.mainAppNav.currentState!
                          .pushReplacementNamed('/welcomepage');
                    },
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                    ),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20,
              ),
              child: Row(
                children: [
                  AppLargeText(
                    text: 'Welcome',
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  UserName(),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),
            //acccount balance
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 100,
              width: double.maxFinite,
              /**/
              child: StreamBuilder<DocumentSnapshot<dynamic>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.userId)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went Wrong, Check Data Connecton',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: 'No Transaction To Report',
                              ),
                            ],
                          ),
                        );
                      }
                      var data = snapshot.data!;

                      return ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 15, top: 10),
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.mainColor,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AppText(
                                    text: balance.keys.elementAt(index),
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppText(
                                    text: data[balance.keys.elementAt(index)]
                                        .toString(),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppLargeText(
                    text: 'Transactions',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.userId)
                          .collection('Transaction')
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Something went Wrong, Check Data Connecton',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    text: 'No Transaction To Report',
                                  ),
                                ],
                              ),
                            );
                          }
                          var data = snapshot.data!.docs;

                          return DataTable2(
                              columnSpacing: 12,
                              horizontalMargin: 12,
                              minWidth: 600,
                              columns: [
                                DataColumn2(
                                  label: Text('ID'),
                                  size: ColumnSize.M,
                                ),
                                DataColumn(
                                  label: Text('From'),
                                ),
                                DataColumn(
                                  label: Text('To'),
                                ),
                                DataColumn(
                                  label: Text('Value'),
                                ),
                                DataColumn(
                                  label: Text('Currency'),
                                ),
                                DataColumn(
                                  label: Text('Created At'),
                                ),
                                DataColumn(
                                  label: Text('Updated At'),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                  snapshot.data!.size,
                                  (index) => DataRow(cells: [
                                        DataCell(AppText(
                                          text: '${index + 1}',
                                        )),
                                        DataCell(AppText(
                                          text: '${data[index]['Sender']}',
                                        )),
                                        DataCell(AppText(
                                          text: '${data[index]['Receiver']}',
                                        )),
                                        DataCell(
                                          AppText(
                                            text: ' ${data[index]['Amount']}',
                                            color: Colors.lightGreen,
                                          ),
                                        ),
                                        DataCell(
                                          AppText(
                                            text: '${data[index]['Curency']} ',
                                          ),
                                        ),
                                        DataCell(
                                          AppText(
                                            text:
                                                '${data[index]['TransactionDate']}',
                                          ),
                                        ),
                                        DataCell(
                                          AppText(
                                            text:
                                                '${data[index]['UpdateDate']}',
                                          ),
                                        ),
                                      ])));
                        }
                      }),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
