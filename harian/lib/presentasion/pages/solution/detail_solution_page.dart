import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/data/models/solution_model.dart';
import 'package:harian/presentasion/controllers/detail_solution_controller.dart';
import 'package:harian/presentasion/widgets/response_failed.dart';

class DetailSolutionPage extends StatefulWidget {
  const DetailSolutionPage({super.key, required this.solutionId});
  final int solutionId;

  static const routeName = '/detail-solution';

  @override
  State<DetailSolutionPage> createState() => _DetailSolutionPageState();
}

class _DetailSolutionPageState extends State<DetailSolutionPage> {
  final detailSolutionController = Get.put(DetailSolutionController());

  @override
  void initState() {
    detailSolutionController.fetchData(widget.solutionId);
    super.initState();
  }

  @override
  void dispose() {
    DetailSolutionController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 200,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/header.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Obx(
            () {
              final state = detailSolutionController.state;
              final statusRequest = state.statusRequest;
              if (statusRequest == StatusRequest.init) {
                return const SizedBox();
              }
              if (statusRequest == StatusRequest.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (statusRequest == StatusRequest.failed) {
                return Center(
                  child: ResponseFailed(
                    message: state.message,
                    margin: const EdgeInsets.all(20),
                  ),
                );
              }
              SolutionModel solution = state.solution!;
              return ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const Gap(50),
                  buildHeader('Detail'),
                  const Gap(30),
                  buildProblem(solution.problem),
                  const Gap(30),
                  buildSummary(solution.summary),
                  const Gap(30),
                  buildSolution(solution.solution),
                  const Gap(30),
                  buildReference(solution.reference),
                  const Gap(30),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeader(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Material(
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
          const Gap(10),
          Expanded(
            child: Center(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProblem(String problem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: AppColor.primary,
          width: 1,
        ),
      ),
      child: Text(
        problem,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColor.textTitle,
        ),
      ),
    );
  }

  Widget buildSummary(String summary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: AppColor.primary,
          width: 1,
        ),
      ),
      child: Column(
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
          Text(
            summary,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.textBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSolution(String solution) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: AppColor.primary,
          width: 1,
        ),
      ),
      child: Column(
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
          Text(
            solution,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.textBody,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReference(List<String> reference) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: AppColor.primary,
          width: 1,
        ),
      ),
      child: Column(
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
          Column(
            children: reference.map(
              (item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: ImageIcon(
                          AssetImage('assets/icons/disc.png'),
                          size: 24,
                          color: AppColor.primary,
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
          ),
        ],
      ),
    );
  }
}
