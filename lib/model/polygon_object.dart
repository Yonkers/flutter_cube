import 'dart:ui' show BlendMode, Canvas, Color, Paint, PointMode;
import 'mesh_object.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class PolygonObject extends MeshObject {
  late double thick;

  PolygonObject({
    super.position,
    super.rotation,
    super.scale,
    // super.mesh,
    required List<Vector3> points,
    this.thick = 1.0,
    Color? color,
    super.name = 'polygon-object',
    super.scene,
    super.parent,
    super.backfaceCulling = true,
    super.lighting = true,
    super.visiable = true,
    super.xray = false,
    super.showVerts = false,
    bool normalized = false,
  }) {
    makeMesh(
      vertices: points,
      colors: color != null ? [color, color] : null,
      normalized: normalized,
    );
  }

  @override
  void draw(
    Canvas canvas,
    BlendMode blendMode,
    Paint paint,
  ) {
    if (mesh.drawingPoints != null) {
      if (mesh.colors.length > 0) {
        paint.color = mesh.colors.first;
      }
      paint.strokeWidth = thick;
      canvas.drawRawPoints(PointMode.polygon, mesh.drawingPoints!, paint);
      mesh.drawingPoints = null;
    }
  }
}
