import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../models/atom.dart';
import '../models/bond.dart';

class MoleculePainter extends CustomPainter {
  final List<Atom> atoms;
  final List<Bond> bonds;
  final vm.Vector3 rotation;
  final double scale;

  MoleculePainter({
    required this.atoms,
    required this.bonds,
    required this.rotation,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Centre le canvas
    canvas.translate(size.width / 2, size.height / 2);

    // Applique l'échelle
    canvas.scale(scale, scale);

    // Applique la rotation sur l'axe Y (dans le plan)
    canvas.rotate(rotation.y);

    // Exemple de dessin des atomes
    Paint atomPaint = Paint()..color = Colors.blue;
    for (var atom in atoms) {
      // Ajustez le rayon et la conversion des coordonnées selon vos besoins
      canvas.drawCircle(Offset(atom.x, atom.y), 5.0, atomPaint);
    }

    // Exemple de dessin des liaisons
    Paint bondPaint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 2.0;
    for (var bond in bonds) {
      Atom atom1 = atoms[bond.startAtomId];
      Atom atom2 = atoms[bond.endAtomId];
      canvas.drawLine(
        Offset(atom1.x, atom1.y),
        Offset(atom2.x, atom2.y),
        bondPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MoleculePainter oldDelegate) {
    return oldDelegate.atoms != atoms ||
        oldDelegate.bonds != bonds ||
        oldDelegate.rotation != rotation ||
        oldDelegate.scale != scale;
  }
}
