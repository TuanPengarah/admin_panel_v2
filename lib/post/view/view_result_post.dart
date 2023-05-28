import 'package:admin_panel/post/controller/controller_create_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ViewResultPost extends StatelessWidget {
  ViewResultPost({super.key});

  final _controller = Get.put(ControllerCreatePost());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _controller.savePost(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: WidgetsToImage(
          controller: _controller.screenController,
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color:
                  Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
              image: DecorationImage(
                image: FileImage(_controller.imageLocation),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.topLeft,
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,
                    0.3,
                    0.50,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShaderMask(
                          shaderCallback: ((bounds) => const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                ],
                                stops: [
                                  0.0,
                                  0.0,
                                ],
                              ).createShader(bounds)),
                          blendMode: BlendMode.srcATop,
                          child: Container(
                            width: 52,
                            height: 58,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/splash_light.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _controller.modelPhoneText.text.isEmpty
                              ? 'VIVO V9'
                              : _controller.modelPhoneText.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          _controller.repairText.text.isEmpty
                              ? 'Penukaran LCD'
                              : _controller.repairText.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 220),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Masalah: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            for (var prob in _controller.masalah)
                              Text(
                                '- $prob',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ],
                    ),
                    _controller.jenisGambar != 'Biasa'
                        ? Container(
                            alignment: Alignment.centerRight,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                _controller.jenisGambar == 'Next'
                                    ? Icons.arrow_right_alt
                                    : Icons.done,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
