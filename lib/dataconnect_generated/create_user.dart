part of 'generated.dart';

class CreateUserVariablesBuilder {
  String username;
  String email;
  String passwordHash;
  Timestamp createdAt;

  final FirebaseDataConnect _dataConnect;
  CreateUserVariablesBuilder(this._dataConnect, {required  this.username,required  this.email,required  this.passwordHash,required  this.createdAt,});
  Deserializer<CreateUserData> dataDeserializer = (dynamic json)  => CreateUserData.fromJson(jsonDecode(json));
  Serializer<CreateUserVariables> varsSerializer = (CreateUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateUserData, CreateUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateUserData, CreateUserVariables> ref() {
    CreateUserVariables vars= CreateUserVariables(username: username,email: email,passwordHash: passwordHash,createdAt: createdAt,);
    return _dataConnect.mutation("CreateUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateUserUserInsert {
  final String id;
  CreateUserUserInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateUserUserInsert otherTyped = other as CreateUserUserInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateUserUserInsert({
    required this.id,
  });
}

@immutable
class CreateUserData {
  final CreateUserUserInsert user_insert;
  CreateUserData.fromJson(dynamic json):
  
  user_insert = CreateUserUserInsert.fromJson(json['user_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateUserData otherTyped = other as CreateUserData;
    return user_insert == otherTyped.user_insert;
    
  }
  @override
  int get hashCode => user_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user_insert'] = user_insert.toJson();
    return json;
  }

  CreateUserData({
    required this.user_insert,
  });
}

@immutable
class CreateUserVariables {
  final String username;
  final String email;
  final String passwordHash;
  final Timestamp createdAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateUserVariables.fromJson(Map<String, dynamic> json):
  
  username = nativeFromJson<String>(json['username']),
  email = nativeFromJson<String>(json['email']),
  passwordHash = nativeFromJson<String>(json['passwordHash']),
  createdAt = Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateUserVariables otherTyped = other as CreateUserVariables;
    return username == otherTyped.username && 
    email == otherTyped.email && 
    passwordHash == otherTyped.passwordHash && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([username.hashCode, email.hashCode, passwordHash.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    json['email'] = nativeToJson<String>(email);
    json['passwordHash'] = nativeToJson<String>(passwordHash);
    json['createdAt'] = createdAt.toJson();
    return json;
  }

  CreateUserVariables({
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
  });
}

