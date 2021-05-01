import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:split_it/models/contact.dart';
import 'package:split_it/models/personal_transaction.dart';
import 'package:split_it/models/split_transaction.dart';
import 'package:split_it/models/userData.dart';
import 'package:intl/intl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseService {
  final String uid;
  FirebaseAuth auth;
  DatabaseService({this.uid}) {
    auth = FirebaseAuth.instance;
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  List<PTransaction> _personaltransactionListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PTransaction.fromMapObject(
        id: doc.id,
        data: doc.data(),
      );
    }).toList();
  }

  Stream<UserData> getUserDataStream() async* {
    await for (var firebaseUser in auth.authStateChanges()) {
      if (firebaseUser != null) {
        final id = firebaseUser.uid;
        final ref = userCollection.doc(id);
        final transactionsRef = await ref.collection('transactions').get();
        final List<PTransaction> listTransactions =
            _personaltransactionListFromSnapshot(transactionsRef);
        yield* ref.snapshots().map(
          (snap) {
            if (snap.exists) {
              print(snap.data());
              return UserData(
                  doc: snap.data(),
                  id: snap.id,
                  listTransactions: listTransactions);
            } else {
              return UserData.empty();
            }
          },
        );
      } else {
        yield UserData.empty();
      }
    }
  }

  List<STransaction> _transactionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return STransaction.fromMapObject(
        id: doc.id,
        data: doc.data(),
      );
    }).toList();
  }

  Stream<List<STransaction>> getTransactions(String uid) async* {
    yield* transactionsCollection
        .where("members", arrayContains: uid)
        .snapshots()
        .map((_transactionListFromSnapshot));
  }

  Future<void> addTransaction({@required Map details}) async {
    transactionsCollection.add(details);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await transactionsCollection.doc(transactionId).delete();
  }

  Stream<List<PTransaction>> getPersonalTransactions(String uid) async* {
    yield* userCollection
        .doc(uid)
        .collection('transactions')
        .orderBy("date")
        .snapshots()
        .map((_personaltransactionListFromSnapshot));
  }

  Future<void> addPersonalTransaction(
      {@required Map details, @required String uid}) async {
    userCollection.doc(uid).collection('transactions').add(details);
  }

  Future<void> deletePersonalTransaction(
      {@required String transactionId, @required String uid}) async {
    await userCollection
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  Future<bool> isUserDocExists() async {
    User user = auth.currentUser;
    DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
    print(user.uid);
    if (userDoc.exists) {
      return true;
    }
    return false;
  }

  Future<void> createNewDocument({@required String name}) async {
    User user = auth.currentUser;
    await userCollection.doc(user.uid).set({
      'name': name,
      'createdAt': DateFormat.yMMMd().format(DateTime.now()),
      'phoneNumber': user.phoneNumber ?? "",
    });
  }

  Future<List<UserContact>> addContacts() async {
    if (await Permission.contacts.request().isGranted) {
      User user = auth.currentUser;
      var query = await userCollection.get();

      Set<UserContact> userContacts = {};

      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((element) {
        String displayName = element.displayName;
        element.phones.forEach((element) async {
          String phoneNumber = element.value.replaceAll(RegExp(r"\s+"), "");
          phoneNumber = phoneNumber.substring(
              (phoneNumber.length - 10).clamp(0, phoneNumber.length));
          phoneNumber = '+91' + phoneNumber;

          if (phoneNumber.length == 13) {
            try {
              var doc = query.docs
                  .where((element) =>
                      element.data()['phoneNumber'] == phoneNumber &&
                      element.data()['phoneNumber'] != user.phoneNumber)
                  .first;

              if (doc != null) {
                String contactId = doc.id;
                final userContact =
                    UserContact(displayName, phoneNumber, contactId);
                userContacts.add(userContact);
              }
            } catch (e) {}
          }
        });
      });

      // await userCollection.doc(user.uid).update({
      //   'friends': userContacts.map((contact) => contact.toMap()).toList(),
      // }).catchError((e) {
      //   print(e);
      // });

      /// I want this to be provided in various places
      return userContacts.toList();
    }

    Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();
    print(statuses[Permission.contacts]);
    return null;
  }

  Future<void> settleIt(
      {@required String transactionId, @required List details}) async {
    await transactionsCollection
        .doc(transactionId)
        .update({"details": details});

    await transactionsCollection
        .doc(transactionId)
        .update({"settleCount": FieldValue.increment(1)});
  }
}
