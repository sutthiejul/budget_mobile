import 'package:flutter/material.dart';

ButtonStyle styleButtonCustom(bgcolor) {
  //bgcolor = red;
  return ButtonStyle(backgroundColor: WidgetStateProperty.all(bgcolor));
}

//ElevatedButton style: ButtonCustomElevated(yellow, brown, 18.0, "bold", 25),
ButtonStyle ButtonCustomElevated(
  fgcolor,
  bgcolor,
  double fontsize,
  fontweight,
  double radius,
) {
  FontWeight fweight;
  if (fontweight == "bold") {
    fweight = FontWeight.bold;
  } else {
    fweight = FontWeight.normal;
  }

  return ElevatedButton.styleFrom(
    // Background color
    backgroundColor: bgcolor,

    // Text color
    foregroundColor: fgcolor,

    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    // Text style
    textStyle: TextStyle(fontSize: fontsize, fontWeight: fweight),

    // Shape
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),

    // Elevation
    elevation: 5,
  );
}

ButtonStyle ButtonBlueElevated() {
  return ElevatedButton.styleFrom(
    // Background color
    backgroundColor: Colors.blue,

    // Text color
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    // Text style
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

    // Shape
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

    // Elevation
    elevation: 5,
  );
}

ButtonStyle ButtonBlueElevatedRadius20() {
  return ElevatedButton.styleFrom(
    // Background color
    backgroundColor: Colors.blue,

    // Text color
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    // Text style
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

    // Shape
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

    // Elevation
    elevation: 5,
  );
}

ButtonStyle ButtonRedElevatedRadius20() {
  return ElevatedButton.styleFrom(
    // Background color
    backgroundColor: Colors.red,

    // Text color
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

    // Text style
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

    // Shape
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

    // Elevation
    elevation: 5,
  );
}

ButtonStyle ButtonGreenElevated() {
  return ButtonStyle(
    // Background color
    backgroundColor: WidgetStateProperty.all(Colors.green),

    // Text color
    foregroundColor: WidgetStateProperty.all(Colors.white),

    // Padding
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),

    // Elevation
    elevation: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return 0; // No elevation when pressed
      }
      return 5; // Default elevation
    }),

    // Shape
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
