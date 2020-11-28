import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../utils/strings.dart';

/// Custom [FutureBuilder] that handles the common cases of error and loading
/// states. The only thing we need is the builder function so that it displays
/// the proper results and a callback.
class AdvancedFutureBuilder<T> extends StatelessWidget {
  /// The asynchronous computation to which this builder is currently connected
  final Future<T> future;

  /// The builder responsible for displaying the results data
  final Widget Function(T result) builder;

  /// The function called in case there's an error and we want to refresh the result
  final VoidCallback onRefresh;

  /// Optional error message to display when the [Future] has an error
  final String error;

  const AdvancedFutureBuilder({
    Key key,
    @required this.future,
    @required this.builder,
    @required this.onRefresh,
    this.error = Strings.genericError,
  })  : assert(future != null),
        assert(builder != null),
        assert(onRefresh != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return buildLoading();
        }
        if (snapshot.hasError) {
          return buildError(snapshot.error?.toString());
        }
        if (snapshot.hasData) {
          return builder(snapshot.data);
        }
        // Should never get here
        return const Padding(
          padding: wrapEdgeInsets,
          child: Center(child: Text(Strings.genericError)),
        );
      },
    );
  }

  Widget buildLoading() => Container(
        padding: wrapEdgeInsets,
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 120),
        child: const CircularProgressIndicator(),
      );

  Widget buildError(String error) => Container(
        padding: wrapEdgeInsets,
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 120),
        child: Column(
          children: [
            Text(error ?? this.error),
            if (onRefresh != null) ...[
              const SizedBox(height: 12),
              OutlineButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text(Strings.retry),
              ),
            ]
          ],
        ),
      );
}
