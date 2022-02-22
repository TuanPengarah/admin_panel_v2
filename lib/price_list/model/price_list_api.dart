import 'package:admin_panel/price_list/model/pricelist_field.dart';
import 'package:admin_panel/price_list/model/pricelist_model.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class PriceListApi {
  static const _credential = r'''
{
  "type": "service_account",
  "project_id": "af-fix-database",
  "private_key_id": "9db5b42d857dc0fca30a21bd3f4fca09e750879a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1HaA4Wf0yXuBE\nbMYGRQi21FUNZMjF0iu8CLnQZC1BdAWKwZUrBATPqVaBzgqSnfLgTAWIt4Yd+l6w\nQ+s6Xvi0Bq5uYEXXAdY3fzvpr0ZdKV8xZ9zfxLb0/8+4kx2fxhILfOxH9vHlGxrz\n7PPtvR8H5foLQkj3thiryblqPe3XK96BQgDft8PATggZS1y+TcS0bofBL30QvvBb\nuSIaUrxFL4rus7+kyUoK746bx7c1fRU9fZ8sSdiBe+U1FDqRoe25E06RIkvEtaKN\nlNF3iNiRIr4dy6HJL0wgwIE/JtLyYnnpjNDrH0qqbjszmzS0QQQAXkLECVzLf4Kg\nISTB2gK5AgMBAAECggEAIw+0J5SMJoclZTmlcCtHD5W1TV14XIteOg16YzQxap1a\nQU1OYkBp6gV/IKvRciavkOpGm/vjM8R3Nio/zFH8VWWBuQ5cFs5dOOshnxB2T6yl\np/vST2NWg8FN5g5cysReU+kAGMJee5qusg/p/NkCu9WyfSF83K9cwUzQ3xdUBrY8\nxSQyqswvHuddI9wHtDdw2rQu+V9zGvUxyMiiVSQr5tbaLtZkHVENgF+p9HzLsYF0\ncJy5kF9ziFiMFvNFQjQDCzq3rbTGFmWp4wF9TDAIt2adRUkyvFj8U64BRYzvReYf\ni91jcqO4R4kW8w8x8rnE6lyhz9khQ3vRm5L6sBkfcQKBgQDoYvY2NJZDFjLiyrte\n7WFqKX9oSjpDZhXgEQ2il4MSr5CxxQBJdr5ASvroquEA89r5epOnXfe/ldLZvT73\neeSl488oZpdZBPEZ4+pJP1bWAF+uBGCC8ZSuN9TGZ2kfdOBH5WK89GMKU9s33Ruo\nHwohNN4CPnjnCtOanWm8n4obtQKBgQDHhPaK/IMlb/aKrWVx0LLItmB4UWXZlx82\nOh2K5V8G9/lEHP9VF/cBPwjCWUmpb+s8L7DhZ/8/cdfjv1t2b8A95osjO1ePBnoX\nSdpOzI74/gUXpd51UI6tjf3PeUhzFcPJFxe/+1pO6/xkxmxmYyNSA6AhRrsS7YvH\n5jaLPg+VdQKBgQCPr7Dg7z8BmBY6mHOmTExxYds/VrYTumlINAMkR15qDVgAMvjs\nc5lLE5F0j0O0XRNGMn5dfAKV2UOYEiV+y0WPNP5/0n8+MYoKIhxY0esVQwHmDRrH\nnCv8VNUhIAulwZRzn+efQdSDLDpdnj9dgmO3CINFC++hm9YewboBQPwaCQKBgEz2\nPSPfw7btOWzE9hyxJEXIE+5Vd7Q3VxLT2BF76OwHO1/Kz7NDS0RvzDErv/5b7aGJ\nw/Eu7IbMozp21hEZik5WX9V3To8dMHtLQaqjvYLOeahlkyotqNvJqd4eKpQ6EQvA\nnKixjGRlIza8U5QrKbS5MUukvQTQHNs/MksD5X8BAoGAYmjcvNPTibstCRY+zj4L\ngks8eHBccANF3M1HoyfahH1OY/BAMw1vqbEY8NTMO0b6sOeLMCwciZzI9ImF6B3P\nuiYikswmCV2Rs3A2vKHD1WtWS6bZs7NcIqC0SkR1mA47VRHxLwM7Ma2b+TOYS/9+\nK+IsNF0+w32sPOUl0Ggi6wY=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@af-fix-database.iam.gserviceaccount.com",
  "client_id": "109653529169043271524",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40af-fix-database.iam.gserviceaccount.com"
}
''';
  static final _spreadSheetId = '1Sng5zl52Px3KUhAXW4G7IFPyIMmCnrP_SPCS_nTXsbk';

  static final _gsheet = GSheets(_credential);
  static Worksheet _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheet.spreadsheet(_spreadSheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Parts');
      final firstRow = PriceListField.getFields();
      _userSheet.values.insertRow(1, firstRow);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet.values.map.appendRows(rowList);
  }

  static Future<List<PriceListModel>> getAll() async {
    if (_userSheet == null) return <PriceListModel>[];
    final pricelist = await _userSheet.values.map.allRows();

    return pricelist.map(PriceListModel.fromJson).toList();
  }

  static Future update({
    @required int id,
    @required String partsKey,
    @required String modelKey,
    @required String hargaKey,
    @required String partsValue,
    @required String modelValue,
    @required String hargaValue,
  }) async {
    if (_userSheet == null) return;

    //update model
    await _userSheet.values.insertValueByKeys(
      modelValue,
      columnKey: modelKey,
      rowKey: id,
    );
    //update parts
    await _userSheet.values.insertValueByKeys(
      partsValue,
      columnKey: partsKey,
      rowKey: id,
    );
    //update harga
    await _userSheet.values.insertValueByKeys(
      hargaValue,
      columnKey: hargaKey,
      rowKey: id,
    );

    //update id
    await _userSheet.values.insertValueByKeys(
        DateTime.now().millisecondsSinceEpoch,
        columnKey: 'ID',
        rowKey: id);
  }

  Future<void> delete(int id) async {
    if (_userSheet == null) return;

    _userSheet.values.rowIndexOf(id).then((value) {
      if (value > 0) {
        _userSheet.deleteRow(value);
      }
    });
  }
}
