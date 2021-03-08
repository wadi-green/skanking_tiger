import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/colors.dart';
import '../core/constants.dart';
import '../core/text_styles.dart';
import '../data/plant.dart';
import '../data/planter_canvas.dart';
import '../models/auth_model.dart';
import '../utils/strings.dart';
import '../widgets/advanced_future_builder.dart';
import '../widgets/common.dart';
import '../widgets/custom_card.dart';
import '../widgets/wadi_scaffold.dart';

class PlantCanvasScreen extends StatefulWidget {
  static const route = '/plant-canvas';
  static const planterIdArg = 'planterId';

  final bool isMain;
  final String planterId;

  const PlantCanvasScreen({
    Key key,
    @required this.planterId,
    this.isMain = false,
  })  : assert(planterId != null),
        super(key: key);

  @override
  _PlantCanvasScreenState createState() => _PlantCanvasScreenState();
}

class _PlantCanvasScreenState extends State<PlantCanvasScreen> {
  Future<PlanterCanvas> _future;

  @override
  void initState() {
    super.initState();
    // TODO uncomment when plants are available
    // _future = context.read<Api>().fetchPlanterCanvas(widget.planterId);
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plants are coming soon. Stay tuned!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 24),
            Selector<AuthModel, String>(
              selector: (context, model) => model.user.id,
              builder: (context, currentUserId, child) {
                return currentUserId == widget.planterId
                    ? Text(
                        'Meanwhile, interact with more activities to slowly '
                        'build your plants',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    : const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  // TODO use this function as the body to restore plants
  Widget buildOriginalScreen() {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
        SliverToBoxAdapter(
          child: Padding(
            padding: hEdgeInsets,
            child: CustomCard(
              title: Strings.plants,
              padding: innerEdgeInsets,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 150),
                  child: AdvancedFutureBuilder<PlanterCanvas>(
                    future: _future,
                    builder: buildCanvas,
                    onRefresh: () => setState(() {
                      _future = context
                          .read<Api>()
                          .fetchPlanterCanvas(widget.planterId);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
      ],
    );
  }

  /// Usually a grid would be used for situations like this, but the items
  /// here don't all have the same size. A grid wouldn't work unless we had
  /// to force all children to have the same aspect ratio (thus having too much
  /// blank space when both children have only a one line description for
  /// example). Having a combination of rows/cols fits this scenario much better.
  Widget buildCanvas(PlanterCanvas canvas) {
    final rowsNb = (canvas.plants.length / 2).ceil();
    return Column(
      children: [
        for (var i = 0; i < rowsNb; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildPlantTile(canvas.plants[2 * i])),
              // Horizontal spacing
              const SizedBox(width: 12),
              Expanded(
                child: 2 * i + 1 < canvas.plants.length
                    ? buildPlantTile(canvas.plants[2 * i + 1])
                    : const SizedBox(),
              ),
            ],
          ),
          // Vertical spacing
          const SizedBox(height: 12),
        ]
      ],
    );
  }

  Widget buildPlantTile(Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: plant.image,
            placeholder: (_, __) => loadingImagePlaceholder,
          ),
        ),
        Row(
          children: [
            Expanded(child: Text(plant.name, style: boxCardItemTitle(context))),
            const SizedBox(width: 8),
            Text(
              '${plant.age}',
              style:
                  detailedTileValue(context).copyWith(color: MainColors.grey),
            ),
          ],
        ),
        Text(
          plant.description,
          style: shortDescriptionCaption(context),
        ),
      ],
    );
  }
}
