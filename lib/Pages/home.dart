import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: Column(
            children: [],
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Track the Bus"),
          ),
          body: Text('helo')),
    );
  }
}
