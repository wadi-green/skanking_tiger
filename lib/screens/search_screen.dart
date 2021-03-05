import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../core/constants.dart';
import '../data/route_arguments.dart';
import '../data/search_results.dart';
import '../screens/all_activities_screen.dart';
import '../utils/strings.dart';
import '../widgets/activities/compact_activities_list.dart';
import '../widgets/activity_categories.dart';
import '../widgets/common.dart';
import '../widgets/search/hashtags_widget.dart';
import '../widgets/search/search_box.dart';
import '../widgets/wadi_scaffold.dart';
import 'most_liked_activities_screen.dart';

class SearchScreen extends StatefulWidget {
  static const route = '/search';
  static const queryArg = 'query';
  final bool isMain;
  final String query;

  const SearchScreen({Key key, this.isMain = false, @required this.query})
      : assert(query != null),
        super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<SearchResults> _future;
  String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _future = context.read<Api>().searchActivities(keyword: _query);
  }

  @override
  Widget build(BuildContext context) {
    return WadiScaffold(
      hasDrawer: widget.isMain,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: vPadding)),
          SliverToBoxAdapter(
            child: Padding(
              padding: hEdgeInsets,
              child: SearchBox(
                // The key forces the search box to re-render when the query changes
                key: ValueKey<String>(_query ?? 'EmptyQuery'),
                initialQuery: _query,
                onSubmit: (query) {
                  // Any time the query is changed, we resubmit a new request
                  // to the api
                  setState(() {
                    _query = query;
                    _future = _future = context
                        .read<Api>()
                        .searchActivities(keyword: query, limit: 10);
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: cardsSpacer),
          SliverPadding(
            padding: hEdgeInsets,
            sliver: FutureBuilder<SearchResults>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: buildLoading(),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: buildError(snapshot.error?.toString()),
                  );
                }

                if (snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: buildResults(snapshot.data, _query),
                  );
                }

                // Should never get here
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text(Strings.genericError)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void resetSearch(String newQuery) {
    setState(() {
      _query = newQuery;
      _future =
          _future = context.read<Api>().searchActivities(keyword: newQuery);
    });
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  Widget buildError(String error) => Padding(
        padding: wrapEdgeInsets,
        child: Center(child: Text(error ?? Strings.searchError)),
      );

  Widget buildResults(SearchResults results, String q) => Column(
        children: [
          CompactActivitiesList(
            title: Strings.activitiesList,
            subtitle: 'Showing ${results.results.length} activities '
                'of ${results.totalResults} for $_query',
            activities: results.results,
            callback: () => Navigator.of(context).pushNamed(
                AllActivitiesScreen.route,
                arguments: RouteArguments(data: {SearchScreen.queryArg: q})),
          ),
          cardsSpacer,
          if ((results.hashtags?.related ?? []).isNotEmpty) ...[
            HashtagsWidget(
              title: Strings.relatedHashtags,
              hashtags: results.hashtags?.related ?? [],
              onPressed: resetSearch,
            ),
            cardsSpacer,
          ],
          if (results.categories.isNotEmpty) ...[
            ActivityCategories(
              title: Strings.activityCategories,
              categories: results.categories,
              onPressed: resetSearch,
            ),
            cardsSpacer,
          ],
          if (results.mostLikedActivities.isNotEmpty) ...[
            CompactActivitiesList(
              title: Strings.mostLikedActivities,
              activities: results.mostLikedActivities,
              callback: () => Navigator.of(context).pushNamed(
                  MostLikedActivitiesScreen.route,
                  arguments: const RouteArguments(data: {'limit': 50})),
            ),
            cardsSpacer,
          ],
          HashtagsWidget(
            title: Strings.popularHashtags,
            hashtags: results.hashtags?.popular ?? [],
            onPressed: resetSearch,
          ),
          const SizedBox(height: vPadding),
        ],
      );
}
