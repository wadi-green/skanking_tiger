import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';
import 'plant_canvas_screen.dart';

/// Wrapper around the [PlantCanvasScreen] that provides the currently
/// authenticated user id as the planter id to display
class PersonalPlantScreen extends StatelessWidget {
  static const route = '/personal-plant';
  final bool isMain;

  const PersonalPlantScreen({Key key, this.isMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AuthModel, String>(
      selector: (context, model) => model.user.id,
      builder: (context, currentUserId, child) => PlantCanvasScreen(
        isMain: isMain,
        planterId: currentUserId,
      ),
    );
  }
}
