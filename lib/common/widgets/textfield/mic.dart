import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Mic extends GetxController {
  static Mic get instance => Get.find();
  RxBool isListening = false.obs;
  final TextEditingController textController = TextEditingController();
  RxString textSpeech = ''.obs;
  late stt.SpeechToText speech;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    speech = stt.SpeechToText();
  }

  void onListen() async {

    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (val) {


          if (val == 'done' || val == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (val) {

          isListening.value = false;
        },
      );

      if (available) {
        isListening.value = true;
        textController.text = 'Listening...';

        speech.listen(
          onResult: (val) {
            textSpeech.value = val.recognizedWords;
            textController.text = val.recognizedWords;


            searchController.text = val.recognizedWords;
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchController.text.length),
            );
          },
        );
      }
    } else {
      isListening.value = false;
      speech.stop();
    }


  }
  @override
  void onClose() {

    searchController.dispose();
    super.onClose();
  }
}