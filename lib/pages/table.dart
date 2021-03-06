import 'package:flutter/material.dart';
import '../repositories/Table.dart';
import '../mask.dart';

class DataSorce extends DataTableSource {
  DataSorce(this.data, this.callback) : assert(data != null);

  final List<Map<columns, String>> data;
  final void Function(int index) callback;
  @override
  DataRow getRow(int index) {
    var row = data[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Text(Mask.datagridMoney(row[columns.value])),
      ),
      DataCell(
        Text(Mask.date(row[columns.date])),
      ),
      DataCell(
        Text(row[columns.description]),
      ),
      DataCell(IconButton(
        onPressed: () {
          callback(index);
        },
        color: Colors.red,
        icon: Icon(Icons.delete),
      )),
    ]);
  }

  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
  @override
  bool get isRowCountApproximate => false;
}

class TablePage extends StatefulWidget {
  const TablePage();

  TableState createState() => TableState();
}

class TableState extends State<TablePage> {
  List<Map<columns, String>> list = [];
  bool isLoading = true;
  void _callbackDell(int index) async {
    var row = list[index];
    setState(() {
      list.removeAt(index);
    });

    DatabaseTable base = DatabaseTable();
    await base.init();
    await base.removeById(row[columns.id]);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
            label: "Cancelar",
            onPressed: () {
              base.cancelDelete(row[columns.id]);
              setState(() {
                list.add(row);
                list.sort((a, b) => a[columns.id].compareTo(b[columns.id]));
              });
            }),
        content: Text('Linha deletada')));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    DatabaseTable base = DatabaseTable();
    base.init().then((value) {
      base.getTable({}).then((value) => setState(() {
            list = [...value];
            isLoading = false;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 20),
              child: PaginatedDataTable(
                header: Text('Relat??rio'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.filter_alt),
                    onPressed: () async {
                      var range = await showDateRangePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now());
                      if (range.runtimeType == DateTimeRange) {
                        setState(() {
                          isLoading = true;
                        });
                        DatabaseTable db = DatabaseTable();
                        await db.init();
                        var _list = await db.getTable({
                          filters.beginDate: Mask.formatDate(range.start),
                          filters.endDate: Mask.formatDate(range.end)
                        });
                        setState(() {
                          list = _list;
                          isLoading = false;
                        });
                      }
                    },
                  )
                ],
                rowsPerPage: this.list.length > 10
                    ? 10
                    : this.list.length > 0
                        ? this.list.length
                        : 1,
                columns: [
                  DataColumn(
                    label: Text('Valor'),
                    tooltip: "Valor",
                  ),
                  DataColumn(
                    label: Text('Data'),
                    tooltip: "Data",
                  ),
                  DataColumn(
                    label: Text('Descri????o'),
                    tooltip: "Descri????o",
                  ),
                  DataColumn(
                    label: Text('#'),
                    tooltip: "A????es",
                  ),
                ],
                source: DataSorce(this.list, this._callbackDell),
              ),
            ),
          );
  }
}
