import 'package:flutter/material.dart';

import 'currency.dart';
import 'currency_picker_theme_data.dart';
import 'currency_service.dart';
import 'currency_utils.dart';

class CurrencyListView extends StatefulWidget {
  /// Called when a currency is select.
  ///
  /// The currency picker passes the new value to the callback.
  final ValueChanged<Currency> onSelect;

  /// The Currencies that will appear at the top of the list (optional).
  ///
  /// It takes a list of Currency code.
  final List<String>? favorite;

  /// Can be used to uses filter the Currency list (optional).
  ///
  /// It takes a list of Currency code.
  final List<String>? currencyFilter;

  /// Shows flag for each currency (optional).
  ///
  /// Defaults true.
  final bool showFlag;

  /// Shows currency name (optional).
  /// [showCurrencyName] and [showCurrencyCode] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyName;

  /// Shows currency code (optional).
  /// [showCurrencyCode] and [showCurrencyName] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyCode;

  /// Hint of the search TextField (optional).
  ///
  /// Defaults Search.
  final String? searchHint;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  /// An optional argument for for customizing the
  /// currency list bottom sheet.
  final CurrencyPickerThemeData? theme;

  const CurrencyListView({
    Key? key,
    required this.onSelect,
    this.favorite,
    this.currencyFilter,
    this.searchHint,
    this.showCurrencyCode = true,
    this.showCurrencyName = true,
    this.showFlag = true,
    this.physics,
    this.controller,
    this.theme,
  }) : super(key: key);

  @override
  _CurrencyListViewState createState() => _CurrencyListViewState();
}

class _CurrencyListViewState extends State<CurrencyListView> {
  final CurrencyService _currencyService = CurrencyService();

  late List<Currency> _filteredList;
  late List<Currency> _currencyList;
  List<Currency>? _favoriteList;

  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();

    _currencyList = _currencyService.getAll();

    _filteredList = <Currency>[];

    if (widget.currencyFilter != null) {
      final List<String> currencyFilter =
          widget.currencyFilter!.map((code) => code.toUpperCase()).toList();

      _currencyList
          .removeWhere((element) => !currencyFilter.contains(element.code));
    }

    if (widget.favorite != null) {
      _favoriteList = _currencyService.findCurrenciesByCode(widget.favorite!);
    }

    _filteredList.addAll(_currencyList);
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: widget.searchHint ?? "Search",
              hintText: widget.searchHint ?? "Search",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFF8C98A8).withOpacity(0.2),
                ),
              ),
            ),
            onChanged: _filterSearchResults,
          ),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            children: [
              if (_favoriteList != null) ...[
                ..._favoriteList!
                    .map<Widget>((currency) => _listRow(currency))
                    .toList(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(thickness: 1),
                ),
              ],
              ..._filteredList
                  .map<Widget>((currency) => _listRow(currency))
                  .toList()
            ],
          ),
        ),
      ],
    );
  }

  Widget _listRow(Currency currency) {
    return CurrencyListTile(
      currency: currency,
      theme: widget.theme,
      onTap: () {
        widget.onSelect.call(currency);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _filterSearchResults(String query) {
    List<Currency> _searchResult = <Currency>[];

    if (query.isEmpty) {
      _searchResult.addAll(_currencyList);
    } else {
      _searchResult = _currencyList
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() => _filteredList = _searchResult);
  }
}

class CurrencyListTile extends StatelessWidget {
  final Currency currency;
  final CurrencyPickerThemeData? theme;

  /// Called when a currency is select.
  ///
  /// The currency picker passes the new value to the callback.
  final VoidCallback? onTap;

  /// Shows flag for each currency (optional).
  ///
  /// Defaults true.
  final bool showFlag;

  /// Shows currency name (optional).
  /// [showCurrencyName] and [showCurrencyCode] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyName;

  /// Shows currency code (optional).
  /// [showCurrencyCode] and [showCurrencyName] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyCode;

  /// show if currency is selected
  final bool selected;

  const CurrencyListTile({
    Key? key,
    required this.currency,
    this.theme,
    this.showFlag = true,
    this.showCurrencyName = true,
    this.showCurrencyCode = true,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final _defaultTitleTextStyle = TextStyle(
      fontSize: 17,
      color: selected
          ? themeData.listTileTheme.selectedTileColor
          : themeData.textTheme.bodyText1?.color,
    );
    final _defaultSubtitleTextStyle = TextStyle(
      fontSize: 15,
      color: selected
          ? themeData.listTileTheme.selectedTileColor
          : themeData.hintColor,
    );
    final TextStyle _titleTextStyle =
        theme?.titleTextStyle ?? _defaultTitleTextStyle;
    final TextStyle _subtitleTextStyle =
        theme?.subtitleTextStyle ?? _defaultSubtitleTextStyle;
    final Color backgroundColor =
        selected ? themeData.cardColor : Colors.transparent;

    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 15),
                    if (showFlag) ...[
                      Text(
                        CurrencyUtils.currencyToEmoji(currency),
                        style: TextStyle(
                          fontSize: theme?.flagSize ?? 25,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showCurrencyCode)
                            Text(
                              currency.code,
                              style: _titleTextStyle,
                            ),
                          if (showCurrencyName)
                            Text(
                              currency.name,
                              style: showCurrencyCode
                                  ? _subtitleTextStyle
                                  : _titleTextStyle,
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  currency.symbol,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
