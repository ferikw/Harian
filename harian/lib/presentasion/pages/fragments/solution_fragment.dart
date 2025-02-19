import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:harian/common/app_color.dart';
import 'package:harian/common/enums.dart';
import 'package:harian/core/session.dart';
import 'package:harian/data/models/solution_model.dart';
import 'package:harian/presentasion/controllers/solution_controller.dart';
import 'package:harian/presentasion/pages/solution/add_solution_page.dart';
import 'package:harian/presentasion/pages/solution/detail_solution_page.dart';
import 'package:harian/presentasion/pages/solution/update_solution_page.dart';
import 'package:harian/presentasion/widgets/response_failed.dart';

class SolutionFragment extends StatefulWidget {
  const SolutionFragment({super.key});

  @override
  State<SolutionFragment> createState() => _SolutionFragmentState();
}

class _SolutionFragmentState extends State<SolutionFragment> {
  final solutionController = Get.put(SolutionController());
  final searchController = TextEditingController();

  void gotoAddSolution() {
    Navigator.pushNamed(context, AddSolutionPage.routeName);
  }

  void gotoDetailSolution(int id) {
    Navigator.pushNamed(
      context,
      DetailSolutionPage.routeName,
      arguments: id,
    );
  }

  void gotoUpdateSolution(SolutionModel solution) {
    Navigator.pushNamed(
      context,
      UpdateSolutionPage.routeName,
      arguments: solution,
    );
  }

  void search() {
    final query = searchController.text;
    if (query == '') return;

    Session.getUser().then((user) {
      int userId = user!.id;
      solutionController.search(userId, query);
    });
  }

  refresh() {
    Session.getUser().then((user) {
      int userId = user!.id;
      solutionController.fetchData(userId);
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    SolutionController.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        const Gap(30),
        buildSearchBox(),
        const Gap(16),
        Expanded(
          child: buildList(),
        ),
      ],
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
                        "Solusi Diri",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Yuk cek dan atasi permasalahanmu",
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
                    onPressed: gotoAddSolution,
                    heroTag: 'add-solution-btn',
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    child: ImageIcon(
                      AssetImage('assets/icons/doc_add_outlined.png'),
                      size: 24,
                      color: Colors.white,
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

  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: searchController,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.black,
        ),
        autocorrect: false,
        enableSuggestions: false,
        cursorColor: AppColor.secondary,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: search,
            child: const UnconstrainedBox(
              alignment: Alignment(-0.5, 0),
              child: ImageIcon(
                AssetImage('assets/icons/search.png'),
                size: 24,
                color: Colors.grey,
              ),
            ),
          ),
          hintText: 'Ketikkan Permasalahanmu...',
          hintStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.primary),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    return Obx(
      () {
        final state = solutionController.state;
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
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          );
        }
        final list = state.list;
        if (list.isEmpty) {
          return const ResponseFailed(
            message: 'No Solution Yet',
            margin: EdgeInsets.fromLTRB(20, 16, 20, 140),
          );
        }
        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          itemBuilder: (context, index) {
            SolutionModel solution = list[index];
            return buildItemList(solution);
          },
        );
      },
    );
  }

  Widget buildItemList(SolutionModel solution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => gotoDetailSolution(solution.id),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 55),
                    child: Text(
                      solution.problem,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColor.textTitle,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    solution.solution,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              width: 46,
              height: 36,
              child: FloatingActionButton(
                onPressed: () => gotoUpdateSolution(solution),
                heroTag: 'solution-${solution.id}',
                backgroundColor: AppColor.primary,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
                child: const ImageIcon(
                  AssetImage('assets/icons/edit.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
