import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final Function(String, String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  AssetImage('assets/images/profile_placeholder.jpg'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Meow',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('Home', 'Home', Icons.home),
          sliderItem('Profile', 'Profile', Icons.person),
          // sliderItem('Notification', Icons.notifications_active),
          // sliderItem('Likes', Icons.favorite),
          sliderItem('Setting', 'Setting', Icons.settings),
          sliderItem('LogOut', 'LogOut', Icons.arrow_back_ios)
        ],
      ),
    );
  }

  Widget sliderItem(String title, String dest, IconData icons) => ListTile(
      title: Text(
        title,
        style:
            TextStyle(color: Colors.black, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.black,
      ),
      onTap: () {
        onItemClick(title, dest);
      });
}
