class ToonParser {
  static Map<String, dynamic> parse(String toonString) {
    final result = <String, dynamic>{
      'alerts': [],
      'parameters': [],
      'recommendations': [],
    };

    final blockRegex = RegExp(r'<([A-Z]+)>([\s\S]*?)<\/\1>');
    final itemRegex = RegExp(r'\[(.*?)\]');
    final pairRegex = RegExp(r'([a-zA-Z0-9_]+)="([^"]*)"');
    final blocks = blockRegex.allMatches(toonString);

    for (final blockMatch in blocks) {
      final tag = blockMatch.group(1)?.toUpperCase() ?? '';
      final content = blockMatch.group(2) ?? '';
      final items = itemRegex.allMatches(content);

      for (final itemMatch in items) {
        final itemContent = itemMatch.group(1) ?? '';
        final pairs = pairRegex.allMatches(itemContent);
        
        final itemMap = <String, String>{};
        for (final pairMatch in pairs) {
          final key = pairMatch.group(1) ?? '';
          final value = pairMatch.group(2) ?? '';
          itemMap[key] = value;
        }
        if (tag == 'ALERTS') {
          result['alerts'].add(itemMap);
        } else if (tag == 'PARAMETERS') {
          result['parameters'].add(itemMap);
        } else if (tag == 'RECOMMENDATIONS') {
          if (itemMap.containsKey('text')) {
            result['recommendations'].add(itemMap['text']);
          }
        }
      }
    }

    return result;
  }
}
