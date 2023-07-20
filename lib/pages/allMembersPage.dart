import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import './ChoosePage.dart';

class MemberComponent extends StatelessWidget {
  final Member member;
  const MemberComponent({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          width: deviceSize.width * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 追加
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(
                      File(member.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AllMembersPage extends StatelessWidget {
  const AllMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final allMembers = ref.watch(membersProvider);
      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "参加者一覧",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "男の子の参加者",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: males
                        .map(
                            (maleMember) => MemberComponent(member: maleMember))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  "女の子の参加者",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 12.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: females
                        .map((femaleMember) =>
                            MemberComponent(member: femaleMember))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      '気になる相手を選ぶ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChoosePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
