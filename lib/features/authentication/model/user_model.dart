

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  // keep final which do not want to update
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  String publicId;
  final String gender;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.publicId = '',
    this.gender = ''
  });

  /// Function to get the full name
  String get fullName => '$firstName $lastName';

  /// Static function to split full name into first name and last name
  static  List<String> nameParts(String? fullName) => (fullName ?? "").split(" ");


  /// static function to create an empty user model
  static UserModel empty() => UserModel(id: "", firstName: "", lastName: "", username: "", email: "", phoneNumber: "", profilePicture: "", publicId: "", gender: "");

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'firstName' : firstName,
      'lastName' : lastName,
      'username' : username,
      'email' : email,
      'phoneNumber' : phoneNumber,
      'profilePicture' : profilePicture,
      'publicId' : publicId,
      'gender' : gender

    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() != null){
      final data = document.data()!;
      return UserModel(
          id: document.id,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          username: data['username'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          profilePicture: data['profilePicture'] ?? '',
          publicId: data['publicId'],
          gender: data['gender'] ?? ''
      );
    }else{
      return UserModel.empty();
    }
  }


  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? gender
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      gender: gender ?? this.gender
    );
  }

}