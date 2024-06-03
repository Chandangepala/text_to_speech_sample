import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech_sample/const.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts _flutterTts = FlutterTts();
  List<Map> _voices = [];
  Map? currentVoice;
  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentWordStart = start;
      _currentWordEnd = end;
      setState(() {

      });
    });

    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
       // _voices = _voices.where((_voice) => _voice['name'].contains('en')).toList();
        print(_voices);
        setState(() {
          currentVoice = _voices.first;
          setVoice(currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({'name': voice['name'], 'locale': voice['locale']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _flutterTts.speak(TTS_INPUT);
          },
          child: Icon(Icons.record_voice_over),
        ),
        body: _buildUI());
  }

  Widget _buildUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _speakerSelector(),
            SizedBox(
              height: 25,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(text: TTS_INPUT.substring(0, _currentWordStart)),
                      if(_currentWordStart != null)
                        TextSpan(text: TTS_INPUT.substring(_currentWordStart!, _currentWordEnd), style: TextStyle(color: Colors.orangeAccent)),
                      if(_currentWordEnd != null)
                        TextSpan(text: TTS_INPUT.substring(_currentWordEnd!)),
                    ]
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _speakerSelector() {
    return DropdownButton(
        value: currentVoice,
        items: _voices
            .map((voice) => DropdownMenuItem(
                  value: voice,
                  child: Text("${voice['name']}"),
                ))
            .toList(),
        onChanged: (voice) {
          currentVoice = voice;
          setVoice(currentVoice!);
          setState(() {

          });
        });
  }
}
