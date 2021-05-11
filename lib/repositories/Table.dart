enum columns {
  id,
  value,
  description,
  date,
}

enum filters {
  beginDate,
  endDate,
}

class Database {
  void destroy() {}
  Future<void> removeById(String id) async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<List<Map<columns, String>>> getTable(
      Map<filters, String> filter) async {
    List<Map<columns, String>> table = [
      {
        columns.id: '1',
        columns.value: 'z',
        columns.description: 'description',
        columns.date: 'date'
      },
      {
        columns.id: '2',
        columns.value: 'z',
        columns.description: 'description',
        columns.date: 'date'
      },
    ];
    await Future.delayed(Duration(seconds: 2));
    return Future.value(table);
  }
}
