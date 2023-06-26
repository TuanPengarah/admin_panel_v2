class HistoryPost {
  final String path;
  final String imageName;
  final String model;
  final String repair;
  final String jenisGambar;
  final List<String> masalah;

  HistoryPost({
    required this.path,
    required this.imageName,
    required this.model,
    required this.repair,
    required this.jenisGambar,
    required this.masalah,
  });

  factory HistoryPost.fromLocalDB(dynamic data) {
    return HistoryPost(
        path: data['path'] as String,
        imageName: data['imageName'],
        model: data['model'],
        repair: data['repair'],
        masalah: data['masalah'],
        jenisGambar: data['jenisGambar']);
  }

  Map toDB() {
    return {
      'model': model,
      'path': path,
      'imageName': imageName,
      'repair': repair,
      'masalah': masalah,
      'jenisGambar': jenisGambar,
    };
  }
}
