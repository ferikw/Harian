import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/models/agenda_model.dart';
import 'package:harian/presentasion/controllers/all_agenda/agenda_selected_controller.dart';
import 'package:harian/presentasion/controllers/all_agenda/all_agenda_controller.dart';
import 'package:harian/presentasion/pages/agenda/add_agenda_page.dart';
import 'package:harian/presentasion/pages/agenda/detail_agenda_page.dart';
import 'package:harian/presentasion/widgets/response_failed.dart';

class AllAgendaPage extends StatefulWidget {
  const AllAgendaPage({super.key});

  static const routeName = '/all-agenda';

  @override
  State<AllAgendaPage> createState() => _AllAgendaPageState();
}

class _AllAgendaPageState extends State<AllAgendaPage> {
  final allAgendaController = Get.put(AllAgendaController());
  final agendaSelectedController = Get.put(AgendaSelectedController());

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      allAgendaController.fetchData(userId);
    });
  }

  void gotoAddAgenda() {
    Navigator.pushNamed(context, AddAgendaPage.routeName);
  }

  void gotoDetailAgenda(int id) {
    Navigator.pushNamed(
      context,
      DetailAgendaPage.routeName,
      arguments: id,
    ).then(
      (value) {
        if (value == null) return;
        if (value == 'refresh_agenda') {
          agendaSelectedController.reset();
          refresh();
        }
      },
    );
  }

  void selectAgenda(AgendaModel agenda) {
    agendaSelectedController.state = agenda;
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    AllAgendaController.delete();
    AgendaSelectedController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          const Gap(15),
          buildText1(),
          const Gap(15),
          buildAgendaSelected(),
          const Gap(15),
          buildText2(),
          const Gap(1),
          Expanded(
            child: buildWeekView(),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Semua Agenda Kamu",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Atur Kegiatan Harianmu Disini",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.textTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: FloatingActionButton(
                    onPressed: gotoAddAgenda,
                    heroTag: 'add-solution-btn',
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    child: Image.asset(
                      'assets/icons/jadwal.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildText1() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Agenda Kamu",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ],
        ));
  }

  Widget buildText2() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Timeline",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ],
        ));
  }

  Widget buildAgendaSelected() {
    return Obx(() {
      final agendaSelected = agendaSelectedController.state;
      int id = agendaSelected.id;
      return GestureDetector(
        onTap: id == 0 ? null : () => gotoDetailAgenda(id),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  agendaSelected.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                ),
              ),
              const ImageIcon(
                AssetImage('assets/icons/arrow_right.png'),
                size: 24,
                color: AppColor.primary,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildWeekView() {
    return Obx(
      () {
        final state = allAgendaController.state;
        final statusRequest = state.statusRequest;
        if (statusRequest == StatusRequest.init) {
          return const SizedBox();
        }
        if (statusRequest == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (statusRequest == StatusRequest.failed) {
          return ResponseFailed(
            message: state.message,
            margin: const EdgeInsets.all(20),
          );
        }
        final list = state.list;
        if (list.isEmpty) {
          return const ResponseFailed(
            message: 'No Agenda Yet',
            margin: EdgeInsets.all(20),
          );
        }
        return WeekView(
          controller: EventController()..addAll(list),
          weekPageHeaderBuilder: (startDate, endDate) {
            return buildWeekHeader(startDate, endDate);
          },
          eventTileBuilder:
              (date, events, boundary, startDuration, endDuration) {
            return buildEventTile(events.first);
          },
          showLiveTimeLineInAllDays: true,
          width: MediaQuery.sizeOf(context).width,
          minDay: DateTime(2024),
          maxDay: DateTime(DateTime.now().year + 1, DateTime.now().month),
          initialDay: DateTime.now(),
          startDay: WeekDays.sunday,
          showVerticalLines: false,
          backgroundColor: Colors.transparent,
          heightPerMinute: 1,
          eventArranger: const SideEventArranger(),
          keepScrollOffset: true,
          onEventTap: (events, date) {
            selectAgenda(events.first.event as AgendaModel);
          },
          fullDayHeaderTitle: 'Full Day',
        );
      },
    );
  }

  Widget buildWeekHeader(DateTime startDate, DateTime endDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: [
          Text(
            DateFormat('MMM d, yyyy').format(startDate),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColor.textTitle,
            ),
          ),
          const Gap(20),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.primary,
              ),
            ),
          ),
          const Gap(20),
          Text(
            DateFormat('MMM d, yyyy').format(endDate),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColor.textTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventTile(CalendarEventData event) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [event.startTime, event.endTime].map(
          (e) {
            return Text(
              DateFormat("HH:mm").format(e!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
