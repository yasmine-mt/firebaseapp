
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{

  final FirebaseFirestore _db= FirebaseFirestore.instance;
  Future<void> createUser(String userId,Map<String,dynamic> userData)async{
    await _db.collection('users').doc(userId).set(userData);
  }
  Future<DocumentSnapshot> getUser(String userId)async{
    return await _db.collection('users').doc(userId).get();
  }
  Future<void> updateUser(String userId,Map<String,dynamic> userData)async{
    await _db.collection('users').doc(userId).update(userData);
  }
  Future<void> deleteUser(String userId)async{
    await _db.collection('users').doc(userId).delete();
  }
  Future<List<DocumentSnapshot>> getAllUsers()async{
    QuerySnapshot querySnapshot = await _db.collection('users').get();
    return querySnapshot.docs;
  }
  String uid(){
    return _db.collection('users').doc().id;
  }
}