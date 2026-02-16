import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderWidget extends StatelessWidget {
  final Color color;
  final double size;
  final SpinKitType type;

  const LoaderWidget({
    super.key,
    this.color = Colors.blue,
    this.size = 50.0,
    this.type = SpinKitType.fadingCircle, // default loader type
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SpinKitType.circle:
        return SpinKitCircle(color: color, size: size);
      case SpinKitType.chasingDots:
        return SpinKitChasingDots(color: color, size: size);
      case SpinKitType.wave:
        return SpinKitWave(color: color, size: size);
      case SpinKitType.pulse:
        return SpinKitPulse(color: color, size: size);
      case SpinKitType.doubleBounce:
        return SpinKitDoubleBounce(color: color, size: size);
      case SpinKitType.fadingCircle:
        return SpinKitFadingCircle(color: color, size: size);
    }
  }
}

/// Enum for selecting loader type
enum SpinKitType {
  circle,
  chasingDots,
  wave,
  pulse,
  doubleBounce,
  fadingCircle,
}
