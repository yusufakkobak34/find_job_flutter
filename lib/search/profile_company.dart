import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:linkedin_clone/widgets/bottomNavBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_state.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;



  const ProfileScreen({required this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String phoneNumber = "";
  String email = "";
  String? name;
  String imageUrl = "";
  String joinedAt = " ";
  bool _isSameUser = false;

  void getUserData() async{
    try{
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      if (userDoc == null) {
        return;
      }else{
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }catch(eror) {} finally{
      _isLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
      body: Center(
        child:
        _isLoading ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white10,
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  name == null ? 'İsim' : name!,
                                  style: TextStyle(color: Colors.white, fontSize: 22.0)
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Hesap Bilgisi :',
                                style: TextStyle(color: Colors.grey, fontSize: 22.0),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: userInfo(icon: Icons.email, content: email),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: userInfo(icon: Icons.phone_android, content: phoneNumber),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            _isSameUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _contactBy(
                                          color: Colors.green,
                                          fct: () {
                                            _openWhatsAppChat();
                                          },
                                          icon: FontAwesome.whatsapp,
                                      ),
                                      _contactBy(
                                          color: Colors.red,
                                          fct: () {
                                            _mailTo();
                                          },
                                          icon: Icons.mail_outline
                                      ),
                                      _contactBy(
                                          color: Colors.purple,
                                          fct: () {
                                            _callPhoneNumber();
                                          },
                                          icon: Icons.call_outlined
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            !_isSameUser
                            ? Container()
                                : Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: MaterialButton(
                                  onPressed: (){
                                    _auth.signOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserState(),
                                      ),
                                    );
                                  },
                                  color: Colors.white10,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Çıkış Yap',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.26,
                          height: size.width * 0.26,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 8,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  imageUrl == null
                                      ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                                      : imageUrl
                              ),
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$phoneNumber?text=Merhaba';
    launch(url);
  }

  void _mailTo() async{
   final Uri params = Uri(
     scheme: 'mailto',
     path: email,
     query: 'subject=Konuyu yazın, Please&body=Merhaba,',
   );
   final url = params.toString();
   launch(url);
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Hata oluştu';
    }
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}
      ) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

}

















