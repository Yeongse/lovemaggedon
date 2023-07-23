class Member {
  late int loveMemberId;

  final int id;
  final String sex;
  final String name;
  final String image;

  void setLoveMember(int id) {
    loveMemberId = id;
  }

  Member(this.id, this.sex, this.name, this.image) {}
}
