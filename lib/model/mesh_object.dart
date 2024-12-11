import 'dart:ui' show BlendMode, Canvas, Color, Offset, Paint;
import 'object.dart';
import 'mesh.dart';
import 'material.dart' show fromColor;
import 'package:vector_math/vector_math_64.dart' show Vector3;

Future<Mesh> fromVertices({
  required List<Vector3> vertices,
  List<Triangle>? vertexIndices,
  List<Color>? colors,
  bool normalized = true,
}) async {
  // List<Vector3> vertices = <Vector3>[];
  List<Vector3> normals = <Vector3>[];
  List<Offset> texcoords = <Offset>[];
  // List<Triangle> vertexIndices = <Triangle>[];
  List<String> elementNames = <String>[];
  List<String> elementMaterials = <String>[];
  List<int> elementOffsets = <int>[];
  List<Mesh> meshes = await buildMesh(vertices, normals, texcoords, vertexIndices ?? [], null, elementNames, elementMaterials, elementOffsets, "", false);
  List<Mesh> _meshes = normalized ? normalizeMesh(meshes) : meshes;
  if (colors != null) {
    _meshes.first.colors = colors;
    _meshes.first.material.diffuse = fromColor(colors.first);
  }
  return _meshes.first;
}

class MeshObject extends Object {
  MeshObject({
    super.position,
    super.rotation,
    super.scale,
    // required List<Vector3> vertices,
    // List<Triangle>? vertexIndices,
    Color? color,
    super.name = 'mesh-object',
    super.scene,
    super.parent,
    super.backfaceCulling = true,
    super.lighting = true,
    super.visiable = true,
    super.xray = false,
    super.showVerts = false,
    super.normalized = false,
  }) {
    // makeMesh(vertices: vertices, vertexIndices: vertexIndices, colors: color != null ? [color, color] : null);
  }

  makeMesh({
    required List<Vector3> vertices,
    List<Triangle>? vertexIndices,
    List<Color>? colors,
    bool normalized = false,
  }) async {
    mesh = await fromVertices(vertices: vertices, vertexIndices: vertexIndices, colors: colors, normalized: normalized);
    // mesh.colors = colors;
    if (colors != null && colors.length > 0) {
      mesh.material.diffuse = fromColor(colors.first);
      mesh.material.opacity = colors.first.opacity;
    }
  }

  void draw(Canvas canvas, BlendMode blendMode, Paint paint) {}
}
