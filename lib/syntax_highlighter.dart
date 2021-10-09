import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:highlight/highlight.dart' show highlight, Node;
import 'package:rich_code_editor/exports.dart';

class SyntaxHighlighter implements SyntaxHighlighterBase {
  @override
  TextEditingValue addTextRemotely(TextEditingValue oldValue, String newText) {
    return null;
  }
   @override
  TextEditingValue onEnterPress(TextEditingValue oldValue) {
    var padding = "  ";
    var newText = oldValue.text + padding;
    var newValue = oldValue.copyWith(
      text: newText,
      composing: TextRange(start: -1, end: -1),
      selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.upstream, offset: newText.length)),
    );

    return newValue;
  }

  @override
  TextEditingValue onBackSpacePress(
      TextEditingValue oldValue, TextSpan currentSpan) {
    return null;
  }

 
  List<TextSpan> _convert(List<Node> nodes) {
    final theme = themeMap['solarized-dark'];

    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children.forEach((n) {
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }

  @override
  List<TextSpan> parseText(TextEditingValue tev) {
    var _textStyle = TextStyle(
      fontFamily: 'RobotoMono',
      color: Colors.white,
    );

    return [
      TextSpan(
        style: _textStyle,
        children:
            _convert(highlight.parse(tev.text, language: 'javascript').nodes),
      )
    ];
  }
}
