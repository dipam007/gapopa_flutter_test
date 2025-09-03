abstract class Part {
  String get text; // common property
}

class TextPart implements Part {
  @override
  final String text;
  TextPart(this.text);

  @override
  String toString() => "Text('$text')";
}

class LinkPart implements Part {
  @override
  final String text;
  LinkPart(this.text);

  @override
  String toString() => "Link('$text')";
}

extension LinkParser on String {
  List<Part> categoriseTextAndLink() {
    final regex = RegExp(r'(https?:\/\/\S+|[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})');
    final result = <Part>[];
    int lastIndex = 0;

    for (final match in regex.allMatches(this)) {
      if (match.start > lastIndex) {
        result.add(TextPart(substring(lastIndex, match.start)));
      }
      result.add(LinkPart(match.group(0)!));
      lastIndex = match.end;
    }

    if (lastIndex < length) {
      result.add(TextPart(substring(lastIndex)));
    }

    return result;
  }
}

void main() {
  // Implement an extension on [String], parsing links from a text.
  //
  // Extension should return a [List] of texts and links, e.g.:
  // - `Hello, google.com, yay` ->
  //   [Text('Hello, '), Link('google.com'), Text(', yay')].

   final textLinkStr = "Hello, google.com, yay";
   print(textLinkStr.categoriseTextAndLink()); 
   //Output: [Text('Hello, '), Link('google.com'), Text(', yay')]
}
