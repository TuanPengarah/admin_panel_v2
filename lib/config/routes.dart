import 'package:admin_panel/POS/view/invoice_details_view.dart';
import 'package:admin_panel/POS/view/view_invois.dart';
import 'package:admin_panel/cash_flow/view/cashflow_viewall.dart';
import 'package:admin_panel/config/binding.dart';
import 'package:admin_panel/post/view/view_create_post.dart';
import 'package:admin_panel/post/view/view_history_post.dart';
import 'package:admin_panel/settings/setting_view.dart';
import 'package:get/get.dart';
import '../post/view/view_result_post.dart';
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
  static const setting = '/setting';
  static const invoisView = '/view-invoice';
  static const detailsInvoice = '/invoice-detail';
  static const resultPost = '/post/result';
  static const createPost = '/post';
  static const historyPost = '/post/history';

  List<GetPage> page = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(
      name: home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: jobsheet,
      page: () => JobsheetView(),
      binding: JobSheetBinding(),
    ),
    GetPage(
      name: jobsheetHistory,
      page: () => const JobsheetHistory(),
      binding: JobSheetHistoryBinding(),
    ),
    GetPage(name: overview, page: () => CustomerView()),
    GetPage(name: jobsheetDone, page: () => JobsheetCompleted()),
    GetPage(name: pdfJobsheeetViewer, page: () => PdfViewerWidget()),
    GetPage(name: mysidUpdate, page: () => MysidUpdate()),
    GetPage(name: repairLog, page: () => RepairLogView()),
    GetPage(name: mysidHisory, page: () => const MysidHistoryView()),
    GetPage(name: spareparts, page: () => const AllSparepartsView()),
    GetPage(name: sparepartsDetails, page: () => DetailsSpareparts()),
    GetPage(name: sparepartsAdd, page: () => AddSparepart()),
    // GetPage(name: sparepartsHistory, page: () => HistorySparepartsView()),
    GetPage(name: priceCalc, page: () => const PriceCalculatorView()),
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
    GetPage(name: pdfReceiptViewer, page: () => ReceiptPDF()),
    GetPage(
        name: pricelist,
        page: () => PriceListView(),
        binding: PriceListBinding()),
    GetPage(
      name: cashFlow,
      page: () => const CashFlowView(),
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
    // GetPage(name: notifHistory, page: () => NotificationHistoryView()),
    GetPage(name: chat, page: () => ChatView(), binding: ChatBinding()),
    GetPage(
      name: monthlyRecord,
      page: () => const MonthlyRecordView(),
      binding: MonthlyBinding(),
    ),
    GetPage(
        name: cashflowStatement,
        page: () => CashFlowStatementPDF(),
        binding: CashFlowStatementBinding()),
    GetPage(
      name: smsView,
      page: () => const SMSView(),
      binding: SMSBinding(),
    ),
    GetPage(
      name: cashFlowViewAll,
      page: () => const CashflowViewAll(),
    ),
    GetPage(
      name: setting,
      page: () => ViewSettings(),
    ),
    GetPage(
      name: invoisView,
      page: () => const ViewInvoice(),
    ),
    GetPage(
      name: detailsInvoice,
      page: () => ViewInvoiceDetail(),
    ),
    GetPage(name: resultPost, page: () => ViewResultPost()),
    GetPage(name: createPost, page: () => ViewCreatePost()),
    GetPage(name: historyPost, page: () => const ViewHistoryPost()),
  ];
}
