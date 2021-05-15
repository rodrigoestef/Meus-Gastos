class Mask {
  static String date(String date) {
    var element = date.split('-');
    return element[2] + '/' + element[1] + '/' + element[0];
  }
}
