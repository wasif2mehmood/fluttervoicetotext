import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

// ignore: camel_case_types
class voice_to_text extends StatefulWidget {
  const voice_to_text({super.key});

  @override
  State<voice_to_text> createState() => _voice_to_textState();
}

class _voice_to_textState extends State<voice_to_text> {
  List<Map<String, dynamic>> record = [];
  final SpeechToText speech_to_text = SpeechToText();
  var enebaled_speech = false;
  var words = '';
  var data = "";
  var recording = false;

  void refresh() async {}

  final TextEditingController title_controller = TextEditingController();
  final TextEditingController desc_controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    init_speech();
    desc_controller.text = words;
    refresh();
  }

  void init_speech() async {
    enebaled_speech = await speech_to_text.initialize();
    print("Speech is enabled: $enebaled_speech");
    setState(() {});
  }

  void start_listening() async {
    await speech_to_text.listen(onResult: on_speech_result);
    setState(() {});
  }

  void stop_listening() async {
    await speech_to_text.stop();
    setState(() {
      data += "$words ";
      desc_controller.text = data;
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void on_speech_result(SpeechRecognitionResult result) {
    setState(() {
      words = result.recognizedWords;
      desc_controller.text = words;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
          glowRadiusFactor: 2,
          animate: recording,
          glowColor: const Color(0xff008080),
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                start_listening();
                recording = true;
                print("Listening Startedssssssssssssssssssss");
              });
            },
            onTapUp: (details) {
              setState(() {
                stop_listening();
                recording = false;
              });
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xff0818A8),
              radius: 35,
              child: Icon(
                Icons.mic,
                color: Colors.white,
              ),
            ),
          )),
      backgroundColor: const Color(0xffE8EAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xff3F51B5),
        title: const Text("Speech To Text",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: desc_controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Generated Text",
                  border: OutlineInputBorder(),
                  hintText: "Generated Text",
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'To record, hold down the button. When you finish speaking or want to take a break, release the button when you hear the stop bell. To stop recording completely, wait for the stop bell and then hold the button again to continue.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
