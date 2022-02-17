import 'package:flutter/cupertino.dart';
import 'package:simba_coding_project/models/transaction_model.dart';

class TransactionSelectionService extends ChangeNotifier {
  TransactionModel? _transaction;

  TransactionModel get transaction => _transaction!;
  set transaction(TransactionModel value) {
    _transaction = value;
    notifyListeners();
  }
}
