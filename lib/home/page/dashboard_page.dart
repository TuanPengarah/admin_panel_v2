import 'package:admin_panel/config/haptic_feedback.dart';
import 'package:admin_panel/graph/graph_monthly_sales.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              height: 300,
              color: Theme.of(context).primaryColor),
          RefreshIndicator(
            onRefresh: () async {
              Haptic.feedbackClick();
              await Future.delayed(Duration(seconds: 2));
              Haptic.feedbackSuccess();
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: Text('Dashboard'),
                  floating: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Stack(
                              children: [
                                Container(
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Laporan Jualan Bulanan',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'RM 723',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10),
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
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Harga Jual',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Harga Supplier',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 330,
                                  right: 17,
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: 350,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
