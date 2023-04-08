import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String> fetchCombinedJsonFromStorage() async {
    FirebaseStorage storage               = FirebaseStorage.instance;
    String firebaseStoragePathPassline    = 'event_find/eventos/passline';
    String firebaseStoragePathTicketPlus  = 'event_find/eventos/ticketplus';
    List<dynamic> combinedJsonData        = [];

    try {
      ListResult listResult     = await storage.ref(firebaseStoragePathPassline).list();
      List<Reference> jsonRefs  = listResult.items.where((ref) => ref.name.endsWith('.json')).toList();

      for (Reference jsonRef in jsonRefs) {
        final result            = await jsonRef.getData();
        String jsonContent      = String.fromCharCodes(result as Iterable<int>);
        List<dynamic> jsonData  = jsonDecode(utf8.decode(jsonContent.codeUnits));

        for (var jsonObject in jsonData) {
          jsonObject['logo'] = 'logo_passline.png';
        }
        combinedJsonData.addAll(jsonData);
      }

      ListResult listResult2 = await storage.ref(firebaseStoragePathTicketPlus).list();
      List<Reference> jsonRefs2 = listResult2.items.where((ref) => ref.name.endsWith('.json')).toList();

      for (Reference jsonRef in jsonRefs2) {
        final result            = await jsonRef.getData();
        String jsonContent      = String.fromCharCodes(result as Iterable<int>);
        List<dynamic> jsonData  = jsonDecode(utf8.decode(jsonContent.codeUnits));

        combinedJsonData.addAll(jsonData);
      }
    } catch (e) {
      print('Error al descargar los archivos JSON: $e');
      throw e;
    }

    String combinedJsonContent = jsonEncode(combinedJsonData);
    return combinedJsonContent;
  }
}      