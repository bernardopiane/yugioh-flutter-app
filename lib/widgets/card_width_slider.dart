import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late final prefs;

  final double minWidth = 100.0;
  final double maxWidth = 400.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() {
          prefs = value;
          cardWidth = prefs.getDouble("cardWidth");
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Card width"),
          cardWidth == null
              ? const CircularProgressIndicator()
              : Slider.adaptive(
                  value: cardWidth!,
                  min: minWidth,
                  max: maxWidth,
                  divisions: 4,
                  label: "Card Width: ",
                  onChanged: (double value) {
                    setState(() {
                      cardWidth = value;
                      prefs.setDouble("cardWidth", value);
                    });
                    //Save selection
                    widget.notifyParent(value);
                  },
                ),
        ],
      ),
    );
  }
}
