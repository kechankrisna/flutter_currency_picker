import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

import 'screens/currency_listview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo for currency picker package',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo for currency picker')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  onSelect: (Currency currency) {
                    print('Select currency: ${currency.name}');
                  },
                  favorite: ['USD', 'KHR', 'THB'],
                );
              },
              child: const Text('Show currency picker'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CurrencyListViewScreen()));
              },
              child: Text("currency listview"),
            )
          ],
        ),
      ),
    );
  }
}
