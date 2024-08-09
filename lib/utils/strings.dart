String toCamelCase(String str) {
  final parts = str.split('_');
  final camelCased = parts.map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase()).join('');

  if (camelCased.isNotEmpty) {
    return camelCased[0].toLowerCase() + camelCased.substring(1);
  }
  return camelCased;
}

String toSnakeCase(String str) {
  return str
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)}_${match.group(2)!.toLowerCase()}')
      .toLowerCase();
}

String toPascalCase(String str) {
  return str.split('_').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : word).join('');
}
