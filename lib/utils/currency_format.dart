import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'IDR ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }
}
