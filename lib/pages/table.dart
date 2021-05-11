import 'package:flutter/material.dart';
import '../repositories/Table.dart';

class DataSorce extends DataTableSource {
  DataSorce(this.data, this.callback) : assert(data != null);

  final List<Map<columns, String>> data;
  final void Function(int index) callback;
  @override
  DataRow getRow(int index) {
    var row = data[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Text(row[columns.value]),
      ),
      DataCell(
        Text(row[columns.date]),
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
    Database base = Database();
    base.removeById(row[columns.id]);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
            label: "Cancelar",
            onPressed: () {
              print('a');
            }),
        content: Text('Linha deletada')));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Database base = Database();
    base.getTable({}).then((value) => setState(() {
          list = [...value];
          isLoading = false;
        }));
    base.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: PaginatedDataTable(
                header: Text('Relatório'),
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
                    label: Text('Descrição'),
                    tooltip: "Descrição",
                  ),
                  DataColumn(
                    label: Text('#'),
                    tooltip: "Ações",
                  ),
                ],
                source: DataSorce(this.list, this._callbackDell),
              ),
            ),
          );
  }
}
