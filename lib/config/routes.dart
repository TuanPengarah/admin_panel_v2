import 'package:admin_panel/cash_flow/view/cashflow_viewall.dart';
import 'package:admin_panel/config/binding.dart';
import 'package:get/get.dart';
import 'get_route_export.dart';

class MyRoutes {
  static const home = '/home';
  static const jobsheet = '/jobsheet';
  static const login = '/auth';
  static const overview = '/home/customer';
  static const jobsheetHistory = '/jobsheet/history';
  static const jobsheetDone = '/jobsheet/completed';
  static const pdfJobsheeetViewer = '/pdfviewJobsheet';
  static const pdfReceiptViewer = '/pdfviewReceipt';
  static const printView = '/print';
  static const mysidUpdate = '/home/update';
  static const repairLog = '/repair-log';
  static const mysidHisory = '/mysid-history';
  static const spareparts = '/spareparts';
  static const sparepartsDetails = '/spareparts/details';
  static const sparepartsAdd = '/spareparts/add';
  static const sparepartsHistory = '/spareparts/add/history';
  static const priceCalc = '/price-calculator';
  static const technician = '/technician';
  static const technicianAdd = '/technician/add';
  static const technicianDetails = '/technician/details';
  static const posview = '/payment';
  static const paymentSetup = '/payment/setup';
  static const bills = '/payment/bills';
  static const paymentCompleted = '/payment-completed';
  static const pricelist = '/price-list';
  static const cashFlow = '/cash-flow';
  static const notifSettings = '/notif-setting';
  static const allrecord = '/all-record';
  static const notifHistory = '/notif-history';
  static const chat = '/chat';
  static const monthlyRecord = '/monthly-record';
  static const cashflowStatement = '/cashflow-statement';
  static const smsView = '/sms-view';
  static const cashFlowViewAll = '/cashflow-viewAll';

  List<GetPage> page = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(
      name: home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: jobsheet,
      page: () => JobsheetView(),
      binding: JobSheetBinding(),
    ),
    GetPage(
      name: jobsheetHistory,
      page: () => JobsheetHistory(),
      binding: JobSheetHistoryBinding(),
    ),
    GetPage(name: overview, page: () => CustomerView()),
    GetPage(name: jobsheetDone, page: () => JobsheetCompleted()),
    GetPage(name: pdfJobsheeetViewer, page: () => PdfViewerWidget()),
    GetPage(name: mysidUpdate, page: () => MysidUpdate()),
    GetPage(name: repairLog, page: () => RepairLogView()),
    GetPage(name: mysidHisory, page: () => MysidHistoryView()),
    GetPage(name: spareparts, page: () => AllSparepartsView()),
    GetPage(name: sparepartsDetails, page: () => DetailsSpareparts()),
    GetPage(name: sparepartsAdd, page: () => AddSparepart()),
    GetPage(name: sparepartsHistory, page: () => HistorySparepartsView()),
    GetPage(name: priceCalc, page: () => PriceCalculatorView()),
    GetPage(name: technician, page: () => TechnicianView()),
    GetPage(name: technicianAdd, page: () => TechnicianAdd()),
    GetPage(name: technicianDetails, page: () => TechnicianInfo()),
    GetPage(name: posview, page: () => POSView()),
    GetPage(
      name: bills,
      page: () => BillsView(),
      binding: PosBinding(),
    ),
    GetPage(name: paymentSetup, page: () => PaymentSetup()),
    GetPage(name: paymentCompleted, page: () => PaymentCompleted()),
    GetPage(name: pdfReceiptViewer, page: () => ReceiptPDF()),
    GetPage(
        name: pricelist,
        page: () => PriceListView(),
        binding: PriceListBinding()),
    GetPage(
      name: cashFlow,
      page: () => CashFlowView(),
      binding: CashFlowBinding(),
    ),
    GetPage(
      name: notifSettings,
      page: () => NotificationSettingView(),
    ),
    GetPage(
      name: allrecord,
      page: () => RecordView(),
      binding: AllRecordBinding(),
    ),
    GetPage(name: notifHistory, page: () => NotificationHistoryView()),
    GetPage(name: chat, page: () => ChatView(), binding: ChatBinding()),
    GetPage(
      name: monthlyRecord,
      page: () => MonthlyRecordView(),
      binding: MonthlyBinding(),
    ),
    GetPage(
        name: cashflowStatement,
        page: () => CashFlowStatementPDF(),
        binding: CashFlowStatementBinding()),
    GetPage(
      name: smsView,
      page: () => SMSView(),
      binding: SMSBinding(),
    ),
    GetPage(
      name: cashFlowViewAll,
      page: () => CashflowViewAll(),
    ),
  ];
}
