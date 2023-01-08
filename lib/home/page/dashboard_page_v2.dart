import 'package:admin_panel/graph/graph_controller.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../auth/controller/firebaseAuth_controller.dart';
import '../controller/customer_controller.dart';
import '../controller/home_controller.dart';
import '../controller/sparepart_controller.dart';

class DashboardPage2 extends StatelessWidget {
  DashboardPage2({Key key}) : super(key: key);
  final _authController = Get.find<AuthController>();
  final _graphController = Get.find<GraphController>();
  final _customerController = Get.find<CustomerController>();
  final _sparepartController = Get.find<SparepartController>();
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => AdvancedAvatar(
                          size: 60,
                          name: _authController.userName.value,
                          image: ExtendedNetworkImageProvider(
                            _authController.photoURL.value,
                            cache: true,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => Text.rich(
                          TextSpan(
                            text: 'Salam, ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${_authController.userName.value.split(' ').elementAt(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Papan Utama',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MasonryGrid(
                        column: 2,
                        children: [
                          _dashboard(
                            context: context,
                            title: 'Invois',
                            icon: Icons.payment,
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            avatarColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 50),
                                    Text(
                                      '5',
                                      style: const TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Belum Dibayar',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Lihat',
                                            ),
                                            const SizedBox(width: 5),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 19,
                                            )
                                          ],
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .onTertiary,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _dashboard(
                            context: context,
                            title: 'Jualan Bulan Ini',
                            icon: Icons.calendar_month_outlined,
                            children: [
                              FutureBuilder(
                                  future: _graphController.getGraph,
                                  builder: (context, snapshot) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            'RM',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${_graphController.jumlahBulanan.value.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${_graphController.percentBulanan.value.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: _graphController
                                                          .percentBulanan
                                                          .value >=
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                          const Text(
                                            'Daripada bulan lepas',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          _dashboard(
                            context: context,
                            title: 'Untung Kasar',
                            icon: Icons.bar_chart_outlined,
                            children: [
                              FutureBuilder(
                                  future: _graphController.getGraph,
                                  builder: (context, snapshot) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 50),
                                          Text(
                                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${_graphController.getUntungKasar(DateTime.now().month - 1).toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Keseluruhan (RM)',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.untungKasar.value)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          _dashboard(
                            context: context,
                            title: 'Modal',
                            icon: Icons.monetization_on_outlined,
                            children: [
                              FutureBuilder(
                                  future: _graphController.getGraph,
                                  builder: (context, snapshot) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 50),
                                          Text(
                                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${_graphController.getMonthsHargajual(DateTime.now().month - 1).toDouble().toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                          const Text(
                                            'Keseluruhan (RM)',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.jumlahModal.value)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          _dashboard(
                            context: context,
                            title: 'Untung Bersih',
                            icon: Icons.bar_chart_outlined,
                            children: [
                              FutureBuilder(
                                  future: _graphController.getGraph,
                                  builder: (context, snapshot) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 50),
                                          Text(
                                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${_graphController.getUntungBersih(DateTime.now().month - 1).toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                          const Text(
                                            'Keseluruhan (RM)',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            snapshot.connectionState ==
                                                    ConnectionState.waiting
                                                ? '--'
                                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.untungBersih.value)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Get.theme.colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          // _dashboard(
                          //   context: context,
                          //   title: 'Jumlah Spareparts',
                          //   icon: Icons.workspaces_outline,
                          //   children: [
                          //     Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const SizedBox(height: 20),
                          //           Obx(() => Text(
                          //                 '${_sparepartController.totalSpareparts.value}',
                          //                 style: TextStyle(
                          //                   fontSize: 35,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Get.theme.colorScheme
                          //                       .onSecondaryContainer,
                          //                 ),
                          //               )),
                          //           const Text(
                          //             'Item',
                          //             style: const TextStyle(
                          //               color: Colors.grey,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          _dashboard(
                            context: context,
                            title: 'Jumlah Pelanggan',
                            icon: Icons.people_outline,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Obx(() => Text(
                                          '${_customerController.customerListRead.value}',
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Get.theme.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        )),
                                    const Text(
                                      'Orang',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // _dashboard(
                          //   context: context,
                          //   title: 'Pending Job',
                          //   icon: Icons.cases_outlined,
                          //   children: [
                          //     Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const SizedBox(height: 20),
                          //           Obx(() => Text(
                          //                 '${_homeController.totalMysid.value}',
                          //                 style: TextStyle(
                          //                   fontSize: 35,
                          //                   fontWeight: FontWeight.bold,
                          //                   color: Get.theme.colorScheme
                          //                       .onSecondaryContainer,
                          //                 ),
                          //               )),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _dashboard(
      {@required BuildContext context,
      @required String title,
      @required IconData icon,
      List<Widget> children,
      Color backgroundColor,
      Color avatarColor}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
      width: 160,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: CircleAvatar(
                  radius: 18,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor:
                      avatarColor ?? Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    icon,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: children ?? [],
          ),
        ],
      ),
    );
  }
}
