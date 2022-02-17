import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simba_coding_project/models/users_model.dart';

class Service {
  Service() {
    Firebase.initializeApp();
  }
  bool googleUserLog = false;
  UsersModel? _usermodel;

  UsersModel get loggedInUser => _usermodel!;

  Future<bool> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = (await googleSignIn.signIn());

    if (googleUser == null) {
      return false;
    }

    //obtain the auth details from the request
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    // create a new Credentail
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    ) as GoogleAuthCredential;

    //once signed in return the userCredential
    UserCredential userCreds =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCreds.user != null) {
      googleUserLog = true;
      _usermodel = UsersModel(
          displayName: userCreds.user!.displayName,
          email: userCreds.user!.email,
          userId: userCreds.user!.uid);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCreds.user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          //User already exits
          print('user exits');
          return;
        } else {
          addNewUser(userCreds.user!.uid, userCreds.user!.displayName,
              userCreds.user!.email);
          sendMoney('001', 'New User Funds', userCreds.user!.displayName,
              userCreds.user!.uid, 'USD', 'USD', 1000, 1000, 0.00);
        }
      });
    }
    return true;
  }

  Future<bool> signInWithEmail(String email, password) async {
    try {
      UserCredential userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCreds.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCreds.user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            _usermodel = UsersModel(
                displayName: userCreds.user!.displayName,
                email: userCreds.user!.email,
                userId: userCreds.user!.uid);
            return false;
          } else {
            return false;
          }
        });
      }
      return true;
    } catch (e) {
      print('this is the error $e');
      return false;
    }
  }

  Future<bool> register(String email, password, name) async {
    try {
      UserCredential userCreds = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCreds.user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCreds.user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            return false;
          } else {
            addNewUser(userCreds.user!.uid, name, userCreds.user!.email)
                .then((value) {
              sendMoney("001", 'New User Funds', name, userCreds.user!.uid,
                  "USD", "USD", 1000, 1000, 0.00);
              userCreds.user!.updateDisplayName(name);
            });

            return true;
          }
        });
      }
      return true;
    } catch (e) {
      print('this is the error $e');
      return false;
    }
  }

  Future<void> addNewUser(
    String userid,
    displayname,
    email,
  ) {
//call the user's collectionReference to add a new user
    CollectionReference newUser =
        FirebaseFirestore.instance.collection('users');

    return newUser
        .doc(userid)
        .set({
          'UserName': displayname,
          'Email': email,
          'USD': 0,
          'NGN': 0,
          'EUR': 0,
          'Id': userid
        })
        .then((value) => print('user added'))
        .catchError((onError) => {if (onError.code == 'Handsake') {}});
  }

  Future<bool> sendMoney(
    String? senderUid,
    sendername,
    receivername,
    receiverUid,
    souceCurrency,
    targetCurrency,
    double exchanchangerate,
    amount,
    charge,
  ) async {
    double? myGain, source, reciverSource, balance;

    CollectionReference newUser =
        FirebaseFirestore.instance.collection('users');

    await newUser
        .doc(senderUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get(souceCurrency) is int) {
          source = documentSnapshot.get(souceCurrency).roundToDouble();
        } else {
          source = documentSnapshot.get(souceCurrency);
        }
      } else {
        return false;
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get(targetCurrency) is int) {
          reciverSource = documentSnapshot.get(targetCurrency).roundToDouble();
        } else {
          reciverSource = documentSnapshot.get(targetCurrency);
        }
      } else {
        return false;
      }
    });

    balance = source;
    if (balance! <= amount) {
      return false;
    } else {
      balance = balance - amount.roundToDouble();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .collection('Transaction')
          .add({
        'Sender': sendername,
        'Receiver': receivername,
        'Amount': exchanchangerate,
        'Curency': targetCurrency,
        'TransactionDate': _getTime(),
        'UpdateDate': _getTime(),
      }).then((value) {
        FirebaseFirestore.instance.collection('users').doc(receiverUid).update({
          '$targetCurrency': reciverSource! + exchanchangerate,
        });
      });

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('moneyGotten')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get(souceCurrency) is int) {
            myGain = documentSnapshot.get(souceCurrency).roundToDouble();
          } else {
            myGain = documentSnapshot.get(souceCurrency);
          }
        }
      });

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('moneyGotten')
          .update({'$souceCurrency': myGain! + charge});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderUid)
          .collection('Transaction')
          .add({
        'Sender': sendername,
        'Receiver': receivername,
        'Amount': amount,
        'Curency': souceCurrency,
        'TransactionDate': _getTime(),
        'UpdateDate': _getTime(),
      }).then((value) {
        FirebaseFirestore.instance.collection('users').doc(senderUid).update({
          '$souceCurrency': balance,
        });
      });
    }

    return true;
  }

  Future<void> signOut() async {
    if (googleUserLog) {
      await FirebaseAuth.instance.signOut();
    } else {
      await GoogleSignIn().signOut();
    }

    _usermodel = null;
  }

  bool isUserLoggedIn() {
    return _usermodel != null;
  }

  String _getTime() {
    List months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    var now = new DateTime.now();
    int currentMon = now.month;
    String datee =
        '${months[currentMon - 1]} ${now.day}  ${now.year}  ${now.hour}:${now.minute}';

    return datee;
  }
}
