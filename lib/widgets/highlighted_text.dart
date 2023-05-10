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
    const highlightedStyle = FontWeight.bold;
    final highlightColor = Colors.yellow.withOpacity(0.3);

    final words = text.split(' ');

    return RichText(
      text: TextSpan(
        children: words.map<TextSpan>((word) {
          final isHighlighted = highlightedWords.contains(word);
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontWeight: isHighlighted ? highlightedStyle : null,
              backgroundColor: isHighlighted ? highlightColor : null
            )
          );
        }).toList(),
      ),
    );
  }

  BoxDecoration _buildBackgroundBoxDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    );
  }
}