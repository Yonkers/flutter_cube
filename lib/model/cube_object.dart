import 'dart:ui' show Color;
import 'package:flutter_cube/model/plane_object.dart';
import 'mesh.dart';
import 'mesh_object.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3 hide Triangle;

class CubeObject extends MeshObject {
  CubeObject({
    super.position,
    super.rotation,
    super.scale,
    required Vector3 size,
    Color? color,
    super.name = 'cube-object',
    super.scene,
    super.parent,
    super.backfaceCulling = true,
    super.lighting = true,
    super.visiable = true,
    super.xray = false,
    super.showVerts = false,
    bool normalized = false,
  }) {
    this.mesh = Mesh();

    PlaneObject xy = PlaneObject(
      a: Vector3(0, 0, 0),
      b: Vector3(size.x, 0, 0),
      c: Vector3(size.x, size.y, 0),
      d: Vector3(0, size.y, 0),
      color: color,
      name: 'cube-xy',
      normalized: normalized,
    );

    add(xy);

    PlaneObject yz = PlaneObject(
      a: Vector3(0, 0, 0),
      b: Vector3(0, size.y, 0),
      c: Vector3(0, size.y, size.z),
      d: Vector3(0, 0, size.z),
      color: color,
      name: 'cube-yz',
      normalized: normalized,
    );
    add(yz);

    PlaneObject xzb = PlaneObject(
      a: Vector3(0, size.y, 0),
      b: Vector3(size.x, size.y, 0),
      c: Vector3(size.x, size.y, size.z),
      d: Vector3(0, size.y, size.z),
      color: color,
      name: 'cube-xzb',
      normalized: normalized,
    );
    add(xzb);
  }
}
