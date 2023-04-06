import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: const [
            Text(
              'For any Queries or report issues Kindly contact at:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'engr.mohkam@gmail.com',
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            )
          ],
        ),
      ),
    );
  }
}
