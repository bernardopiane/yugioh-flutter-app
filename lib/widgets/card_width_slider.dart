import 'package:flutter/material.dart';

class CardWidthSlider extends StatefulWidget {
  final notifyParent;
  final double currentWidth;
  const CardWidthSlider(
      {Key? key, required this.notifyParent, this.currentWidth = 100})
      : super(key: key);

  @override
  _CardWidthSliderState createState() => _CardWidthSliderState();
}

class _CardWidthSliderState extends State<CardWidthSlider> {
  double? cardWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      cardWidth = widget.currentWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Column(
        children: [
          const Text("Card width"),
          Slider(
            value: cardWidth!,
            min: 100.0,
            max: 400.0,
            label: "Card Width: ",
            onChanged: (double value) {
              setState(() {
                cardWidth = value;
              });
              widget.notifyParent(value);
            },
          ),
        ],
      ),
    );
  }
}
