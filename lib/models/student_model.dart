class StudentModel{
  final int id;
  final String name;
  final int age;

  StudentModel({required this.id, required this.name, required this.age});

  Map<String,dynamic> toMap(){
    return {
      "id": id,
      "name":name,
      "age": age,
    };
  }
factory StudentModel.fromMap(Map<String,dynamic>map){
return StudentModel(id: map["id"], name: map["name"], age: map["age"]);
}
}