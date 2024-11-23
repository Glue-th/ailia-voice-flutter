import 'package:flutter/material.dart';

import 'package:ailia/ailia_license.dart';
import 'package:flutter/services.dart';

import 'package:share_plus/share_plus.dart';

import 'utils/download_model.dart';
import 'text_to_speech.dart';

import 'package:ailia_voice/ailia_voice.dart' as ailia_voice_dart;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  String _predictText = 'Model Downloading...';

  // String _text = "おはようございます。こんにちは。今日はお元気ですか？";
  String _text = "This is an album";
  var outputPath;
  final _textToSpeech = TextToSpeech();

  // Prepare model file
  String encoderFile = "";
  String decoderFile = "";
  String postnetFile = "";
  String waveglowFile = "";
  String? sslFile;

  String? dicFolderOpenJtalk;
  String? dicFolderG2PEn;

  int _downloadCnt = 0;
  List<String> modelList = List<String>.empty(growable: true);

  // int modelType = TextToSpeech.MODEL_TYPE_TACOTRON2;
  // int modelType = TextToSpeech.MODEL_TYPE_GPT_SOVITS_JA;

  int modelType = TextToSpeech.MODEL_TYPE_GPT_SOVITS_EN;

  // voice
  var voices = List<String>.empty(growable: true);
  var voiceValue = "";

  // models
  var models = List<String>.empty(growable: true);
  var modelValue = "";

  @override
  void initState() {
    super.initState();

    _ailiaVoiceDownloadModel();

    // init voices
    voices = _textToSpeech.getVoicesList(modelType);
    voiceValue = voices.first;

    models = _textToSpeech.getModels();
    modelValue = models.first;
  }

  @override
  void dispose() {
    _textToSpeech.destroy();
    super.dispose();
  }

  Future<String> loadString() async =>
      await rootBundle.loadString('assets/voices.txt');

  void _ailiaVoiceDownloadModel() {
    modelList = _textToSpeech.getModelList(modelType);
    _ailiaVoiceDownloadModelOne();
  }

  void _ailiaVoiceDownloadModelOne() {
    String url =
        "https://storage.googleapis.com/ailia-models/${modelList[_downloadCnt + 0]}/${modelList[_downloadCnt + 1]}";
    setState(() {
      _predictText = "downloading: $url";
    });
    downloadModel(url, modelList[_downloadCnt + 1], (file) {
      _downloadCnt = _downloadCnt + 2;
      if (_downloadCnt >= modelList.length) {
        _ailiaVoiceTest();
      } else {
        _ailiaVoiceDownloadModelOne();
      }
    });
  }

  void _ailiaVoiceTest() async {
    // Check and download ailia SDK license
    await AiliaLicense.checkAndDownloadLicense();

    if (modelType == TextToSpeech.MODEL_TYPE_TACOTRON2) {
      encoderFile = await getModelPath("encoder.onnx");
      decoderFile = await getModelPath("decoder_iter.onnx");
      postnetFile = await getModelPath("postnet.onnx");
      waveglowFile = await getModelPath("waveglow.onnx");
    }

    if (modelType == TextToSpeech.MODEL_TYPE_GPT_SOVITS_JA ||
        modelType == TextToSpeech.MODEL_TYPE_GPT_SOVITS_EN) {
      encoderFile = await getModelPath("t2s_encoder.onnx");
      decoderFile = await getModelPath("t2s_fsdec.onnx");
      postnetFile = await getModelPath("t2s_sdec.opt3.onnx");
      waveglowFile = await getModelPath("vits.onnx");
      sslFile = await getModelPath("cnhubert.onnx");
      dicFolderOpenJtalk = await getModelPath("open_jtalk_dic_utf_8-1.11/");
    }

    if (modelType == TextToSpeech.MODEL_TYPE_GPT_SOVITS_EN) {
      dicFolderG2PEn = await getModelPath("/");
    }

    var duration = await _textToSpeech.openModel(
        encoderFile,
        decoderFile,
        postnetFile,
        waveglowFile,
        sslFile,
        dicFolderOpenJtalk,
        dicFolderG2PEn,
        modelType);

    // String targetText = "Hello world.";
    // String outputPath = await getModelPath("temp.wav");
    // await _textToSpeech.inference(targetText, outputPath);

    setState(() {
      _predictText = "Model $modelType Loaded ($duration ms)";
    });
  }

  void tts(String targetText) async {
    try {
      outputPath = await getModelPath("t_$targetText.wav");
      var duration = await _textToSpeech.inference(targetText, outputPath);
      setState(() {
        _predictText = "Process ($duration ms):\n$outputPath";
      });
    } catch (e) {
      print(e);
      setState(() {
        _predictText = "Inference $targetText error: $e";
      });
    }
  }

  void _showDialog(String title, String content) {
    final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ailia Voice Sample'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Model"),
                  const SizedBox(width: 16.0),
                  DropdownMenu<String>(
                    initialSelection: modelValue,
                    onSelected: (String? value) async {
                      // This is called when the user selects an item.
                      try {
                        modelValue = value!;

                        if (modelValue == "GPT_SOVITS_EN") {
                          modelType = TextToSpeech.MODEL_TYPE_GPT_SOVITS_EN;
                          dicFolderG2PEn = await getModelPath("/");
                        }

                        if (modelValue == "GPT_SOVITS_JA") {
                          modelType = TextToSpeech.MODEL_TYPE_GPT_SOVITS_JA;
                          dicFolderG2PEn = null;
                        }

                        var duration = await _textToSpeech.openModel(
                            encoderFile,
                            decoderFile,
                            postnetFile,
                            waveglowFile,
                            sslFile,
                            dicFolderOpenJtalk,
                            dicFolderG2PEn,
                            modelType);

                        voices = _textToSpeech.getVoicesList(modelType);

                        setState(() {
                          voiceValue = voices.first;
                          _predictText =
                              "Load language $modelValue takes $duration ms";
                        });
                      } catch (e) {
                        print(e);
                        setState(() {
                          _predictText = "Load language $modelValue error: $e";
                        });
                      }
                    },
                    dropdownMenuEntries:
                        models.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Voices"),
                  const SizedBox(width: 16.0),
                  DropdownMenu<String>(
                    initialSelection: voiceValue,
                    onSelected: (String? value) async {
                      // This is called when the user selects an item.
                      try {
                        voiceValue = value!;
                        var totalTime =
                            await _textToSpeech.loadVoice(voiceValue);
                        setState(() {
                          _predictText =
                              "Load voice $voiceValue takes $totalTime ms";
                        });
                      } catch (e) {
                        print(e);
                        setState(() {
                          _predictText = "Load voice $voiceValue error: $e";

                          if (modelType ==
                              TextToSpeech.MODEL_TYPE_GPT_SOVITS_EN) {
                            _predictText =
                                "$_predictText\nPLEASE TRY MODEL: GPT_SOVITS_JP";
                            _showDialog(
                                "Error", "Please try with model: GPT_SOVITS_JP");
                          }
                        });
                      }
                    },
                    dropdownMenuEntries:
                        voices.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  TextButton(
                      onPressed: () async {
                        String voiceListDesc =
                            await rootBundle.loadString('assets/voices.txt');
                        print(voiceListDesc);
                        _showDialog("Voices", voiceListDesc);
                      },
                      child: const Text("ℹ️"))
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: TextEditingController()..text = _text,
                onChanged: (text) {
                  // Update your state with the input text here
                  _text = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter text',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your button press logic here
                      setState(() {
                        _predictText = "processing $_text";
                      });

                      tts(_text);
                    },
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Add your button press logic here
                      _textToSpeech.play(outputPath);
                    },
                    child: const Text('Replay'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Share.shareXFiles(
                          [XFile(outputPath)],
                          text: _text);

                      if (result.status == ShareResultStatus.success) {
                        print('Thank you for sharing the picture!');
                      }
                    },
                    child: const Text('Share'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text('$_predictText\n'),
            ],
          ),
        ),
      ),
    );
  }
}
