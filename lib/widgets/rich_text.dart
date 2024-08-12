import 'package:flutter/material.dart';
import 'package:forleha/models/span_model.dart';

class RichSpanText extends StatelessWidget {

  final SpanTextModel spanText;

  const RichSpanText({super.key, required this.spanText});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: spanText.title,
        style: Theme.of(context).textTheme.bodyLarge,
        children: <TextSpan>[
          TextSpan(
            text: spanText.data,
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: spanText.postTitle),
        ],
      ),
    );
  }
}
