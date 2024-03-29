import 'package:flutter/material.dart';
import 'package:linkedin_clone/search/profile_company.dart';
import 'package:url_launcher/url_launcher.dart';


class AllWorkersWidget extends StatefulWidget {

  final String userID;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImageUrl;

  const AllWorkersWidget({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.userImageUrl
  });



  @override
  _AllWorkersWidgetState createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(
            userID: widget.userID,
          )));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.userImageUrl == null
                ? 'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png'
                : widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Profili ziyaret et",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: _mailTo,
        ),
      ),
    );
  }

  void _mailTo() async{
    var mailUrl = 'mainto: ${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');
    if(await canLaunch(mailUrl)){
      await launch(mailUrl);
    }else{
      print('Hata');
      throw 'Hata oluştu';
    }
  }

}




















