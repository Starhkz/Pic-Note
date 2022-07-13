import 'package:flutter/material.dart';
import 'package:pic_note/big_screens/Oops.dart';
import 'package:pic_note/big_screens/home_screen_tab.dart';
import 'package:pic_note/home_page.dart';

class Display extends StatelessWidget {
  const Display({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 500) {
      return const Oops();
    } else {
      return const Home();
    }
  }
}
