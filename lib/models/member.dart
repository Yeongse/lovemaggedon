class Member {
  late int loveMemberIndex;

  final int index;
  final String sex;
  final String name;
  final String image;

  void setLoveMember(int index) {
    loveMemberIndex = index;
  }

  Member(this.index, this.sex, this.name, this.image) {}
}
