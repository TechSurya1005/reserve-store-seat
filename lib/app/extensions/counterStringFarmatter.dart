extension StringCountFormatter on String {
  String get formatCount {
    final num? value = num.tryParse(this);

    if (value == null) return this;

    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2).replaceAll('.0', '')}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2).replaceAll('.0', '')}M';
    } else if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(2).replaceAll('.0', '')}K';
    } else {
      return value.toInt().toString();
    }
  }
}

extension StringAmountFormatter on String {
  String get formatAmount {
    final num? value = num.tryParse(this);

    if (value == null) return this;

    if (value >= 10000000) {
      // 1 Crore
      return '${(value / 10000000).toStringAsFixed(1).replaceAll('.0', '')} Cr';
    } else if (value >= 100000) {
      // 1 Lakh
      return '${(value / 100000).toStringAsFixed(1).replaceAll('.0', '')} L';
    } else if (value >= 1000) {
      // 1 Thousand
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '')} K';
    } else {
      return value.toInt().toString();
    }
  }
}

extension StringAmountFormatterFullText on String {
  String get formatAmountFullText {
    final num? value = num.tryParse(this);
    if (value == null) return this;

    if (value >= 1000000000) {
      // 1 Billion
      return '${(value / 1000000000).toStringAsFixed(1).replaceAll('.0', '')} Billion';
    } else if (value >= 10000000) {
      // 1 Crore
      return '${(value / 10000000).toStringAsFixed(1).replaceAll('.0', '')} Crore';
    } else if (value >= 100000) {
      // 1 Lakh
      return '${(value / 100000).toStringAsFixed(1).replaceAll('.0', '')} Lakh';
    } else if (value >= 1000) {
      // 1 Thousand
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '')} Thousand';
    } else if (value >= 100) {
      // 1 Hundred
      return '${(value / 100).toStringAsFixed(1).replaceAll('.0', '')} Hundred';
    } else {
      return value.toInt().toString();
    }
  }
}

extension AmountFormat on String {
  String get withComma {
    final value = num.tryParse(replaceAll(',', ''));
    if (value == null) return this;

    final parts = value.toString().split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );

    if (parts.length == 2 && int.parse(parts[1]) != 0) {
      return '$intPart.${parts[1]}';
    }
    return intPart;
  }
}
