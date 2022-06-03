import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:admin_panel/home/widget/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final _graphController = Get.find<GraphController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Haptic.feedbackClick();
          await _graphController.getGraphFromFirestore();
          Haptic.feedbackSuccess();
        },
        child: CustomScrollView(
          primary: false,
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              floating: false,
              snap: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                IconButton(
                  color: Get.theme.colorScheme.tertiary,
                  onPressed: () {
                    Haptic.feedbackClick();
                    Get.toNamed(MyRoutes.cashFlow);
                  },
                  icon: Icon(Icons.account_balance_wallet),
                ),
              ],
              bottom: PreferredSize(
                child: Container(),
                preferredSize: Size(0, 20),
              ),
              expandedHeight: 450,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.context.width,
                      child: FutureBuilder(
                          future: _graphController.getGraph,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  'Laporan Jualan Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)}',
                                ),
                                const SizedBox(height: 5),
                                Obx(() {
                                  return Text(
                                    'RM ${_graphController.jumlahBulanan.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                                Obx(() => Text.rich(
                                      TextSpan(
                                        text:
                                            '${_graphController.percentBulanan.value.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 12.2,
                                          color: _graphController
                                                      .percentBulanan.value >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  ' daripada jualan bulan lepas',
                                              style: TextStyle(
                                                color: Get.theme.colorScheme
                                                    .inverseSurface,
                                              )),
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  child: Container(
                                    height: 220,
                                    child: GraphMonthlySales(),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          color: Get.theme.colorScheme.tertiary,
                                        ),
                                        SizedBox(width: 10),
                                        const Text(
                                          'Harga Jual',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          color: Colors.amber[900],
                                        ),
                                        SizedBox(width: 10),
                                        const Text(
                                          'Modal',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: Get.theme.colorScheme.primary,
                                    ),
                                    SizedBox(width: 10),
                                    const Text(
                                      'Untung Bersih',
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Hero(tag: 'rekod', child: DashboardCardAll(true)),
                      SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
