import 'package:admin_panel/post/controller/controller_create_post.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCreatePost extends StatelessWidget {
  ViewCreatePost({super.key});
  final _controller = Get.put(ControllerCreatePost());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Af-Fix Post'),
      ),
      body: GetBuilder(
          init: ControllerCreatePost(),
          builder: (_) {
            return Form(
              key: _controller.key,
              child: Column(
                children: [
                  Expanded(
                    flex: 11,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            DottedBorder(
                              color: Theme.of(context).colorScheme.primary,
                              dashPattern: const [5, 2],
                              strokeWidth: 2,
                              child: InkWell(
                                onTap: _controller.uploadImage,
                                child: Ink(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _controller.imageLocation.path.isEmpty
                                          ? Icon(Icons.upload,
                                              color: Get.theme.colorScheme
                                                  .onPrimaryContainer)
                                          : Expanded(
                                              flex: 2,
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(_controller
                                                        .imageLocation),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      _controller.imageLocation.path.isEmpty
                                          ? Text(
                                              'Masukkan gambar peranti dibaiki',
                                              style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .onPrimaryContainer),
                                            )
                                          : Expanded(
                                              flex: 5,
                                              child: Text(
                                                _controller.imageName
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .onPrimaryContainer),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _controller.modelPhoneText,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Sila masukkan model peranti';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('Model Peranti'),
                                hintText: 'VIVO V9',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _controller.repairText,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Sila masukkan parts dibaiki';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('Parts dibaiki'),
                                hintText: 'Penukaran LCD',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              onTap: _controller.chooseType,
                              controller: _controller.jenisGambarText,
                              readOnly: true,
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Sila masukkan jenis gambar';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text('Jenis Gambar'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _controller.addMasalah(),
                                icon: const Icon(Icons.add),
                                label: const Text('Tambah'),
                              ),
                            ),
                            for (int i = 0; i < _controller.masalah.length; i++)
                              Column(
                                children: [
                                  TextFormField(
                                    controller:
                                        _controller.masalahController[i],
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) =>
                                        _controller.masalah[i] = value,
                                    validator: (result) {
                                      if (result!.isEmpty) {
                                        return 'Sila masukkan masalah ${i + 1} peranti ini';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Masalah ${i + 1}'),
                                      hintText: 'Lcd Crack',
                                      suffixIcon: _controller.masalah.length > 1
                                          ? IconButton(
                                              onPressed: () =>
                                                  _controller.removeMasalah(i),
                                              icon: const Icon(Icons.delete),
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => _controller.generateImage(),
                                icon: const Icon(Icons.image),
                                label: const Text('Hasilkan Gambar'),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            );
          }),
    );
  }
}
