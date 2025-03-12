import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'molecule_renderer.dart'; // Assurez-vous que ce fichier est correct et accessible
import '../models/atom.dart';
import '../models/bond.dart';

class InteractiveMoleculeRenderer extends StatefulWidget {
  final List<Atom> atoms;
  final List<Bond> bonds;

  const InteractiveMoleculeRenderer({
    super.key,
    required this.atoms,
    required this.bonds,
  });

  @override
  State<InteractiveMoleculeRenderer> createState() =>
      _InteractiveMoleculeRendererState();
}

class _InteractiveMoleculeRendererState
    extends State<InteractiveMoleculeRenderer> {
  final vm.Vector3 _rotation = vm.Vector3.zero();
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Utilisation d'un seul gestionnaire pour le scale qui inclut la rotation
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = details.scale;
          // Incrémente la rotation autour de l'axe Y (vous pouvez ajuster la sensibilité ici)
          _rotation.y += details.rotation;
        });
      },
      child: CustomPaint(
        painter: MoleculePainter(
          atoms: widget.atoms,
          bonds: widget.bonds,
          rotation: _rotation,
          scale: _scale,
        ),
        child: Container(),
      ),
    );
  }
}
