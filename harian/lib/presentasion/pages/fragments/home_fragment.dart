import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/models/agenda_model.dart';
import 'package:harian/data/models/mood_model.dart';
import 'package:harian/data/models/user_model.dart';
import 'package:harian/presentasion/controllers/home/agenda_today_controller.dart';
import 'package:harian/presentasion/controllers/home/mood_today_controller.dart';
import 'package:harian/presentasion/pages/account_page.dart';
import 'package:harian/presentasion/pages/agenda/all_agenda_page.dart';
import 'package:harian/presentasion/pages/agenda/detail_agenda_page.dart';
import 'package:harian/presentasion/pages/chat_ai_page.dart';
import 'package:harian/presentasion/pages/mood/choose_mood_page.dart';
import 'package:harian/presentasion/widgets/response_failed.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final moodTodayController = Get.put(MoodTodayController());
  final agendaTodayController = Get.put(AgendaTodayController());

  refresh() async {
    final user = await Session.getUser();
    int userId = user!.id;
    moodTodayController.fetchData(userId);
    agendaTodayController.fetchData(userId);
  }

  refreshAgenda() {
    Session.getUser().then((user) {
      int userId = user!.id;
      agendaTodayController.fetchData(userId);
    });
  }

  void gotoChatAI() {
    Navigator.pushNamed(context, ChatAIPage.routeName);
  }

  void gotoAccount() {
    Navigator.pushNamed(context, AccountPage.routeName);
  }

  void gotoChooseMood() {
    Navigator.pushNamed(context, ChooseMoodPage.routeName);
  }

  void gotoAllAgenda() {
    Navigator.pushNamed(context, AllAgendaPage.routeName);
  }

  void gotoDetailAgenda(int id) {
    Navigator.pushNamed(
      context,
      DetailAgendaPage.routeName,
      arguments: id,
    ).then(
      (value) {
        if (value == null) return;
        if (value == 'refresh_agenda') refreshAgenda();
      },
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    MoodTodayController.delete();
    AgendaTodayController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => refresh(),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          buildHeader(),
          const Gap(36),
          buildYourMoodToday(),
          const Gap(36),
          buildKonsultasi(),
          const Gap(36),
          buildYourAgendaToday(),
          const Gap(140),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dashboard.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(55),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildProfile(),
              IconButton.filled(
                onPressed: gotoChatAI,
                constraints: BoxConstraints.tight(const Size(48, 48)),
                color: AppColor.primary,
                style: const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(AppColor.secondary),
                ),
                icon: const ImageIcon(
                  AssetImage('assets/icons/notifikasion.png'),
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Gap(26),
          const Text(
            'Mood Check',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: AppColor.textBody,
            ),
          ),
          const Gap(6),
          buildTitle(),
          const Gap(16),
          buildButtonYourMood(),
          const Gap(20),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return Row(
      children: [
        GestureDetector(
          onTap: gotoAccount,
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.png',
              width: 48,
              height: 48,
            ),
          ),
        ),
        const Gap(16),
        FutureBuilder(
            future: Session.getUser(),
            builder: (context, snapshot) {
              UserModel? user = snapshot.data;
              String name = user?.name ?? '';
              return Text(
                'Hi, $name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.textTitle,
                ),
              );
            }),
      ],
    );
  }

  Widget buildTitle() {
    return RichText(
      text: const TextSpan(
        text: 'Lagi ngerasa apa, nih?,\n',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 26,
          color: AppColor.textTitle,
          height: 1.2,
        ),
        children: [
          TextSpan(
            text: 'Coba kasih tahu suasana\nhatimu!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonYourMood() {
    return Material(
      color: AppColor.primary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: gotoChooseMood,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Mood Kamu',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              ImageIcon(
                AssetImage('assets/icons/arrow_right.png'),
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildYourMoodToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Mood Kamu Hari Ini',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColor.textTitle,
            ),
          ),
        ),
        const Gap(24),
        Obx(() {
          final state = moodTodayController.state;
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
            );
          }
          final list = state.list;
          if (list.isEmpty) {
            return const ResponseFailed(
              message: 'No Mood Yet',
              margin: EdgeInsets.symmetric(horizontal: 20),
            );
          }
          return SizedBox(
            height: 90,
            child: ListView.builder(
              itemCount: list.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                MoodModel mood = list[index];
                return buildMoodItem(mood);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildMoodItem(MoodModel mood) {
    String moodAsset = 'assets/images/moods_${mood.level}.png';
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        moodAsset,
        height: 110,
        width: 110,
      ),
    );
  }

  Widget buildKonsultasi() {
    return Container(
      margin: EdgeInsets.only(right: 15, left: 15),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sesi 1 on 1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Yuk, kita sharing tentang hal-hal penting',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: gotoChatAI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Konsultasi Sekarang',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/icons/konsultasi.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildYourAgendaToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Agenda Kamu Hari ini',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.textTitle,
                ),
              ),
              InkWell(
                onTap: gotoAllAgenda,
                child: const Text(
                  'Lihat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        Obx(() {
          final state = agendaTodayController.state;
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
              margin: const EdgeInsets.symmetric(horizontal: 20),
            );
          }
          final list = state.list;
          if (list.isEmpty) {
            return const ResponseFailed(
              message: 'No Agenda Yet',
              margin: EdgeInsets.symmetric(horizontal: 20),
            );
          }
          return ListView.builder(
            itemCount: list.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              AgendaModel agenda = list[index];
              return buildAgendaItem(agenda);
            },
          );
        }),
      ],
    );
  }

  Widget buildAgendaItem(AgendaModel agenda) {
    return GestureDetector(
      onTap: () => gotoDetailAgenda(agenda.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agenda.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textTitle,
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Chip(
                  avatar: Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    DateFormat('H:mm').format(agenda.startEvent),
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: AppColor.primary, width: 1),
                  ),
                ),
                const Gap(10),
                Chip(
                  label: Text(agenda.category),
                  visualDensity: const VisualDensity(vertical: -4),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: AppColor.textTitle,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: AppColor.secondary, width: 1),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const ImageIcon(
                        AssetImage('assets/icons/arrow_right.png'),
                        size: 24,
                        color: AppColor.secondary,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
