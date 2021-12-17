import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';

class CurrencyListViewScreen extends StatefulWidget {
  const CurrencyListViewScreen({Key? key}) : super(key: key);

  @override
  _CurrencyListViewScreenState createState() => _CurrencyListViewScreenState();
}

class _CurrencyListViewScreenState extends State<CurrencyListViewScreen> {
  final CurrencyService _service = CurrencyService();
  late List<Currency> _currencies = [];
  late Currency _currency;

  @override
  void initState() {
    _currency = _service.findByCode("KHR")!;
    _currencies = _service.getAll();
    super.initState();
  }

  _onSearch(value) {
    var reg = RegExp("($value)", caseSensitive: false);
    List<Currency> result = _service
        .getAll()
        .where((e) =>
            e.code.contains(reg) ||
            e.name.contains(reg) ||
            e.namePlural.contains(reg) ||
            e.symbol.contains(reg))
        .toList();
    if (result.isNotEmpty) {
      setState(() {
        _currencies = result;
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("currencies"),
      ),
      body: Column(
        children: [
          TextFormField(onChanged: _onSearch),
          Expanded(
            child: ListView.builder(
              itemCount: _currencies.length,
              itemBuilder: (_, i) {
                final currency = _currencies[i];
                return CurrencyListTile(
                  currency: currency,
                  selected: currency.code == _currency.code,
                  onTap: () {
                    setState(() => _currency = currency);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
