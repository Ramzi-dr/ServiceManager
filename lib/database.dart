import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataBase {
  late SharedPreferences prefs;

  // Singelton pattern
  static final DataBase _instance = DataBase._internal();

  factory DataBase() {
    _instance.init();
    return _instance;
  }
  DataBase._internal();

  //Initialize SharedPreferences
  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
  Future clearDatabase()async{
    prefs.clear();
  }

  Future addKeyToSF(key, value) async {
    if (await getValue(key) == '') {
      prefs.setString(key, value);
    }
  }

  Future getValue(key) async {
    var existValue = prefs.getString(key);
    return existValue;
  }

////Work with List of Services
// Storing a List of Strings in shared_preferences
  Future<bool> doesExist(key) async {
    return prefs.containsKey(key);
  }

  Future saveList(String key, List<String> myList) async {
    await prefs.setStringList(key, myList);
  }

  Future removeKey(String key) async {
    await prefs.remove(key);
  }

// Retrieving a List of Strings from shared_preferences
  Future<List<String>> getList(String key) async {
    List<String> myList = prefs.getStringList(key) ?? [];
    return myList;
  }

  Future getTheListOfServer(
    key,
  ) async {
    List<String> serverListAsString = await getList(key);
    List<List<dynamic>> listOfLists = <List<dynamic>>[];
    for (String jsonString in serverListAsString) {
      List<dynamic> jsonList = json.decode(jsonString);
      listOfLists.add(jsonList);
    }
    return listOfLists;
  }

  Future deleteServerInfoFromServerList(key, int indexToDelete) async {
    // Retrieve the list from SharedPreferences
    List<String> myList = await getList(key);

    // Check if the index to delete is valid
    if (indexToDelete >= 0 && indexToDelete < myList.length) {
      // Convert the JSON string at the specified index back to a data structure
      List<dynamic> jsonList = json.decode(myList[indexToDelete]);

      // Remove the item at the specified index
      myList.removeAt(indexToDelete);

      // Save the modified list back to SharedPreferences
      await prefs.setStringList(key, myList);
    } else {
      // Handle the case where the index is out of bounds
      print("Invalid index to delete: $indexToDelete");
    }
  }

  Future appendServerInfoToServerList(key, List serverInfoList) async {
    List<String> myList = await getList(key);

    // Convert myList items to lists
    List<List<dynamic>> decodedMyList = [];

    for (String item in myList) {
      List<dynamic> decodedItem = json.decode(item);
      decodedMyList.add(decodedItem);
    }

    // Check if serverInfoList[0] matches the first element of any item in decodedMyList
    bool exists = false;
    int indexToUpdate = -1;

    for (int i = 0; i < decodedMyList.length; i++) {
      List<dynamic> decodedItem = decodedMyList[i];
      if (decodedItem.isNotEmpty && decodedItem[0] == serverInfoList[0]) {
        exists = true;
        indexToUpdate = i;
        break;
      }
    }

    String encodedServerInfoList = json.encode(serverInfoList);

    if (exists) {
      // Replace the existing item in decodedMyList
      decodedMyList[indexToUpdate] = serverInfoList;

      // Encode and update myList
      myList[indexToUpdate] = json.encode(serverInfoList);
    } else {
      // Append it to decodedMyList
      decodedMyList.add(serverInfoList);

      // Encode and append to myList
      myList.add(encodedServerInfoList);
    }

    await prefs.setStringList(key, myList);
  }

  Future appendToList(String key, String newItem) async {
    List<String> myList = await getList(key);
    myList.add(newItem); // Append the item
    await prefs.setStringList(key, myList); // Save the updated list
  }

  Future deleteFromList(String key, String itemToDelete) async {
    List<String> myList = await getList(key);
    myList.remove(itemToDelete); // Delete the item
    await prefs.setStringList(key, myList); // Save the updated list
  }

Future saveServiceInfoMap(
  String serviceMap, Map<String, dynamic> serviceInfoMap) async {
  // Retrieve the existing data
  String? jsonExistingServiceInfo = prefs.getString(serviceMap);
  Map<String, dynamic> existingServiceInfo = jsonExistingServiceInfo != null
      ? jsonDecode(jsonExistingServiceInfo)
      : {};

  // Loop through the provided serviceInfoMap
  serviceInfoMap.forEach((serviceName, serviceNewValue) {
    if (!existingServiceInfo.containsKey(serviceName)) {
      // If serviceName is not in existingServiceInfo, add it with the new value
      existingServiceInfo[serviceName] = serviceNewValue;
    } else {
      // If serviceName is in existingServiceInfo, update the existing list
      List serviceOldValue = existingServiceInfo[serviceName];
      bool isDuplicate = false;

      // Check if serviceNewValue already exists in the list
      for (var item in serviceOldValue) {
        if (item.runtimeType == serviceNewValue.runtimeType &&
            item.toString() == serviceNewValue.toString()) {
          isDuplicate = true;
          break;
        }
      }

      if (!isDuplicate) {
        // If not a duplicate, add it to the list
        serviceOldValue.add(serviceNewValue);
        existingServiceInfo[serviceName] = serviceOldValue;
      }
    }
  });

  // Encode and save the updated existingServiceInfo
  String jsonMergedServiceInfo = jsonEncode(existingServiceInfo);
  await prefs.setString(serviceMap, jsonMergedServiceInfo);
}


  Future updateServiceInfoMap(String serviceMap, String serviceInfoMap) async {
    // Retrieve the existing data
    String? jsonExistingServiceInfo = prefs.getString(serviceMap);
    Map<String, dynamic> existingServiceInfo = jsonExistingServiceInfo != null
        ? jsonDecode(jsonExistingServiceInfo)
        : {};
    //delete key value
    existingServiceInfo.remove(serviceInfoMap);
    // existingServiceInfo.remove(serviceInfoMap);

    // Convert the merged map to a JSON string and save it
    String jsonMergedServiceInfo = jsonEncode(existingServiceInfo);
    await prefs.setString(serviceMap, jsonMergedServiceInfo);
  }

  Future<Map<String, dynamic>> getServiceInfoMap(mapToGet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from SharedPreferences
    String? jsonServiceInfo = prefs.getString(mapToGet);

    // Check if the JSON string is not null
    if (jsonServiceInfo != null) {
      // Parse the JSON string back into a Map
      Map<String, dynamic> serviceInfoMap = jsonDecode(jsonServiceInfo);

      return serviceInfoMap;
    } else {
      // Handle the case where the JSON string is null (not found)
      return {}; // or any other appropriate default value
    }
  }
}
