import 'package:flutter/material.dart';
import '../mask.dart';
import '../repositories/Table.dart';

enum radioOptions {
  ganho,
  despesa,
}

class FormNewItem extends StatefulWidget {
  const FormNewItem();
  @override
  FormNewItemState createState() => FormNewItemState();
}

class FormNewItemState extends State<FormNewItem> {
  TextEditingController dateController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  String description = '';
  radioOptions radioSelected = radioOptions.despesa;
  final formKey = GlobalKey<FormState>();
  Map<
      radioOptions,
      Future<void> Function(
          {String value, String date, String description})> submits = {
    radioOptions.ganho: (
        {String value, String date, String description}) async {
      DatabaseTable db = DatabaseTable();
      await db.init();
      await db.insertRow(date: date, value: value, description: description);
    },
    radioOptions.despesa: (
        {String value, String date, String description}) async {
      DatabaseTable db = DatabaseTable();
      await db.init();
      await db.insertRow(
          date: date, value: '-' + value, description: description);
    },
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text('Voltar')
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        // height: 40,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: TextFormField(
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'data',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                                controller: this.dateController,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now()
                                              .subtract(Duration(days: 365)),
                                          lastDate: DateTime.now())
                                      .then((value) => dateController.text =
                                          Mask.date(value.toString()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 140,
                        // height: 40,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: TextFormField(
                                validator: (value) {
                                  return value.isEmpty
                                      ? 'Campo obrigatório'
                                      : null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'valor',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                controller: valueController,
                                onChanged: (String value) {
                                  valueController.text = Mask.money(value);
                                  valueController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: valueController.text.length));
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'descrição',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    maxLines: 4,
                  ),
                  RadioListTile<radioOptions>(
                    title: Text('Ganho'),
                    value: radioOptions.ganho,
                    groupValue: radioSelected,
                    onChanged: (radioOptions value) {
                      setState(() {
                        radioSelected = radioOptions.ganho;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Despesa'),
                    value: radioOptions.despesa,
                    groupValue: radioSelected,
                    onChanged: (radioOptions value) {
                      setState(() {
                        radioSelected = radioOptions.despesa;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          var date = dateController.text.split('/');
                          submits[radioSelected](
                                  description: description,
                                  value:
                                      valueController.text.replaceAll(',', ''),
                                  date: date[2] + '-' + date[1] + '-' + date[0])
                              .then((_) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text('Cadastrar'),
                    ),
                  ),
                ]
                    .map((e) => Container(
                          child: e,
                          margin: EdgeInsets.symmetric(vertical: 10),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
