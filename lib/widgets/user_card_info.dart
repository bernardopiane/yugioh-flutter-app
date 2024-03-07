import 'package:flutter/material.dart';

class UserCardInfo extends StatelessWidget {
  const UserCardInfo({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: SizedBox(
          height: 128,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              message,
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}
