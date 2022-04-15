// ignore: camel_case_types
class customUser {
  customUser(this.uid);
  final String uid;
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData(this.uid, this.name, this.strength, this.sugars);
}
