import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simba_coding_project/models/users_model.dart';

class Service {
  Service() {
    Firebase.initializeApp();
  }

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
    if (userCreds != null) {
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
              userCreds.user!.uid, 'USD', 'USD', 0.00, 1000, 0.00);
        }
      });
    }
    return true;
  }

  Future<bool> signInWithEmail(String email, password) async {
    try {
      UserCredential userCreds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCreds != null) {
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
            return false;
          } else {
            addNewUser(userCreds.user!.uid, userCreds.user!.displayName,
                userCreds.user!.email);
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
      if (userCreds != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCreds.user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            return false;
          } else {
            addNewUser(userCreds.user!.uid, userCreds.user!.displayName,
                userCreds.user!.email);
            sendMoney('001', 'New User Funds', userCreds.user!.displayName,
                userCreds.user!.uid, 'USD', 'USD', 0.00, 1000, 0.00);
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
          'USD': 0.00,
          'NGN': 0.00,
          'EUR': 0.00,
          'Id': userid
        })
        .then((value) => print('user added'))
        .catchError((onError) => {if (onError.code == 'Handsake') {}});
  }

  Future<bool> sendMoney(
    String senderUid,
    sendername,
    receivername,
    receiverUid,
    souceCurrency,
    targetCurrency,
    double exchanchangerate,
    amount,
    charge,
  ) async {
    double? source, reciverSource, myGain;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(senderUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      source = documentSnapshot.get([souceCurrency]);
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      reciverSource = documentSnapshot.get([souceCurrency]);
    });

    double balance = source!;
    if (balance < amount) {
      return false;
    } else {
      balance = -amount;

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
      }).catchError((onError) {
        print(onError);
      });

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('moneyGotten')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        myGain = documentSnapshot.get([souceCurrency]);
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
      }).catchError((onError) {
        print(onError);
      });
    }

    return true;
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
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
