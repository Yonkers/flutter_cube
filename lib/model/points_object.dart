import 'dart:ui' show BlendMode, Canvas, Color, Paint, PointMode, Offset;
import 'mesh_object.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class PointsObject extends MeshObject {
  late double pointSize;

  PointsObject({
    super.position,
    super.rotation,
    super.scale,
    // super.mesh,
    required List<Vector3> points,
    Color? color,
    List<Color>? colors,
    this.pointSize = 3,
    super.name = 'points-object',
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
      colors: colors ?? (color != null ? [color] : null),
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
      final int colorCount = mesh.colors?.length ?? 0;
      if(colorCount == mesh.drawingPoints!.length / 2){
        for(int i = 0; i < colorCount;i++){
          paint.color = mesh.colors[i];
          canvas.drawCircle(Offset(mesh.drawingPoints![i * 2], mesh.drawingPoints![i * 2 + 1]), pointSize, paint);
        }
      }else{
        if (colorCount > 0) {
          paint.color = mesh.colors.first;
        }
        paint.strokeWidth = pointSize;
        canvas.drawRawPoints(PointMode.points, mesh.drawingPoints!, paint);
        mesh.drawingPoints = null;
      }
    }
  }
}
