import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/modules/announce/model/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../app/modules/chat/models/message_model.dart';
import '../../app/modules/profile/models/profile_model.dart';

class FirebaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<String?> getFirebaseMessagingToken() async {
    return await messaging.getToken();
  }

  // PROFILE
  static Future updateProfileData(doc, data) async {
    return await firestore.collection(collectionProfiles).doc(doc).update(data);
  }
  static Future setProfileData(doc, data) async {
    return await firestore.collection(collectionProfiles).doc(doc).set(data);
  }
  static Future getProfileData(doc) async {
    return await firestore.collection(collectionProfiles).doc(doc).get();
  }
  static Future deleteProfileData(doc) async {
    await firestore.collection(collectionProfiles).doc(doc).delete();
  }
  static Future getProfileModelData(doc) async {
    DocumentSnapshot docProfile = await firestore.collection(collectionProfiles).doc(doc).get();
    return ProfileModel.fromJson(docProfile.data() as Map<String, dynamic>);
  }
  static Future checkIfDocsRegistered(cpf, rg) async {
    List<Future<QuerySnapshot>> allQuerys = [];

    var queryCheckCPF = firestore.collection(collectionProfiles)
        .where('docCpf', isEqualTo: cpf)
        .get();
    var queryCheckRG = firestore.collection(collectionProfiles)
        .where('docRg', isEqualTo: rg)
        .get();

    allQuerys.add(queryCheckCPF);
    allQuerys.add(queryCheckRG);

    List<QuerySnapshot> docExists = await Future.wait(allQuerys);
    bool documentExists = false;
    for (var querys in docExists) {
      for (var doc in querys.docs) {
        if(doc.exists) {
          documentExists = true;
        }
      }
    }
    return documentExists;
  }

  // SERVICE
  static Future updateServiceData(doc, data) async {
    return await firestore.collection(collectionServices).doc(doc).update(data);
  }
  static Future setServiceData(doc, data) async {
    return await firestore.collection(collectionServices).doc(doc).set(data);
  }
  static Future getServiceData(doc) async {
    return await firestore.collection(collectionServices).doc(doc).get();
  }
  static Future deleteServiceData(doc) async {
    await firestore.collection(collectionServices).doc(doc).delete();
  }
  static Future getServiceModelData(doc) async {
    DocumentSnapshot docService = await firestore.collection(collectionServices).doc(doc).get();
    return ServiceModel.fromJson(docService.data() as Map<String, dynamic>);
  }
  static Future getListServiceModelDataById(where, equalTo) async {
    QuerySnapshot docsService = await firestore.collection(collectionServices)
        .where(where, isEqualTo: equalTo).get();
    //where: 'clientId' or 'professionalId'
    List<ServiceModel> allServicesModel = docsService.docs
        .map((d) => ServiceModel.fromJson(d.data() as Map<String, dynamic>)).toList();
    return allServicesModel;
  }

  // CHAT MESSAGES
  static Future updateChatData(doc, data) async {
    return await firestore.collection(collectionChat).doc(doc).update(data);
  }
  static Future setChatData(doc, data) async {
    return await firestore.collection(collectionChat).doc(doc).set(data);
  }
  static Future getChatData(doc) async {
    return await firestore.collection(collectionChat).doc(doc).get();
  }
  static Future deleteChatData(doc) async {
    await firestore.collection(collectionChat).doc(doc).delete();
  }
  static Future getChatModelData(doc) async {
    DocumentSnapshot docChat = await firestore.collection(collectionChat).doc(doc).get();
    return MessageModel.fromJson(docChat.data() as Map<String, dynamic>);
  }
  static Future getListChatModelDataById(where, equalTo) async {
    QuerySnapshot docsChat = await firestore.collection(collectionChat)
        .where(where, isEqualTo: equalTo).get();
    //where: 'clientId' or 'professionalId'
    List<MessageModel> allChatsModel = docsChat.docs
        .map((d) => MessageModel.fromJson(d.data() as Map<String, dynamic>)).toList();
    return allChatsModel;
  }
}