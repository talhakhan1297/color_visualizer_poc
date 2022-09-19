import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var rect = Rect.fromPoints(
    const Offset(0, 288),
    const Offset(216, 330),
  );
  var wall = Colors.green;
  var ceiling = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTapUp: (details) {
            if (rect.contains(details.globalPosition)) {
              setState(() {
                if (wall == Colors.green) {
                  wall = Colors.yellow;
                } else {
                  wall = Colors.green;
                }
              });
            } else {
              setState(() {
                if (ceiling == Colors.blue) {
                  ceiling = Colors.grey;
                } else {
                  ceiling = Colors.blue;
                }
              });
            }
            // tl: 3.6, 287.6
            // tr: 217.4, 311.6
            // bl: 2.5, 315.2
            // br: 217.4, 330.9
            // print(a);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/base.png",
              ),
              BlendMask(
                blendMode: BlendMode.multiply,
                child: Image.asset(
                  "assets/mask1.png",
                  color: Colors.red,
                ),
              ),
              BlendMask(
                blendMode: BlendMode.multiply,
                child: Image.asset(
                  "assets/mask2.png",
                  color: Colors.blue,
                ),
              ),
              BlendMask(
                blendMode: BlendMode.multiply,
                child: Image.asset(
                  "assets/mask3.png",
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;
  final double opacity;

  const BlendMask({
    required this.blendMode,
    this.opacity = 1.0,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(context) {
    return RenderBlendMask(blendMode, opacity);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  BlendMode blendMode;
  double opacity;

  RenderBlendMask(this.blendMode, this.opacity);

  @override
  void paint(context, offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()
        ..blendMode = blendMode
        ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
    );

    super.paint(context, offset);

    context.canvas.restore();
  }
}
