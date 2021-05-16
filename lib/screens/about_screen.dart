import 'package:TODO/screens/license_screen.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 80),
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "ABOUT",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Color(0xffff351a),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            );
          }
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
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        showLicensePage(
                          context: context,
                          applicationVersion: 'version 1.2',
                          applicationIcon: Image.asset(
                            'assets/ic_launcher.png',
                            width: 56,
                            height: 56,
                          ),

                          // applicationName: "App Name"
                        );
                      },
                      child: Text('Show Licenses'),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
