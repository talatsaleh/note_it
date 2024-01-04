import 'package:flutter/material.dart';

List<Color> mainColors = [
  const Color.fromARGB(255, 166, 234, 255),
  const Color.fromARGB(255, 243, 224, 158),
  const Color.fromARGB(255, 205, 255, 166),
  const Color.fromARGB(255, 242, 156, 224),
];

class ColorsWidget extends StatefulWidget {
  const ColorsWidget({super.key, required this.saveColor});

  final Function(Color?) saveColor;

  @override
  State<ColorsWidget> createState() => _ColorsWidgetState();
}

class _ColorsWidgetState extends State<ColorsWidget> {
  Color? colorSelected;

  void selectColor(Color color) {
    setState(() {
      if (colorSelected == color) {
        colorSelected = null;
        widget.saveColor(colorSelected);
        return;
      }
      colorSelected = color;
      widget.saveColor(colorSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: mainColors.map((color) {
        return InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () => selectColor(color),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white24, width: colorSelected == color ? 2 : 0),
            ),
            child: CircleAvatar(
              backgroundColor: color,
              radius: colorSelected == color ? 30 : 25,
            ),
          ),
        );
      }).toList(),
    );
  }
}
