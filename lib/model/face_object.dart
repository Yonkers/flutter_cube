import 'dart:ui' show Color;
import 'mesh_object.dart';
import 'mesh.dart' show Triangle;
import 'package:vector_math/vector_math_64.dart' show Vector3 hide Triangle;

class FaceObject extends MeshObject {
  FaceObject({
    super.position,
    super.rotation,
    super.scale,
    required Vector3 a,
    required Vector3 b,
    required Vector3 c,
    Color? color,
    super.name = 'face-object',
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
      vertices: [a, b, c],
      vertexIndices: [
        Triangle([0, 1, 2], null, null)
      ],
      colors: color != null ? [color, color] : null,
      normalized: normalized,
    );
  }
}
