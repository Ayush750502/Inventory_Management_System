import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'csv_form.dart';

class CsvReader extends StatefulWidget {
  @override
  _CsvReaderState createState() => _CsvReaderState();
}

class _CsvReaderState extends State<CsvReader> {
  List<List<dynamic>> _csvData = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      File file = File(result.files.single.path!);
      final content = await file.readAsString();
      setState(() {
        _csvData = const CsvToListConverter().convert(content);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CSV Reader')),
      body: Column(
        children: [
          ElevatedButton(onPressed: _pickFile, child: Text('Pick CSV File')),
          ElevatedButton(
            onPressed: () {
              if (_csvData.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CsvForm(fieldNames: List<String>.from(_csvData.first)),
                  ),
                );
              }
            },
            child: Text('Create Form'),
          ),
          _csvData.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _csvData.first
                          .map((header) => DataColumn(
                                label: Text(header.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ))
                          .toList(),
                      rows: _csvData
                          .skip(1) // Skip the header row
                          .map((row) => DataRow(
                                cells: row
                                    .map((cell) =>
                                        DataCell(Text(cell.toString())))
                                    .toList(),
                              ))
                          .toList(),
                    ),
                  ),
                )
              : Center(child: Text('No CSV data loaded')),
        ],
      ),
    );
  }
}
