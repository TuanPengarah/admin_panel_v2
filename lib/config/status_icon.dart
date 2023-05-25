import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final String iconstatus;

  const StatusIcon(this.iconstatus, {super.key});

  Widget _buildIcon() {
    if (iconstatus == 'Belum Selesai') {
      return IconButton(
        icon: const Icon(
          Icons.refresh,
          color: Colors.grey,
        ),
        onPressed: () {},
        tooltip: 'Belum Selesai (PendingJob)',
      );
    } else if (iconstatus == 'Selesai') {
      return IconButton(
        icon: const Icon(Icons.done, color: Colors.grey),
        onPressed: () {},
        tooltip: 'Selesai',
      );
    } else if (iconstatus == 'Tak Boleh') {
      return IconButton(
        icon: const Icon(Icons.close, color: Colors.grey),
        onPressed: () {},
        tooltip: 'Tak Boleh Buat',
      );
    }
    return Container(
      child: _buildIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIcon();
  }
}
