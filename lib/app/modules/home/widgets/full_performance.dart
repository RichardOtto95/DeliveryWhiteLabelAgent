import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_agent_white_label/app/core/models/time_model.dart';
import 'package:delivery_agent_white_label/app/modules/home/home_store.dart';

import 'package:delivery_agent_white_label/app/shared/utilities.dart';
import 'package:delivery_agent_white_label/app/shared/widgets/center_load_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FullPerformance extends StatefulWidget {
  const FullPerformance({Key? key}) : super(key: key);

  @override
  _FullPerformanceState createState() => _FullPerformanceState();
}

class _FullPerformanceState extends State<FullPerformance>
    with SingleTickerProviderStateMixin {
  final HomeStore store = Modular.get();
  PageController pageController = PageController();
  late TabController tabController;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      print('observer store filter: ${store.filterBool}');
      if (store.filterBool) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          store.filterBool = false;
          setState(() {});
        });
      }
      return WillPopScope(
        onWillPop: () async {
          print("inkwell overlay null ${store.filterOverlay == null}");
          if (store.filterisNotNull()) {
            // store.filterOverlay!.remove();
            store.removeOverlay = true;
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: getColors(context).background,
          body: Stack(
            children: [
              Earnings(),
              PerformanceAppBar(
                tabController: tabController,
                onTap: (pg) async => await pageController.animateToPage(pg,
                    duration: Duration(milliseconds: 300), curve: Curves.ease),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class PerformancStatistics extends StatefulWidget {
  PerformancStatistics({Key? key}) : super(key: key);

  @override
  _PerformancStatisticsState createState() => _PerformancStatisticsState();
}

class _PerformancStatisticsState extends State<PerformancStatistics> {
  final HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: wXD(104, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Goals(),
          OffensiveCalendar(),
          Statistics(),
          CartesianChart(),
        ],
      ),
    );
  }
}

class CartesianChart extends StatefulWidget {
  const CartesianChart({Key? key}) : super(key: key);

  @override
  _CartesianChartState createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      ChartData('CHN', 12),
      ChartData('GER', 15),
      ChartData('RUS', 30),
      ChartData('BRZ', 6.4),
      ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  List<String> weekDays = [
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb",
    "Dom",
  ];

  List<ChartData> takeLastWeek() {
    List<ChartData> chartDatas = [
      ChartData("Sáb", 0),
      ChartData("Dom", 300),
      ChartData("Seg", 250),
      ChartData("Ter", 500),
      ChartData("Qua", 70),
      ChartData("Qui", 237),
      ChartData("Sex", 600),
    ];

    // double score = 40;
    // for (int i = 6; i >= 0; i--) {
    //   DateTime aQeekAgo = DateTime.now().subtract(Duration(days: i));
    //   print("aQeekAgo $aQeekAgo");
    //   print("i: $i");
    //   chartDatas.add(ChartData(weekDays[aQeekAgo.weekday - 1], score));
    //   score += 70;
    // }
    return chartDatas;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(207, context),
        width: wXD(347, context),
        margin: EdgeInsets.symmetric(vertical: wXD(15, context)),
        decoration: BoxDecoration(
          border: Border.all(
              color: getColors(context).onBackground.withOpacity(.7)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: getColors(context).onSurface,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: wXD(11, context)),
              width: wXD(306, context),
              height: wXD(40, context),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: wXD(12, context),
                        width: wXD(12, context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getColors(context).primary,
                        ),
                      ),
                      Text(
                        " Você",
                        style: textFamily(
                          context,
                          color: getColors(context).primary,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "374 XP",
                    style: textFamily(
                      context,
                      color: getColors(context).primary,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: wXD(165, context),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // getColors(context).primaryYAxis: NumericAxis(minimum: 0, maximum: 800, interval: 200),
                tooltipBehavior: _tooltip,

                series: <ChartSeries>[
                  LineSeries<ChartData, String>(
                    dataSource: takeLastWeek(),
                    xValueMapper: (ChartData _data, __) => _data.x,
                    yValueMapper: (ChartData _data, __) => _data.y,
                    color: getColors(context).primary,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: getColors(context).primary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class Statistics extends StatelessWidget {
  Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(17, 20, 0, 18),
          child: Text(
            "Estatísticas",
            style: textFamily(
              context,
              fontSize: 17,
              color: getColors(context).onBackground,
            ),
          ),
        ),
        Container(
          width: maxWidth(context),
          height: wXD(120, context),
          padding: EdgeInsets.symmetric(horizontal: wXD(14, context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Statistic(
                    svgPath: "assets/svg/fire.svg",
                    data: "44",
                    description: "Dias de ofensiva",
                  ),
                  Statistic(
                    svgPath: "assets/svg/ray.svg",
                    data: "12517",
                    description: "Total de XP",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Statistic(
                    svgPath: "assets/svg/flag.svg",
                    data: "Pérola",
                    description: "Divisão",
                  ),
                  Statistic(
                    svgPath: "assets/svg/podium.svg",
                    data: "4",
                    description: "Pódios",
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Statistic extends StatelessWidget {
  final String svgPath;
  final String data;
  final String description;
  Statistic({
    Key? key,
    required this.svgPath,
    this.data = "Sem dados",
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(56, context),
      width: wXD(162, context),
      padding: EdgeInsets.fromLTRB(10, 11, 10, 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border:
            Border.all(color: getColors(context).onBackground.withOpacity(.7)),
        color: getColors(context).onSurface,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgPath,
            semanticsLabel: 'Acme Logo',
            height: wXD(15, context),
            width: wXD(10, context),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          SizedBox(width: wXD(7, context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: wXD(2, context)),
              Text(
                data,
                style: textFamily(
                  context,
                  fontWeight: FontWeight.w600,
                  color: getColors(context).onBackground,
                ),
              ),
              SizedBox(height: wXD(3, context)),
              Text(
                description,
                style: textFamily(
                  context,
                  color: getColors(context).onBackground.withOpacity(.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OffensiveCalendar extends StatefulWidget {
  const OffensiveCalendar({Key? key}) : super(key: key);

  @override
  _OffensiveCalendarState createState() => _OffensiveCalendarState();
}

class _OffensiveCalendarState extends State<OffensiveCalendar> {
  final HomeStore store = Modular.get();
  TextStyle calTextStyle({Color? color}) => textFamily(context, color: color);
  final rangePickerController = DateRangePickerController();

  @override
  void initState() {
    rangePickerController.displayDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    rangePickerController.dispose();
    super.dispose();
  }

  List<String> weekDays = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
  ];
  @override
  Widget build(BuildContext context) {
    String month = DateFormat(
      "MMMM",
    ).format(rangePickerController.displayDate!);
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: wXD(294, context),
            width: wXD(342, context),
            decoration: BoxDecoration(
              color: getColors(context).onSurface,
              border: Border.all(color: Color(0xfff1f1f1)),
              borderRadius: BorderRadius.all(Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 3),
                  color: getColors(context).onBackground.withOpacity(.1),
                )
              ],
            ),
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(),
                  width: wXD(274, context),
                  height: wXD(280, context),
                  child: getSfCalendar(),
                ),
                Container(
                  width: wXD(274, context),
                  height: wXD(260, context),
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
          Positioned(
            top: wXD(20, context),
            child: Container(
              height: wXD(50, context),
              width: wXD(306, context),
              padding: EdgeInsets.only(bottom: wXD(6, context)),
              color: getColors(context).onSurface,
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () =>
                            setState(() => rangePickerController.backward!()),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: wXD(15, context),
                          color: getColors(context).onBackground,
                        ),
                      ),
                      Text(
                        month.substring(0, 1).toUpperCase() +
                            month.substring(1) +
                            " de " +
                            rangePickerController.displayDate!.year.toString(),
                        style: textFamily(context,
                            color: getColors(context).onBackground),
                      ),
                      InkWell(
                        onTap: () =>
                            setState(() => rangePickerController.forward!()),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: wXD(15, context),
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(children: [
                    SizedBox(width: wXD(16, context)),
                    ...List.generate(
                      7,
                      (index) {
                        print(
                            "index: $index, weekDay: ${DateTime(2021, 11, 14).weekday}");
                        bool isToday = (index + 7 == DateTime.now().weekday ||
                                index == DateTime.now().weekday) &&
                            DateTime.now().toString().substring(0, 7) ==
                                rangePickerController.displayDate
                                    .toString()
                                    .substring(0, 7);
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              weekDays[index],
                              style: textFamily(context,
                                  color: isToday
                                      ? getColors(context).primary
                                      : null),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: wXD(16, context)),
                  ]

                      //     weekDays.map((weekDay) {
                      //   bool thisWeek = weekDay = DateTime.now().w
                      //   return Expanded(
                      //     child: Container(
                      //       alignment: Alignment.center,
                      //       child: Text(
                      //         weekDay,
                      //         style: textFamily(context,),
                      //       ),
                      //     ),
                      //   );
                      // }).toList()
                      ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getSfCalendar() {
    return SfDateRangePicker(
      initialSelectedDates: [
        DateTime(2021, 11, 5),
        DateTime(2021, 11, 8),
      ],
      controller: rangePickerController,
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.multiRange,
      initialSelectedRanges: [
        PickerDateRange(DateTime(2021, 11, 2), DateTime.now()),
      ],
      startRangeSelectionColor: getColors(context).primary,
      endRangeSelectionColor: getColors(context).primary,
      rangeSelectionColor: Color(0xffFFCA7C),
      rangeTextStyle: calTextStyle(color: getColors(context).primary),
      monthViewSettings: DateRangePickerMonthViewSettings(
        enableSwipeSelection: false,
      ),
      selectionTextStyle: calTextStyle(color: getColors(context).onSurface),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: calTextStyle(),
        todayTextStyle: calTextStyle(),
        todayCellDecoration: BoxDecoration(
          color: Color(0xffA9A9A9),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Goals extends StatelessWidget {
  Goals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin:
            EdgeInsets.only(top: wXD(11, context), bottom: wXD(17, context)),
        height: wXD(58, context),
        width: wXD(302, context),
        decoration: BoxDecoration(
          color: getColors(context).onSurface,
          border: Border.all(
              color: getColors(context).onBackground.withOpacity(.7),
              width: wXD(1, context)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: wXD(135, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_sharp,
                        size: wXD(22, context),
                      ),
                      Text(
                        "15 dias",
                        style: textFamily(
                          context,
                          fontSize: 15,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Ofensiva atual",
                    style: textFamily(
                      context,
                      fontSize: 15,
                      color: getColors(context).onBackground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: wXD(58, context),
              width: wXD(1, context),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: getColors(context).onBackground.withOpacity(.7))),
            ),
            SizedBox(
              width: wXD(135, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cases_outlined,
                        size: wXD(22, context),
                      ),
                      Text(
                        " 0 / 50 XP",
                        style: textFamily(
                          context,
                          fontSize: 15,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Meta diária",
                    style: textFamily(
                      context,
                      fontSize: 15,
                      color: getColors(context).onBackground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Earnings extends StatelessWidget {
  final HomeStore store = Modular.get();
  Earnings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        store.filterBool = true;
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: wXD(120, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GainFilterDate(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                wXD(24, context),
                wXD(14, context),
                wXD(0, context),
                wXD(15, context),
              ),
              child: Text(
                "Seus ganhos",
                style: textFamily(
                  context,
                  fontSize: 13,
                  color: getColors(context).onBackground,
                ),
              ),
            ),
            Center(
              child: Container(
                // height: wXD(278, context),
                width: wXD(342, context),
                margin: EdgeInsets.only(bottom: wXD(20, context)),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: getColors(context).primary.withOpacity(.40)),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: getColors(context).surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: getColors(context).shadow,
                    ),
                  ],
                ),
                child: FutureBuilder<Map>(
                    future: store.getConcludedOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      if (!snapshot.hasData) {
                        return CenterLoadCircular();
                      }
                      QuerySnapshot ordersQuery = snapshot.data!['query'];
                      num totalGain = snapshot.data!['total_gain'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              wXD(12, context),
                              wXD(14, context),
                              0,
                              wXD(15, context),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ganhos totais",
                                  style: textFamily(
                                    context,
                                    fontSize: 13,
                                    color: getColors(context).onBackground,
                                  ),
                                ),
                                SizedBox(height: wXD(7, context)),
                                Text(
                                  formatedCurrency(totalGain),
                                  style: textFamily(
                                    context,
                                    fontSize: 17,
                                    color: getColors(context).primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: wXD(38, context),
                            width: wXD(342, context),
                            color: getColors(context).primary.withOpacity(.2),
                            padding: EdgeInsets.symmetric(
                                horizontal: wXD(15, context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Data e hora",
                                  style: textFamily(context,
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.7),
                                      fontSize: 10),
                                ),
                                Container(
                                  width: wXD(60, context),
                                  child: Text(
                                    "R\$ ",
                                    style: textFamily(context,
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.7),
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ordersQuery.docs.isEmpty
                              ? const EarningEmptyState()
                              : Column(
                                  children: ordersQuery.docs
                                      .map((DocumentSnapshot orderDoc) {
                                    return Earning(
                                      date: orderDoc["created_at"].toDate(),
                                      price: orderDoc["price_rate_delivery"],
                                    );
                                  }).toList(),
                                ),
                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Earning extends StatelessWidget {
  final DateTime date;
  final num price;

  Earning({
    Key? key,
    required this.date,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimeModel time = TimeModel();
    return Container(
      height: wXD(43, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(left: wXD(16, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: wXD(90, context),
            child: Text(
                "${time.date(Timestamp.fromDate(date)).substring(0, 5)} - ${time.hour(Timestamp.fromDate(date))}",
                style: textFamily(
                  context,
                  fontSize: 12,
                  color: getColors(context).onBackground.withOpacity(.7),
                )),
          ),
          Text(
            "-",
            style: textFamily(
              context,
              fontSize: 12,
              color: getColors(context).onBackground.withOpacity(.7),
            ),
          ),
          Container(
            width: wXD(90, context),
            padding: EdgeInsets.only(left: wXD(15, context)),
            child: Text(
              formatedCurrency(price),
              style: textFamily(
                context,
                fontSize: 12,
                color: getColors(context).onBackground.withOpacity(.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EarningEmptyState extends StatelessWidget {
  const EarningEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(342, context),
      height: wXD(165, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            "./assets/svg/clipboards.svg",
            height: wXD(85, context),
            width: wXD(87, context),
          ),
          Text("Sem dados",
              style: textFamily(context, color: getColors(context).primary)),
          Text(
            "A lista de todas as corridas que realizou estarão disponíveis\naqui. Fique online para receber ofertas!",
            textAlign: TextAlign.center,
            style: textFamily(
              context,
              fontSize: 10,
              color: getColors(context).onBackground.withOpacity(.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// class GainFilterDate extends StatefulWidget {
//   GainFilterDate({Key? key}) : super(key: key);

//   @override
//   _GainFilterDateState createState() => _GainFilterDateState();
// }

class GainFilterDate extends StatelessWidget {
  final HomeStore store = Modular.get();

  OverlayEntry getFilterOverlay() {
    double opacity = 0;
    double sigma = 0;
    double right = -270;
    bool backing = false;
    // DateTime? initialDate;
    // DateTime? endDate;

    Widget getCheckPeriod(String title, int index) {
      return Observer(builder: (context) {
        return GestureDetector(
          onTap: () => store.filterAltered(index),
          child: Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: wXD(16, context), top: wXD(15, context)),
                  height: wXD(16, context),
                  width: wXD(16, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: getColors(context).primary),
                    color: getColors(context).surface,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    height: wXD(10, context),
                    width: wXD(10, context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: store.filterIndex == index
                          ? getColors(context).primary
                          : Colors.transparent,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: textFamily(context,
                      fontSize: 12,
                      color: getColors(context).onBackground.withOpacity(.7)),
                ),
              ],
            ),
          ),
        );
      });
    }

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          height: maxHeight(context),
          width: maxWidth(context),
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, stateSet) {
                if (!backing) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    stateSet(() {
                      opacity = .51;
                      sigma = 3;
                      right = 0;
                    });
                  });
                }
                return Stack(
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        backing = true;
                        stateSet(() {
                          opacity = 0;
                          sigma = 0;
                          right = -270;
                          Future.delayed(
                            Duration(milliseconds: 400),
                            () {
                              store.filterOverlay!.remove();
                              store.filterOverlay = null;
                              // store.filterIndex = store.previousFilterIndex;
                              store.filterAltered(store.previousFilterIndex);
                              print(
                                  "inkwell overlay null ${store.filterOverlay == null}");
                            },
                          );
                        });
                      },
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            getColors(context).shadow,
                            BlendMode.color,
                          ),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.ease,
                            opacity: opacity,
                            child: Container(
                              color: getColors(context).shadow,
                              height: maxHeight(context),
                              width: maxWidth(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                      right: right,
                      child: Container(
                        height: maxHeight(context),
                        width: wXD(260, context),
                        decoration: BoxDecoration(
                          color: getColors(context).surface,
                          borderRadius:
                              BorderRadius.horizontal(left: Radius.circular(3)),
                        ),
                        padding: EdgeInsets.fromLTRB(
                          wXD(11, context),
                          wXD(34, context),
                          wXD(8, context),
                          wXD(0, context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    backing = true;
                                    stateSet(() {
                                      opacity = 0;
                                      sigma = 0;
                                      right = -270;
                                      Future.delayed(
                                        Duration(milliseconds: 400),
                                        () {
                                          store.filterOverlay!.remove();
                                          store.filterOverlay = null;
                                          // store.filterAltered(0);
                                          store.filterAltered(
                                              store.previousFilterIndex);
                                        },
                                      );
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: wXD(20, context),
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.7),
                                  ),
                                ),
                                Spacer(flex: 3),
                                InkWell(
                                  onTap: () {
                                    stateSet(() {
                                      store.filterAltered(0);
                                      // initialDate = null;
                                      // endDate = null;
                                    });
                                  },
                                  child: Container(
                                    height: wXD(30, context),
                                    width: wXD(60, context),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Limpar",
                                      style: textFamily(
                                        context,
                                        color: getColors(context)
                                            .onBackground
                                            .withOpacity(.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    store.filter();
                                    backing = true;
                                    // store.isEmpty = !store.isEmpty;
                                    stateSet(() {
                                      opacity = 0;
                                      sigma = 0;
                                      right = -270;
                                      Future.delayed(
                                        Duration(milliseconds: 400),
                                        () {
                                          store.filterOverlay!.remove();
                                          store.filterOverlay = null;
                                          store.filterBool = true;
                                        },
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: wXD(30, context),
                                    width: wXD(50, context),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Filtrar",
                                      style: textFamily(
                                        context,
                                        color: getColors(context).primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: wXD(9, context)),
                              width: wXD(241, context),
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.7)
                                  .withOpacity(.2),
                              height: wXD(.5, context),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  wXD(10, context),
                                  wXD(13, context),
                                  wXD(0, context),
                                  wXD(20, context)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Período",
                                    style: textFamily(
                                      context,
                                      color: getColors(context).primary,
                                    ),
                                  ),
                                  getCheckPeriod("Hoje", 0),
                                  getCheckPeriod("Ontem", 1),
                                  getCheckPeriod("1ª quinzena do mês", 2),
                                  getCheckPeriod("2ª quinzena do mês", 3),
                                  getCheckPeriod("Mês passado", 4),
                                  SizedBox(height: wXD(20, context)),
                                  Text(
                                    "Período específico",
                                    style: textFamily(
                                      context,
                                      color: getColors(context).primary,
                                    ),
                                  ),
                                  SizedBox(height: wXD(15, context)),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (store.filterIndex != 5) {
                                            store.previousFilterIndex =
                                                store.filterIndex;
                                            store.filterIndex = 5;
                                          }
                                          pickDate(context, onConfirm: (date) {
                                            print("date: $date");
                                            if (date != null) {
                                              if (store.endDate != null) {
                                                if (date
                                                    .isAfter(store.endDate!)) {
                                                  showToast(
                                                      "A data inicial não pode ser depois da final");
                                                } else {
                                                  store.startDate = date;
                                                }
                                              } else {
                                                store.startDate = date;
                                              }
                                            } else {
                                              store.filterIndex =
                                                  store.previousFilterIndex;
                                            }
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: wXD(4, context)),
                                              height: wXD(29, context),
                                              width: wXD(76, context),
                                              decoration: BoxDecoration(
                                                color: getColors(context)
                                                    .background,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Data inicial",
                                                style: textFamily(
                                                  context,
                                                  fontSize: 10,
                                                  color: getColors(context)
                                                      .onBackground
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              TimeModel().date(
                                                store.startDate == null
                                                    ? null
                                                    : Timestamp.fromDate(
                                                        store.startDate!,
                                                      ),
                                              ),
                                              style: textFamily(
                                                context,
                                                fontSize: 10,
                                                color: getColors(context)
                                                    .onBackground
                                                    .withOpacity(.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: wXD(10, context)),
                                      GestureDetector(
                                        onTap: () async {
                                          if (store.filterIndex != 5) {
                                            store.previousFilterIndex =
                                                store.filterIndex;
                                            store.filterIndex = 5;
                                          }
                                          pickDate(context, onConfirm: (date) {
                                            print("date: $date");
                                            if (date != null) {
                                              if (store.startDate != null) {
                                                if (date.isBefore(
                                                    store.startDate!)) {
                                                  showToast(
                                                      "A data final não pode ser antes da inicial");
                                                } else {
                                                  store.endDate = date;
                                                }
                                              } else {
                                                store.endDate = date;
                                              }
                                            } else {
                                              store.filterIndex =
                                                  store.previousFilterIndex;
                                            }
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: wXD(29, context),
                                              width: wXD(76, context),
                                              margin: EdgeInsets.only(
                                                  bottom: wXD(4, context)),
                                              decoration: BoxDecoration(
                                                color: getColors(context)
                                                    .background,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Data final",
                                                style: textFamily(
                                                  context,
                                                  fontSize: 10,
                                                  color: getColors(context)
                                                      .onBackground
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              TimeModel().date(
                                                store.endDate == null
                                                    ? null
                                                    : Timestamp.fromDate(
                                                        store.endDate!,
                                                      ),
                                              ),
                                              style: textFamily(
                                                context,
                                                fontSize: 10,
                                                color: getColors(context)
                                                    .onBackground
                                                    .withOpacity(.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: wXD(241, context),
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.7)
                                  .withOpacity(.2),
                              height: wXD(.5, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        if (store.removeOverlay) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            stateSet(() {
                              backing = true;
                              store.removeOverlay = false;
                              opacity = 0;
                              sigma = 0;
                              right = -270;
                              Future.delayed(
                                Duration(milliseconds: 400),
                                () {
                                  store.filterOverlay!.remove();
                                  store.filterOverlay = null;
                                },
                              );
                            });
                          });
                        }
                        return Container();
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(42, context),
        width: wXD(343, context),
        padding: EdgeInsets.symmetric(horizontal: wXD(13, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: getColors(context).primary.withOpacity(.7),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 3,
          //     offset: Offset(0, 3),
          //     color: getColors(context).onBackground.withOpacity(.2),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            Text(
              // "Hoje - 22/10/2021",
              getText(store.filterIndex),
              style: textFamily(
                context,
                fontSize: 14,
                color: getColors(context).onPrimary,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                store.insertOverlay(context, getFilterOverlay());
                // store.filterOverlay = getFilterOverlay();
                // Overlay.of(context)!.insert(store.filterOverlay);
              },
              child: Container(
                alignment: Alignment.center,
                height: wXD(40, context),
                width: wXD(50, context),
                child: Text(
                  "Filtros",
                  style: textFamily(
                    context,
                    fontSize: 10,
                    color: getColors(context).onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getText(int index) {
    switch (index) {
      case 0:
        String date = store.nowDate.day.toString().padLeft(2, '0') +
            '/' +
            store.nowDate.month.toString().padLeft(2, '0') +
            '/' +
            store.nowDate.year.toString();
        return 'Hoje - ' + date;

      case 1:
        String date = store.yesterdayDate!.day.toString().padLeft(2, '0') +
            '/' +
            store.yesterdayDate!.month.toString().padLeft(2, '0') +
            '/' +
            store.yesterdayDate!.year.toString();
        return 'Ontem - ' + date;

      case 2:
        return '1º quinzena do mês';

      case 3:
        return '2º quinzena do mês';

      case 4:
        return 'Mês passado';

      case 5:
        String date = store.startDate!.day.toString().padLeft(2, '0') +
            '/' +
            store.startDate!.month.toString().padLeft(2, '0') +
            '/' +
            store.startDate!.year.toString();

        date += " até ";
        date += store.endDate!.day.toString().padLeft(2, '0') +
            '/' +
            store.endDate!.month.toString().padLeft(2, '0') +
            '/' +
            store.endDate!.year.toString();

        return date;

      default:
        return '';
    }
  }
}

class PerformanceAppBar extends StatelessWidget {
  final void Function(int) onTap;
  final TabController tabController;

  const PerformanceAppBar(
      {Key? key, required this.onTap, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Stack(
        children: [
          Container(
            // height: wXD(104, context),
            height: viewPaddingTop(context) + wXD(50, context),
            padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
            width: maxWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3)),
              color: getColors(context).surface,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: Color(0x30000000),
                ),
              ],
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Desempenho completo',
                  style: textFamily(
                    context,
                    fontSize: 20,
                    color: getColors(context).primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: wXD(10, context)),
                // DefaultTabController(
                //   length: 2,
                //   child: TabBar(
                //     onTap: onTap,
                //     controller: tabController,
                //     indicatorColor: getColors(context).primary,
                //     indicatorSize: TabBarIndicatorSize.label,
                //     labelPadding: EdgeInsets.symmetric(vertical: 8),
                //     labelColor: getColors(context).primary,
                //     labelStyle: textFamily(context,fontWeight: FontWeight.w400),
                //     unselectedLabelColor: getColors(context).onBackground.withOpacity(.9),
                //     indicatorWeight: 3,
                //     tabs: [
                //       Text('Estatísticas'),
                //       Text('Ganhos'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            left: wXD(10, context),
            bottom: wXD(10, context),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back,
                  color: getColors(context).onBackground.withOpacity(.9),
                  size: wXD(25, context)),
            ),
          )
        ],
      ),
    );
  }
}
