import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final List<String> highlightedWords;

  const HighlightedText({
    Key? key,
    required this.text,
    required this.highlightedWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const highlightedStyle = TextStyle(fontWeight: FontWeight.bold);

    final words = text.split(' ');

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black
        ),
        children: words.map<TextSpan>((word) {
          final isHighlighted = highlightedWords.contains(word);
          return TextSpan(
            text: '$word ',
            style: isHighlighted ? highlightedStyle : null,
          );
        }).toList(),
      ),
    );
  }
}