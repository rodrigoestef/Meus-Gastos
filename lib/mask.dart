class Mask {
  static String date(String date) {
    var element = date.split(' ')[0].split('-');
    return element[2] + '/' + element[1] + '/' + element[0];
  }

  static String datagridMoney(String value) {
    var s = value.replaceAll(new RegExp(r'[^0-9]'), '');
    s = s.replaceAll(new RegExp(r'^0+'), '');

    while (s.length < 3) {
      s = '0' + s;
    }
    s = s.replaceAllMapped(new RegExp(r'([0-9]{2}$)'), (m) {
      return ',${m[0]}';
    });
    return value[0] == '-' ? '-' + s : s;
  }

  static String money(String value) {
    var s = value.replaceAll(new RegExp(r'[^0-9]'), '');
    s = s.replaceAll(new RegExp(r'^0+'), '');
    // s = value.replaceAll(new RegExp('^0*'), '');
    while (s.length < 3) {
      s = '0' + s;
    }
    s = s.replaceAllMapped(new RegExp(r'([0-9]{2}$)'), (m) {
      var a = ',${m[0]}';
      return a;
    });
    return s;
  }
}
