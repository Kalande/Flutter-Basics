import 'package:flutter/material.dart';


class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final dynamic height;
  
  AnimatedProgressbar({Key? key, required this.value, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( //Allows us to build responsive widgets when the max height and width of parent container is not known
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(height))
                  ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                   color: _colorGen(value),
                   borderRadius: BorderRadius.all(Radius.circular(height))
                ),
              ),
            ],
          ),

        );
      } 
      );
  }

  //Always makes sure the value is not negative
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rbg).withRed(255-rbg);
  }
}