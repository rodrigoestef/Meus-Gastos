import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../repositories/Table.dart';
import '../mask.dart';

class Graphics extends StatefulWidget {
  const Graphics();

  GraphicsState createState() => GraphicsState();
}

class CharsData {
  final String label;
  final int value;
  final Color color;

  CharsData(this.label, this.value, this.color);
}

class GraphicsState extends State<Graphics> {
  List<charts.Series<CharsData, String>> _pieData = [];
  bool overflow = false;
  bool noData = false;
  String disponivel = '';
  void _createData() async {
    DatabaseTable db = DatabaseTable();
    await db.init();
    var valores = await db.getPieData();
    final data = [
      new CharsData('disponivel', valores[pie.disponivel] - valores[pie.usado],
          Colors.green),
      new CharsData('usado', valores[pie.usado], Colors.red),
    ];

    setState(() {
      if (valores[pie.disponivel] == 0 && valores[pie.usado] == 0) {
        noData = true;
      } else if (valores[pie.disponivel] - valores[pie.usado] > 0) {
        disponivel =
            Mask.money('${valores[pie.disponivel] - valores[pie.usado]}');
        _pieData.add(
          charts.Series(
            id: 'id',
            data: data,
            domainFn: (CharsData chr, _) => chr.label,
            measureFn: (CharsData chr, _) => chr.value,
            labelAccessorFn: (CharsData chr, _) =>
                '${Mask.money("${chr.value}")}',
            colorFn: (CharsData chr, _) =>
                charts.ColorUtil.fromDartColor(chr.color),
          ),
        );
      } else {
        overflow = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _createData();
  }

  @override
  Widget build(BuildContext context) {
    return _pieData.length > 0
        ? Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    // direction: Axis.horizontal,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width - 20,
                        child: new charts.PieChart(
                          _pieData,
                          behaviors: [
                            charts.DatumLegend(),
                          ],
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 60,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Disponinvel: R\$ $disponivel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Center(
            child: noData
                ? Text('Não existem valores para esse mês')
                : overflow
                    ? Text('Você estourou o orçamento')
                    : CircularProgressIndicator(),
          );
  }
}
