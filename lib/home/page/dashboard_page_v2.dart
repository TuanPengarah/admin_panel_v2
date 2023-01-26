import 'package:admin_panel/cash_flow/controller/cashflow_controller.dart';
import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/config/routes.dart';
import 'package:admin_panel/graph/graph_controller.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../auth/controller/firebaseAuth_controller.dart';
import '../controller/customer_controller.dart';

class DashboardPage2 extends StatelessWidget {
  DashboardPage2({Key key}) : super(key: key);
  final _authController = Get.find<AuthController>();
  final _graphController = Get.find<GraphController>();
  final _customerController = Get.find<CustomerController>();
  final _cashFlowController = Get.put(CashFlowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => await _graphController.getGraphFromFirestore(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(MyRoutes.setting),
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
                            size: 80,
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
                        const SizedBox(height: 10),
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
                        dashBoard(context),
                      ],
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

  GetBuilder<GraphController> dashBoard(BuildContext context) {
    return GetBuilder<GraphController>(builder: (_) {
      return MasonryGrid(
        column: 2,
        children: [
          _dashboard(
            context: context,
            title: 'Invois',
            icon: Icons.payment,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            avatarColor: Theme.of(context).colorScheme.onTertiaryContainer,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .ref('Invoices')
                            .orderByChild('isPay')
                            .equalTo(false)
                            .onValue,
                        builder:
                            (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          List invItem = [];
                          if (snapshot.hasData) {
                            var data = snapshot.data.snapshot.value
                                as Map<dynamic, dynamic>;

                            if (data != null) {
                              data.forEach((key, value) {
                                invItem.add({'id': key, ...value});
                              });
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                invItem.length.toString(),
                                style: const TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                invItem.isNotEmpty
                                    ? 'Belum Dibayar'
                                    : 'Belum Dibayar. Alhamdulillah 🤲🏻',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          );
                        }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Haptic.feedbackClick();
                          Get.toNamed(MyRoutes.invoisView);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onTertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Sparkline(
                            data: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? []
                                : _graphController.untungBulananTahunLepasSpike,
                            pointsMode: PointsMode.all,
                            lineColor: Colors.teal,
                            fillMode: FillMode.below,
                            fillGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.teal.withOpacity(0.9),
                                Colors.teal.withOpacity(0.0),
                              ],
                            ),
                            useCubicSmoothing: true,
                            cubicSmoothingFactor: 0.2,
                            averageLine: true,
                            averageLabel: true,
                            kLine: ['max', 'min', 'first', 'last'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${_graphController.getUntungKasar(DateTime.now().month - 1).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onSecondaryContainer,
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
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.untungKasar.value)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Sparkline(
                            data: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? []
                                : _graphController.modalSpike,
                            pointsMode: PointsMode.all,
                            lineColor: Colors.amber.shade900,
                            fillMode: FillMode.below,
                            fillGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.amber.shade900.withOpacity(0.9),
                                Colors.amber.shade900.withOpacity(0.0),
                              ],
                            ),
                            useCubicSmoothing: true,
                            cubicSmoothingFactor: 0.2,
                            averageLine: true,
                            averageLabel: true,
                            kLine: ['max', 'min', 'first', 'last'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${_graphController.getMonthsHargajual(DateTime.now().month - 1).toDouble().toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const Text(
                            'Keseluruhan (RM)',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.jumlahModal.value)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Sparkline(
                            data: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? []
                                : _graphController.untungBersihSpike,
                            pointsMode: PointsMode.all,
                            lineColor: Colors.green,
                            fillMode: FillMode.below,
                            fillGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.green.withOpacity(0.9),
                                Colors.green.withOpacity(0.0),
                              ],
                            ),
                            useCubicSmoothing: true,
                            cubicSmoothingFactor: 0.2,
                            averageLine: true,
                            averageLabel: true,
                            kLine: ['max', 'min', 'first', 'last'],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bulan ${_graphController.checkMonthsMalay(DateTime.now().month - 1)} (RM)',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${_graphController.getUntungBersih(DateTime.now().month - 1).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const Text(
                            'Keseluruhan (RM)',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            snapshot.connectionState == ConnectionState.waiting
                                ? '--'
                                : '${NumberFormat.compactCurrency(decimalDigits: 2, symbol: '').format(_graphController.untungBersih.value)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
            title: 'Jualan Bulan Ini',
            icon: Icons.calendar_month_outlined,
            children: [
              FutureBuilder(
                  future: _graphController.getGraph,
                  builder: (context, snapshot) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Obx(() => Text(
                                snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? '--'
                                    : '${_graphController.percentBulanan.value}%',
                                style: TextStyle(
                                  color: double.parse(_graphController
                                              .percentBulanan.value) >=
                                          0
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Text(
                            'Daripada bulan lepas',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Haptic.feedbackClick();
                                Get.toNamed(MyRoutes.monthlyRecord);
                              },
                              child: Text('Rekod'),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),
            ],
          ),
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
                            color: Get.theme.colorScheme.onSecondaryContainer,
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
          _dashboard(
            context: context,
            title: 'Jumlah Baiki',
            icon: Icons.handyman_outlined,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Obx(() => Text(
                          '${_authController.jumlahRepair.value}',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onSecondaryContainer,
                          ),
                        )),
                    const Text(
                      'Peranti dibaiki',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: _cashFlowController.initCashFlow,
              builder: (context, snapshot) {
                return _dashboard(
                  context: context,
                  title: 'Cashflow',
                  icon: Icons.wallet,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Kesulurahan (RM)',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          snapshot.connectionState == ConnectionState.waiting
                              ? Text(
                                  '--',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Get
                                        .theme.colorScheme.onSecondaryContainer,
                                  ),
                                )
                              : Obx(() => Text(
                                    '${_cashFlowController.total.value.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  )),
                          const SizedBox(height: 10),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Masuk',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        'RM${_cashFlowController.masuk.value}',
                                        style: TextStyle(
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Keluar',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        'RM${_cashFlowController.keluar.value}',
                                        style: TextStyle(
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.grey.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Haptic.feedbackClick();
                                Get.toNamed(MyRoutes.cashFlow);
                              },
                              child: Text('Lebih lanjut'),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ],
      );
    });
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
