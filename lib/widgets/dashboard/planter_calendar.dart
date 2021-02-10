import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wadi_green/models/auth_model.dart';

import '../../api/api.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/text_styles.dart';
import '../../data/planter.dart';
import '../../data/planter_checkin.dart';
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
  final _calendarController = CalendarController();
  final List<PlanterCheckIn> _selectedMonthEvents = [];
  final List<PlanterCheckIn> _selectedDayEvents = [];
  Future<List<PlanterCheckIn>> _future;

  @override
  void initState() {
    super.initState();
    final initialDate = DateTime.now();
    _updateEvents(initialDate.month, initialDate.year);
  }

  void _updateEvents(int month, int year) {
    final tokenData = context.read<AuthModel>().tokenData;
    _future = context
        .read<Api>()
        .fetchPlanterCheckIns(widget.planter.id, month, year, tokenData.accessToken);
    _future.then((events) {
      setState(() {
        _selectedMonthEvents
          ..clear()
          ..addAll(events);
        _selectedDayEvents.clear();
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.title,
      padding: innerEdgeInsets,
      children: [
        _StyledCalendar(
          controller: _calendarController,
          events: {
            for (final event in _selectedMonthEvents) event.date: [event],
          },
          onVisibleDaysChanged: (first, last, _) {
            // Guaranteed to be inside the visible month
            final date = first.add(const Duration(days: 12));
            _updateEvents(date.month, date.year);
            setState(() {});
          },
          onDaySelected: (day, _, __) {
            setState(() {
              _selectedDayEvents
                ..clear()
                ..addAll(_selectedMonthEvents.where(
                  (e) => day.isSameDay(e.date),
                ));
            });
          },
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
                key: ValueKey(_calendarController.selectedDay),
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
          Text(
            event.comment ?? Strings.noComments,
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
                _updateEvents(_calendarController.selectedDay.month,
                    _calendarController.selectedDay.year);
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              label: const Text(Strings.retry),
            ),
          ],
        ),
      );
}

/// The calendar and all the custom styles it has are extracted into a separate
/// widget to make it easier to change styling without worrying about breaking
/// the actual calendar logic
class _StyledCalendar extends StatelessWidget {
  final CalendarController controller;
  final Map<DateTime, List<dynamic>> events;
  final OnVisibleDaysChanged onVisibleDaysChanged;
  final OnDaySelected onDaySelected;

  const _StyledCalendar({
    Key key,
    @required this.controller,
    @required this.events,
    @required this.onVisibleDaysChanged,
    @required this.onDaySelected,
  })  : assert(controller != null),
        assert(events != null),
        assert(onVisibleDaysChanged != null),
        assert(onDaySelected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarController: controller,
      calendarStyle: const CalendarStyle(
        contentPadding: EdgeInsets.zero,
        highlightToday: false,
        markersAlignment: Alignment.center,
        markersMaxAmount: 0,
      ),
      headerStyle: const HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        headerPadding: EdgeInsets.only(bottom: 16),
        leftChevronMargin: EdgeInsets.zero,
        leftChevronPadding: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(weekendStyle: TextStyle()),
      availableGestures: AvailableGestures.horizontalSwipe,
      events: events,
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) => events != null
            ? dayWithEventBuilder(context, date, events)
            : unselectedDayBuilder(context, date, events),
        dowWeekdayBuilder: dayTitleBuilder,
        dowWeekendBuilder: dayTitleBuilder,
        outsideDayBuilder: deactivatedDayBuilder,
        outsideWeekendDayBuilder: deactivatedDayBuilder,
        outsideHolidayDayBuilder: deactivatedDayBuilder,
        selectedDayBuilder: selectedDayBuilder,
      ),
      onVisibleDaysChanged: onVisibleDaysChanged,
      onDaySelected: onDaySelected,
    );
  }

  Widget dayTitleBuilder(BuildContext context, String day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(child: Text(day)),
    );
  }

  Widget unselectedDayBuilder(
      BuildContext context, DateTime date, List events) {
    return addTopBorder(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        child: Text('${date.day}'),
      ),
    );
  }

  Widget selectedDayBuilder(BuildContext context, DateTime date, List events) {
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

  Widget dayWithEventBuilder(BuildContext context, DateTime date, List events) {
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
      BuildContext context, DateTime date, List events) {
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
