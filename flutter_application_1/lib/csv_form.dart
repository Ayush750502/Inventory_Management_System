import 'package:flutter/material.dart';

class CsvForm extends StatelessWidget {
  final List<String> fieldNames;

  CsvForm({required this.fieldNames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Form')),
      body: Form(
        child: ListView.builder(
          itemCount: fieldNames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: fieldNames[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
