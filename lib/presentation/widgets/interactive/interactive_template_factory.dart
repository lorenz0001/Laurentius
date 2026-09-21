import 'package:flutter/material.dart';

import '../../../domain/models/knowledge_node.dart';
import 'cartesian_graph_widget.dart';
import 'derivative_tangent_widget.dart';
import 'kinematics_simulation_widget.dart';
import 'live_equation_widget.dart';
import 'ohm_circuit_simulation_widget.dart';
import 'quadratic_visual_proof_widget.dart';
import 'riemann_sum_widget.dart';
import 'rolle_lagrange_widget.dart';
import 'squeeze_theorem_widget.dart';
import 'triangle_solver_widget.dart';
import 'trig_circle_widget.dart';
import 'vector_2d_simulation_widget.dart';

/// Factory Pattern per l'istanziazione dinamica di widget interattivi (Server-Driven UI).
/// A seconda del [templateType] specificato nel database, restituisce il widget corrispondente.
class InteractiveTemplateFactory {
  /// Restituisce il widget interattivo corretto oppure null se il template non è riconosciuto.
  static Widget? buildWidget(InteractiveData? data) {
    if (data == null) {
      return null;
    }

    switch (data.templateType) {
      case 'vector_2d':
      case 'linear_combination':
      case 'vector_addition':
      case 'span_2d':
      case 'vector_simulation':
      case 'vector_span':
      case 'vector_space':
      case 'vettori_2d':
      case 'somma_vettoriale':
      case 'combinazione_lineare':
        return Vector2DSimulationWidget(data: data);
      case 'circuit_simulation':
      case 'ohm_simulation':
        return OhmCircuitSimulationWidget(data: data);
      case 'kinematics_simulation':
      case 'rectilinear_motion':
        return KinematicsSimulationWidget(data: data);
      case 'rolle_lagrange':
      case 'rolle':
      case 'lagrange':
        return RolleLagrangeWidget(data: data);
      case 'squeeze_theorem':
      case 'carabinieri_theorem':
      case 'teorema_carabinieri':
        return SqueezeTheoremWidget(data: data);
      case 'function_graph':
      case 'cartesian_plot':
        // Se la formula è la cubica dei teoremi di Rolle/Lagrange, usa il simulatore specifico
        if (data.equations != null &&
            data.equations!.any((eq) => eq.contains('x * x * x / 3') || eq.contains('rolle'))) {
          return RolleLagrangeWidget(data: data);
        }
        if (data.equations != null &&
            data.equations!.any((eq) => eq.contains('carabinieri') || eq.contains('squeeze'))) {
          return SqueezeTheoremWidget(data: data);
        }
        return CartesianGraphWidget(data: data);
      case 'trig_circle':
      case 'trigonometric_circle':
        return TrigCircleWidget(data: data);
      case 'triangle_solver':
      case 'pythagoras_carnot':
        return TriangleSolverWidget(data: data);
      case 'derivative_tangent':
      case 'difference_quotient':
        return DerivativeTangentWidget(data: data);
      case 'riemann_sum':
      case 'riemann_integral':
        return RiemannSumWidget(data: data);
      case 'completing_square':
      case 'quadratic_visual':
      case 'quadratic_proof':
      case 'dimostrazione_quadratica':
        return QuadraticVisualProofWidget(data: data);
      case 'live_equation':
        return LiveEquationWidget(data: data);
      default:
        // Se non specificato ma ha equazioni e parametri, fallback su live_equation
        if ((data.equations != null && data.equations!.isNotEmpty) ||
            (data.parameters != null && data.parameters!.isNotEmpty)) {
          return LiveEquationWidget(data: data);
        }
        return null;
    }
  }
}
