import 'package:TODO/screens/license_screen.dart';
import 'package:flutter/material.dart';

class BodyAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: Image.asset(
              'assets/ic_launcher.png',
              width: 56,
              height: 56,
            ),
            title: Text(
              'TODO',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text('version 1.2'),
          ),
          Text("Made in Berlin"),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          Container(
            child: Center(
              child: TextButton(
                onPressed: () {
                  showOwnLicensePage(
                    context: context,
                    applicationName: '',
                  );
                },
                child: Text('Show Licenses'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
