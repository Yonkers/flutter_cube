import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter_cube/scene/scene.dart';
import 'package:flutter/material.dart';

typedef void SceneCreatedCallback(Scene scene);

enum CubeCallbacks { OnTap, RemoveObject }

class Cube extends StatefulWidget {
  Cube({
    Key? key,
    this.interactive = true,
    this.onSceneCreated,
    this.onObjectCreated,
    this.onSceneUpdated,
    this.callback,

  }) : super(key: key);

  final bool interactive;
  final SceneCreatedCallback? onSceneCreated;
  final ObjectCreatedCallback? onObjectCreated;
  final VoidCallback? onSceneUpdated;
  final Function(CubeCallbacks call, Offset? details)? callback;

  @override
  _CubeState createState() => _CubeState();
}

class _CubeState extends State<Cube> {
  late Scene scene;
  late Offset _lastFocalPoint;
  double? _lastZoom;
  double _scroll = 1.0;
  double _scale = 0;
  int _mouseType = 0;
  late Offset _hoverPoint;

  void _onTap() {
    // print('on tap: $_hoverPoint');
    _lastZoom = null;
    Offset position = _hoverPoint;
    scene.updateTapLocation(position);
    // var clicked = scene.clickedObject();
    widget.callback?.call(CubeCallbacks.OnTap, _hoverPoint);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
    _lastZoom = scene.camera.zoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // _lastFocalPoint = details.localFocalPoint;
    bool pan = details.scale == 1.0;

    scene.camera.zoom = _lastZoom! * details.scale;
    if (_mouseType == kPrimaryMouseButton || !pan) {
      scene.camera.trackBall(toVector2(_lastFocalPoint), toVector2(details.localFocalPoint), .85);
    } else if (_mouseType == kSecondaryMouseButton || pan) {
      _handelPanUpdate(details.localFocalPoint);
    }
    _lastFocalPoint = details.localFocalPoint;
    setState(() {});
  }

  void _handelPanUpdate(Offset localFocalPoint) {
    scene.camera.panCamera(toVector2(_lastFocalPoint), toVector2(localFocalPoint), .125);
  }

  @override
  void initState() {
    super.initState();
    scene = Scene(
      // onUpdate: () {
      // widget.onSceneUpdated?.call();
      // if (tapped) {
      //   widget.callback?.call(call: CubeCallbacks.OnTap);
      //   tapped = false;
      // }
      // },
      onObjectCreated: widget.onObjectCreated,
    );
    // prevent setState() or markNeedsBuild called during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSceneCreated?.call(scene);
      _scroll = scene.camera.zoom;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      scene.camera.viewportWidth = constraints.maxWidth;
      scene.camera.viewportHeight = constraints.maxHeight;
      final customPaint = CustomPaint(
        painter: _CubePainter(scene),
        size: Size(constraints.maxWidth, constraints.maxHeight),
        isComplex: true,
      );
      return widget.interactive
          ? Listener(
              onPointerMove: (details) {
                _mouseType = details.buttons;
              },
              onPointerHover: (details) {
                _hoverPoint = details.localPosition;
                if (scene.rayCasting) scene.updateHoverLocation(details.localPosition);
              },
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final scaleStartDetails = ScaleStartDetails(
                    focalPoint: event.position,
                    localFocalPoint: event.localPosition,
                  );
                  _onScaleStart(scaleStartDetails);

                  final double scaleChange = 1.0 - event.scrollDelta.dy / scene.camera.viewportHeight;
                  if (scaleChange == 0.0) {
                    return;
                  }
                  final scaleUpdateDetails = ScaleUpdateDetails(
                    focalPoint: event.position,
                    localFocalPoint: event.localPosition,
                    rotation: 0.0,
                    scale: scaleChange,
                    horizontalScale: scaleChange,
                    verticalScale: scaleChange,
                  );
                  _onScaleUpdate(scaleUpdateDetails);
                }
              },
              child: GestureDetector(
                trackpadScrollCausesScale: true,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onTapDown: (TapDownDetails details) {
                  // print('tap down ${details.localPosition}');
                },
                onTapUp: (TapUpDetails details) {},
                onTap: _onTap,
                child: customPaint,
              ))
          : customPaint;
    });
  }
}

class _CubePainter extends CustomPainter {
  final Scene _scene;
  bool _dirty = false;
  _CubePainter(this._scene) {
    _scene.controller.addListener(() {
      _dirty = true;
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    _dirty = false;
    _scene.render(canvas, size);
  }

  // We should repaint whenever the board changes, such as board.selected.
  @override
  bool shouldRepaint(_CubePainter oldDelegate) {
    return _dirty;
  }
}

/// Convert Offset to Vector2
Vector2 toVector2(Offset value) {
  return Vector2(value.dx, value.dy);
}
