import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/text_styles.dart';
import '../../data/planter.dart';
import '../../data/planter_checkin.dart';
import '../../models/auth_model.dart';
import '../../utils/date_time_extension.dart';
import '../../utils/strings.dart';
import '../custom_card.dart';

class PlanterCalendar extends StatefulWidget {
  final String title;
  final Planter planter;

  const PlanterCalendar({
    Key key,
    @required this.planter,
    @required this.title,
  })  : assert(planter != null),
        assert(title != null),
        super(key: key);

  @override
  _PlanterCalendarState createState() => _PlanterCalendarState();
}

class _PlanterCalendarState extends State<PlanterCalendar> {
  final listKey = GlobalKey<AnimatedListState>();
  final List<PlanterCheckIn> _selectedMonthEvents = [];
  final List<PlanterCheckIn> _selectedDayEvents = [];
  Future<List<PlanterCheckIn>> _future;
  // used to determine which year/month should be currently in view
  DateTime _focusedDay = DateTime.now();
  // The actual selected day
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _updateEvents(_focusedDay);
    });
  }

  void _updateEvents(DateTime date) {
    final tokenData = context.read<AuthModel>().tokenData;
    setState(() {
      _future = context.read<Api>().fetchPlanterCheckIns(
          widget.planter.id, date.month, date.year, tokenData.accessToken);
    });
    _future.then((events) {
      setState(() {
        _selectedMonthEvents
          ..clear()
          ..addAll(events);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.title,
      padding: innerEdgeInsets,
      children: [
        TableCalendar(
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarStyle: const CalendarStyle(
            cellMargin: EdgeInsets.zero,
            isTodayHighlighted: false,
            markersAlignment: Alignment.center,
            markersMaxCount: 0,
          ),
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronMargin: EdgeInsets.zero,
            leftChevronPadding: EdgeInsets.zero,
            rightChevronMargin: EdgeInsets.zero,
            rightChevronPadding: EdgeInsets.zero,
          ),
          daysOfWeekHeight: 42,
          rowHeight: 42,
          daysOfWeekStyle: const DaysOfWeekStyle(weekendStyle: TextStyle()),
          availableGestures: AvailableGestures.horizontalSwipe,
          eventLoader: (date) => _selectedDayEvents,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _selectedDay = null;
            _selectedDayEvents.clear();
            _updateEvents(focusedDay);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDayEvents
                  ..clear()
                  ..addAll(_selectedMonthEvents.where(
                    (e) => selectedDay.isSameDay(e.date),
                  ));
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, focused) {
              return _selectedMonthEvents.any((e) => e.date.isSameDay(date))
                  ? dayWithEventBuilder(context, date)
                  : unselectedDayBuilder(context, date);
            },
            outsideBuilder: deactivatedDayBuilder,
            selectedBuilder: selectedDayBuilder,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<PlanterCheckIn>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return buildLoading();
            }
            if (snapshot.hasError) {
              return buildError(snapshot.error?.toString());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                key: ValueKey(_selectedDay),
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _selectedDayEvents.length,
                itemBuilder: (context, i) =>
                    buildEventTile(_selectedDayEvents[i]),
              );
            }
            // Should never get here
            return const Padding(
              padding: wrapEdgeInsets,
              child: Center(child: Text(Strings.genericError)),
            );
          },
        ),
      ],
    );
  }

  Widget buildEventTile(PlanterCheckIn event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: MainColors.lightGreen, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.activityTitle,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.dateFormatted,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
          const SizedBox(height: 2),
          if (event.comment != null && event.comment.isNotEmpty)
            Text(
              event.comment ?? Strings.noComments,
              style: shortDescriptionCaption(context),
            )
          else
            Text(
              Strings.noComments,
              style: shortDescriptionCaption(context),
            ),
        ],
      ),
    );
  }

  Widget buildLoading() => Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 30,
          height: 30,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );

  Widget buildError(String error) => Container(
        padding: wrapEdgeInsets,
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(error),
            const SizedBox(height: 12),
            OutlineButton.icon(
              onPressed: () {
                _updateEvents(_selectedDay ?? _focusedDay);
                // To show the loading
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text(Strings.retry),
            ),
          ],
        ),
      );

  Widget unselectedDayBuilder(BuildContext context, DateTime date) {
    return addTopBorder(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Text('${date.day}'),
      ),
    );
  }

  Widget selectedDayBuilder(
      BuildContext context, DateTime date, DateTime focused) {
    return addTopBorder(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MainColors.primary,
        ),
        margin: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Text('${date.day}', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget dayWithEventBuilder(BuildContext context, DateTime date) {
    return addTopBorder(
      child: Container(
        key: ValueKey('events_${date.month}_${date.day}'),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(BorderSide(width: 0.7)),
        ),
        margin: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Text('${date.day}'),
      ),
    );
  }

  Widget deactivatedDayBuilder(
      BuildContext context, DateTime date, DateTime focused) {
    return addTopBorder(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: const TextStyle(color: Color(0xFF9E9E9E)),
        ),
      ),
    );
  }

  Widget addTopBorder({Widget child}) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 0.5, color: MainColors.darkGrey)),
      ),
      child: child,
    );
  }
}
