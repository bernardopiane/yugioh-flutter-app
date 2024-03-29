import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardWidthSlider extends StatefulWidget {
  final Function(double) notifyParent;
  final double currentWidth;

  const CardWidthSlider({
    Key? key,
    required this.notifyParent,
    this.currentWidth = 100,
  }) : super(key: key);

  @override
  CardWidthSliderState createState() => CardWidthSliderState();
}

class CardWidthSliderState extends State<CardWidthSlider> {
  late SharedPreferences prefs;
  double cardWidth = 100.0;
  final double minWidth = 100.0;
  final double maxWidth = 500.0;
  final double stepSizeMultiplier = 1.4;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      cardWidth = prefs.getDouble("cardWidth") ?? widget.currentWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final divisions = calculateDivisions();

    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Card Width: ${cardWidth.toStringAsFixed(0)}"),
          Slider.adaptive(
            value: cardWidth,
            min: minWidth,
            max: maxWidth,
            divisions: divisions,
            label: "Card Width: ${cardWidth.toStringAsFixed(2)}",
            onChanged: (double value) {
              setState(() {
                cardWidth = value.roundToDouble();
              });
              widget.notifyParent(value);
            },
            onChangeEnd: (value) {
              prefs.setDouble("cardWidth", value);
            },
          ),
        ],
      ),
    );
  }

  int calculateDivisions() {
    int divisions = 0;
    double currentWidth = minWidth;

    while (currentWidth < maxWidth) {
      currentWidth *= stepSizeMultiplier;
      divisions++;
    }

    return divisions;
  }
}
