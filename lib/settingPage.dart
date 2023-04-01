import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<int> memberNum = [1, 2, 3, 4, 5, 6];
  int maleNum = 1;
  int femaleNum = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: DropdownButton(
                  value: 1,
                  items: memberNum.map<DropdownMenuItem<int>>((int number) {
                    return DropdownMenuItem<int>(
                      value: number,
                      child: Text(number as String),
                    );
                  }).toList(),
                  onChanged: (newNumber) {
                    setState(() {
                      maleNum = newNumber;
                    });
                  },
                ),
              )
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
