import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/common/info.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/models/solution_model.dart';
import 'package:harian/presentasion/controllers/add_solution_controller.dart';
import 'package:harian/presentasion/controllers/solution_controller.dart';
import 'package:harian/presentasion/widgets/custom_button.dart';
import 'package:harian/presentasion/widgets/custom_input.dart';

class AddSolutionPage extends StatefulWidget {
  const AddSolutionPage({super.key});

  static const routeName = '/add-solution';

  @override
  State<AddSolutionPage> createState() => _AddSolutionPageState();
}

class _AddSolutionPageState extends State<AddSolutionPage> {
  final addSolutionController = Get.put(AddSolutionController());
  final findSolutionController = Get.find<SolutionController>();

  final summaryController = TextEditingController();
  final problemController = TextEditingController();
  final solutionController = TextEditingController();
  final referenceController = TextEditingController();

  final references = <String>[].obs;

  void addItemReference() {
    final item = referenceController.text;
    if (item == '') return;

    references.add(item);
    referenceController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void removeItemReference(String item) {
    references.remove(item);
  }

  void addNew() async {
    final summary = summaryController.text;
    final problem = problemController.text;
    final solution = solutionController.text;

    if (summary == '') {
      Info.failed('Summary must be filled');
      return;
    }

    if (problem == '') {
      Info.failed('Problem must be filled');
      return;
    }

    if (solution == '') {
      Info.failed('Solution must be filled');
      return;
    }

    final user = await Session.getUser();
    final userId = user!.id;
    final solutionModel = SolutionModel(
      id: 0,
      userId: userId,
      summary: summary,
      problem: problem,
      solution: solution,
      reference: List.from(references),
      createdAt: DateTime.now(),
    );
    final state = await addSolutionController.executeRequest(solutionModel);
    if (state.statusRequest == StatusRequest.failed) {
      Info.failed(state.message);
      return;
    }

    if (state.statusRequest == StatusRequest.success) {
      Info.success(state.message);
      findSolutionController.fetchData(userId);
      if (mounted) Navigator.pop(context);
      return;
    }
  }

  @override
  void dispose() {
    AddSolutionController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildHeader(),
          const Gap(6),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const Gap(6),
                buildSummary(),
                const Gap(20),
                buildProblem(),
                const Gap(20),
                buildSolution(),
                const Gap(20),
                buildReference(),
                const Gap(40),
                buildAddButton(),
                const Gap(30),
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
                "Tambahkan Solusi",
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

  Widget buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rangkuman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: summaryController,
          hint: 'Masukkan Rangkuman Permasalahanmu...',
          minLines: 3,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget buildProblem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Permasalahan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: problemController,
          hint: 'Apa masalahmu? ceritakan disini ya...',
          maxLines: 1,
        ),
      ],
    );
  }

  Widget buildSolution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Solusi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: solutionController,
          hint: 'Kira-kira kamu bakal ngelakuin solusi apa...',
          minLines: 2,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget buildReference() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Referensi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.textTitle,
          ),
        ),
        const Gap(12),
        CustomInput(
          controller: referenceController,
          hint: 'Instagram: @author...',
          maxLines: 1,
          suffixIcon: 'assets/icons/add_circle.png',
          suffixOnTap: addItemReference,
        ),
        const Gap(12),
        Obx(() {
          return Column(
            children: references.map(
              (item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          onPressed: () => removeItemReference(item),
                          padding: const EdgeInsets.all(0),
                          icon: const ImageIcon(
                            AssetImage('assets/icons/close_circle.png'),
                            size: 24,
                            color: AppColor.error,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Transform.translate(
                          offset: const Offset(0, 8),
                          child: SelectableText(
                            item,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: AppColor.textBody,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        }),
      ],
    );
  }

  Widget buildAddButton() {
    return Obx(() {
      if (addSolutionController.state.statusRequest == StatusRequest.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      return ButtonPrimary(
        onPressed: addNew,
        title: 'Add New',
      );
    });
  }
}
