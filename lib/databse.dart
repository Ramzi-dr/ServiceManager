import 'package:shared_preferences/shared_preferences.dart';

class DataBase {
  addKeyToSF(key, value) async {
    if (await getValue(key) == '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    }
  }

  getValue(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var existValue = prefs.getString(key) ?? '';
    return existValue;
  }

  update(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

////Work with List of Services
// Storing a List of Strings in shared_preferences
  Future<bool> doesListExist(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  saveList(String key, List<String> myList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, myList);
  }

// Retrieving a List of Strings from shared_preferences
  Future<List<String>> getList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = prefs.getStringList(key) ?? [];
    return myList;
  }

// Append an item to the list and save it back to shared_preferences
  appendToList(String key, String newItem) async {
    List<String> myList = await getList(key);
    myList.add(newItem); // Append the item
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, myList); // Save the updated list

    // Retrieve the updated list
    List<String> retrievedList = await getList(key);
  }

  deletefromList(String key, String itemToDelete) async {
    print(key);
    print(itemToDelete);
    List<String> myList = await getList(key);
    myList.remove(itemToDelete); // Delete the item
    print(myList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, myList); // Save the updated list
  }
}
