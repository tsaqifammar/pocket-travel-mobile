import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/plan.dart';
import 'package:timelines/timelines.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({Key? key, required this.planData}) : super(key: key);

  final Plan planData;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0.2,
              connectorTheme: const ConnectorThemeData(
                thickness: 3.0,
                color: Colors.grey
              ),
              indicatorTheme: const IndicatorThemeData(
                size: 10.0,
                color: Colors.black,
              ),
            ),
            builder: TimelineTileBuilder.connectedFromStyle(
              firstConnectorStyle: ConnectorStyle.transparent,
              lastConnectorStyle: ConnectorStyle.transparent,
              connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: widget.planData.schedule.length,
              oppositeContentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.planData.schedule[index].time),
              ),
              contentsBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.planData.schedule[index].activity),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
