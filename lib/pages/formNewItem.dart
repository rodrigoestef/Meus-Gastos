import 'package:flutter/material.dart';

class FormNewItem extends StatelessWidget {
  const FormNewItem();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 40,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'data',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 40,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'valor',
                                  border: OutlineInputBorder(),
                                ),
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
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Cadastrar'),
                    ),
                  )
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
