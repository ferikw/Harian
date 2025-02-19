import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/constant.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/common/info.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/models/agenda_model.dart';
import 'package:harian/presentasion/controllers/add_agenda_controller.dart';
import 'package:harian/presentasion/controllers/all_agenda/all_agenda_controller.dart';
import 'package:harian/presentasion/widgets/custom_button.dart';
import 'package:harian/presentasion/widgets/custom_input.dart';

class AddAgendaPage extends StatefulWidget {
  const AddAgendaPage({super.key});

  static const routeName = '/add-agenda';

  @override
  State<AddAgendaPage> createState() => _AddAgendaPageState();
}

class _AddAgendaPageState extends State<AddAgendaPage> {
  final addAgendaController = Get.put(AddAgendaController());
  final allAgendaController = Get.put(AllAgendaController());

  final titleController = TextEditingController();
  final categoryController = TextEditingController(
    text: Constant.agendaCategories.first,
  );
  final startEventController = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );
  final endEventController = TextEditingController(
    text: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
  );
  final descriptionController = TextEditingController();

  void addNew() async {
    final title = titleController.text;
    final category = categoryController.text;
    final startEvent = startEventController.text;
    final endEvent = endEventController.text;
    final description = descriptionController.text;

    if (title.isEmpty) {
      Info.failed('Title must be filled');
      return;
    }

    if (startEvent.isEmpty) {
      Info.failed('Start Event must be filled');
      return;
    }

    if (DateTime.tryParse(startEvent) == null) {
      Info.failed('Start Event not valid');
      return;
    }

    if (endEvent.isEmpty) {
      Info.failed('Start Event must be filled');
      return;
    }

    if (DateTime.tryParse(endEvent) == null) {
      Info.failed('Start Event not valid');
      return;
    }

    final startEventDate = DateTime.parse(startEvent);
    final endEventDate = DateTime.parse(endEvent);
    if (startEventDate.isAfter(endEventDate)) {
      Info.failed('End Event must be after Start Event');
      return;
    }

    if (endEventDate.difference(startEventDate).inMinutes < 30) {
      Info.failed('Minimum range event is 30 Minutes');
      return;
    }

    int userId = (await Session.getUser())!.id;
    final agenda = AgendaModel(
      id: 0,
      title: title,
      category: category,
      startEvent: startEventDate,
      endEvent: endEventDate,
      description: description,
      userId: userId,
    );
    final state = await addAgendaController.executeRequest(agenda);

    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      allAgendaController.fetchData(userId);
      Info.success(state.message);
      if (mounted) Navigator.pop(context);
      return;
    }
  }

  void chooseDateTime(TextEditingController controller) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      initialDate: now,
      lastDate: DateTime(now.year + 1, now.month),
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (pickedTime == null) return;

    controller.text = DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }

  @override
  void dispose() {
    AddAgendaController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Gap(10),
                buildTitleInput(),
                const Gap(20),
                buildCategoryInput(),
                const Gap(20),
                buildStartEventInput(),
                const Gap(20),
                buildEndEventInput(),
                const Gap(20),
                buildDescriptionInput(),
                const Gap(30),
                buildAddButton(),
              ],
            ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const ImageIcon(
                      AssetImage('assets/icons/arrow_back.png'),
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Tambahkan Agenda",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {},
                icon: const ImageIcon(
                  AssetImage('assets/icons/add_circle.png'),
                  size: 24,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Judul',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: titleController,
          hint: 'Masukkan Agenda Kegiatanmu',
          maxLines: 1,
        ),
      ],
    );
  }

  Widget buildCategoryInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        DropdownButtonFormField<String>(
          value: categoryController.text,
          items: Constant.agendaCategories.map(
            (e) {
              return DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColor.textBody,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            if (value == null) return;
            categoryController.text = value;
          },
          icon: const ImageIcon(
            AssetImage('assets/icons/arrow_down_circle.png'),
            size: 24,
            color: AppColor.primary,
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStartEventInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agenda Mulai',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: startEventController,
          hint: '2024-08-30 07:00',
          maxLines: 1,
          suffixIcon: 'assets/icons/calendar.png',
          suffixOnTap: () => chooseDateTime(startEventController),
        ),
      ],
    );
  }

  Widget buildEndEventInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Agenda Selesai',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: endEventController,
          hint: '2024-08-30 07:00',
          maxLines: 1,
          suffixIcon: 'assets/icons/calendar.png',
          suffixOnTap: () => chooseDateTime(endEventController),
        ),
      ],
    );
  }

  Widget buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: descriptionController,
          hint: 'Bersama keluarga...',
          minLines: 2,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget buildAddButton() {
    return Obx(() {
      final state = addAgendaController.state;
      final statusRequest = state.statusRequest;
      if (statusRequest == StatusRequest.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return ButtonPrimary(
        onPressed: addNew,
        title: 'Tambahkan Agenda',
      );
    });
  }
}
