import 'dart:io';

import 'package:bus_by_u/globle.dart';
import 'package:bus_by_u/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool securetxt = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController fathernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  File? image;
  String frontPath = '';

  Future pickProfileFront() async {
    try {
      //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageTemporary = File(image.path);
        print('Image Path');
        print(image.path);
        print('front Path ${frontPath}');
        print('image uri ${image.name}');
        frontPath = image.path;

        setState(() {
          this.image = imageTemporary;
        });
      } else {
        return Fluttertoast.showToast(msg: "No Image picked");
      }
    } on PlatformException catch (ex) {
      print('Failed to pick Image: $ex');
    }
  }

  validateForm() async {
    if (nameController.text.length < 4) {
      Fluttertoast.showToast(msg: "Name must be atleast 4 characters");
    } else if (fathernameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Father Name is Required.");
    } else if (!emailController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid");
    } else if (cnicController.text.length < 13) {
      Fluttertoast.showToast(msg: "Cnic must be atleast 13 Numbers");
    } else if (numberController.text.length < 11) {
      Fluttertoast.showToast(msg: "Number must be atleast 11 Numbers");
    } else if (rollnoController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Roll number is Required");
    } else if (departmentController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Department is Required");
    } else if (universityController.text.isEmpty) {
      Fluttertoast.showToast(msg: "University is Required");
    } else {
      currentFirebaseUser = await FirebaseAuth.instance.currentUser;
      String userId = currentFirebaseUser!.uid;
      print(userId);

      ///upload 1st image
      firebase_storage.Reference refe = firebase_storage
          .FirebaseStorage.instance
          .ref(DateTime.now().millisecondsSinceEpoch.toString());
      firebase_storage.UploadTask uploadTask = refe.putFile(image!.absolute);
      await Future.value(uploadTask);

      var newUrl = await refe.getDownloadURL();
      print('1nd Image Firebase Url');
      print(newUrl);
      print(newUrl.toString());

      Map usersMap = {
        "id": currentFirebaseUser?.uid,
        "name": nameController.text.trim(),
        "father name": fathernameController.text.trim(),
        "email": emailController.text.trim(),
        "cnic": cnicController.text.trim(),
        "number": numberController.text.trim(),
        "rollno": rollnoController.text.trim(),
        "department": departmentController.text.trim(),
        "university": universityController.text.trim(),
        "profile": newUrl.toString()
      };

      print(usersMap);
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users");
      usersRef.child(userId).set(usersMap);
      Fluttertoast.showToast(msg: "Account Updated");
    }
  }

  getUsersData() async {
    final snapshot = await usersRef.child(currentFirebaseUser?.uid ?? '').get();
    print(snapshot.value!);
    setState(() {
      currentUsersinfo = Users.fromSnapshot(snapshot);
    });
    debugPrint(currentUsersinfo!.name);
    print(currentUsersinfo!.profile);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white12,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
                // Container(
                //   // height: 280,
                //   width: double.infinity,
                //   decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(90),
                //     ),
                //   ),
                //   child: Center(
                //     child: Container(
                //       height: 150,
                //       width: 170,
                //       decoration: const BoxDecoration(
                //           image: DecorationImage(
                //         image: AssetImage(
                //           "images/bbu.png",
                //         ),
                //         fit: BoxFit.cover,
                //       )),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    pickProfileFront();
                  },
                  child: Center(
                    child: Container(
                      height: 124,
                      width: 124,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent),
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.fill,
                            )
                          : currentUsersinfo != null
                              ? Image.network(
                                  currentUsersinfo!.profile!,
                                  fit: BoxFit.fill,
                                )
                              : const Center(
                                  child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 40,
                                )),
                    ),
                  ),
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //       pickProfileFront();
                //     },
                //     child: Container(
                //       height: 124,
                //       width: 124,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           image: DecorationImage(
                //               image: currentUsersinfo != null
                //                   ? NetworkImage(currentUsersinfo!.profile!)
                //                   : NetworkImage(
                //                       "https://firebasestorage.googleapis.com/v0/b/busbyu-926c1.appspot.com/o/bbu.png?alt=media&token=33b9340e-b109-4bd4-a6cc-791b58913243"),
                //               fit: BoxFit.fill)),
                //       //color: Colors.pink,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Edit Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: currentUsersinfo != null
                          ? currentUsersinfo?.name
                          : 'Name', //currentUserData !=null? currentUserData!.name!: 'Akash'
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      suffixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.black,
                      )),
                  textCapitalization: TextCapitalization.sentences,
                ),
                //AppFormField(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: fathernameController,
                  decoration: const InputDecoration(
                      labelText: "Father Name",
                      hintText: "Father Name",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      suffixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.black,
                      )),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: currentUsersinfo != null
                        ? currentUsersinfo?.email
                        : 'Email',
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "******",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          if (securetxt == true) {
                            securetxt = false;
                          } else {
                            securetxt = true;
                          }
                        });
                      },
                      child: securetxt
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Colors.black,
                            ),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: securetxt,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: cnicController,
                  decoration: InputDecoration(
                    labelText: "CNIC",
                    hintText: currentUsersinfo != null
                        ? currentUsersinfo?.cnic
                        : '36*********',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: "Number",
                    hintText: currentUsersinfo != null
                        ? currentUsersinfo?.number
                        : '+92300000000',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: rollnoController,
                  decoration: const InputDecoration(
                    labelText: "Roll No",
                    hintText: "Roll No",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.numbers,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    hintText: "Department",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.local_mall,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: universityController,
                  decoration: InputDecoration(
                    labelText: "University",
                    hintText: currentUsersinfo != null
                        ? currentUsersinfo?.univesity
                        : 'University',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.place,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 18,
                  ),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlue,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          validateForm();
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
