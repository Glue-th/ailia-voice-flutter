import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ailia_voice/ailia_voice.dart';
import 'package:ailia_voice/ailia_voice_model.dart';
import 'package:ailia/ailia_license.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:wav/wav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'utils/download_model.dart';

import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

Future<Directory> getDocumentsDirectory(String subFolder) async {
  var doc = await getApplicationDocumentsDirectory();
  var basePath = p.join(doc.path, 'ailia MODELS Flutter');
  final docDir = Directory(basePath);
  if (!docDir.existsSync()) {
    docDir.createSync();
  }
  basePath = p.join(basePath, subFolder);
  final subDir = Directory(basePath);
  if (!subDir.existsSync()) {
    subDir.createSync();
  }
  return subDir;
}

Future<String> ailiaCommonGetModelPath(String path) async {
  Directory tempDir = await getDocumentsDirectory("models");
  String tempPath = tempDir.path;
  var filePath = '$tempPath/$path';
  return filePath;
}

class Speaker {
  void play(AiliaTextToSpeechResult audio) async {
    print("pcm length ${audio.pcm.length}");

    Float64List channel = Float64List(audio.pcm.length);
    for (int i = 0; i < channel.length; i++) {
      channel[i] = audio.pcm[i];
    }

    List<Float64List> channels = List<Float64List>.empty(growable: true);
    channels.add(channel);

    Wav wav = Wav(channels, audio.sampleRate, WavFormat.pcm16bit);
    var filename = await ailiaCommonGetModelPath("temp.wav");

    print(filename);

    await wav.writeFile(filename);

    final player = AudioPlayer();
    await player.play(DeviceFileSource(filename));
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _predictText = 'Unknown';
  //final _ailiaVoicePlugin = AiliaVoice();
  final _ailiaVoiceModel = AiliaVoiceModel();
  final _speaker = Speaker();

  @override
  void initState() {
    super.initState();
    _ailiaVoiceDownloadModel();
  }

  int _downloadCnt = 0;
  List<String> modelList = new List<String>.empty(growable: true);
  int modelType = AILIA_VOICE_MODEL_TYPE_TACOTRON2;

  void _ailiaVoiceDownloadModel() {
    modelList.add("open_jtalk");
    modelList.add("char.bin");

    modelList.add("open_jtalk");
    modelList.add("COPYING");

    modelList.add("open_jtalk");
    modelList.add("left-id.def");

    modelList.add("open_jtalk");
    modelList.add("matrix.bin");

    modelList.add("open_jtalk");
    modelList.add("pos-id.def");

    modelList.add("open_jtalk");
    modelList.add("rewrite.def");

    modelList.add("open_jtalk");
    modelList.add("right-id.def");

    modelList.add("open_jtalk");
    modelList.add("sys.dic");

    modelList.add("open_jtalk");
    modelList.add("unk.dic");

    if (modelType == AILIA_VOICE_MODEL_TYPE_TACOTRON2){
      modelList.add("tacotron2");
      modelList.add("nivdia_encoder.onnx");

      modelList.add("tacotron2");
      modelList.add("nivdia_decoder_iter.onnx");

      modelList.add("tacotron2");
      modelList.add("nivdia_postnet.onnx");

      modelList.add("tacotron2");
      modelList.add("nivdia_waveglow.onnx");
    }

    if (modelType == AILIA_VOICE_MODEL_TYPE_GPT_SOVITS){
      modelList.add("gpt-sovits");
      modelList.add("t2s_encoder.onnx");

      modelList.add("gpt-sovits");
      modelList.add("t2s_fsdec.onnx");

      modelList.add("gpt-sovits");
      modelList.add("t2s_sdec.onnx");

      modelList.add("gpt-sovits");
      modelList.add("vits.onnx");

      modelList.add("gpt-sovits");
      modelList.add("cnhubert.onnx");
    }

    _ailiaVoiceDownloadModelOne();
  }

  void _ailiaVoiceDownloadModelOne(){
    downloadModel(
        "https://storage.googleapis.com/ailia-models/${modelList[_downloadCnt*2 + 0]}/${modelList[_downloadCnt*2 + 1]}",
        modelList[_downloadCnt], (file) {
          _downloadCnt = _downloadCnt + 2;
          if (_downloadCnt >= modelList.length){
            _ailiaVoiceTest();
          }else{
            _ailiaVoiceDownloadModelOne();
          }
        }
    );
  }

  void _ailiaVoiceTest() async {
    await AiliaLicense.checkAndDownloadLicense();

    // Load image

    String encoderFile = await ailiaCommonGetModelPath("encoder.onnx");
    String decoderFile = await ailiaCommonGetModelPath("decoder_iter.onnx");
    String postnetFile = await ailiaCommonGetModelPath("postnet.onnx");
    String waveglowFile = await ailiaCommonGetModelPath("waveglow.onnx");
    String? sslFile;

    if (modelType == AILIA_VOICE_MODEL_TYPE_GPT_SOVITS){
      encoderFile = await ailiaCommonGetModelPath("t2s_encoder.onnx");
      decoderFile = await ailiaCommonGetModelPath("t2s_fsdec.onnx");
      postnetFile = await ailiaCommonGetModelPath("t2s_sdec.onnx");
      waveglowFile = await ailiaCommonGetModelPath("vits.onnx");
      sslFile = await ailiaCommonGetModelPath("cnhubert.onnx");
    }

    String dicFolder = await ailiaCommonGetModelPath("");

    _ailiaVoiceModel.open(
      encoderFile,
      decoderFile,
      postnetFile,
      waveglowFile,
      sslFile,
      dicFolder,
      modelType
    );

    String targetText = "Hello world.";

    if (modelType == AILIA_VOICE_MODEL_TYPE_GPT_SOVITS){
      ByteData data = await rootBundle.load("assets/reference_audio_girl.wav");
      final wav = await Wav.read(data.buffer.asUint8List());

        List<double> pcm = List<double>.empty(growable: true);

        for (int i = 0; i < wav.channels[0].length; ++i) {
          for (int j = 0; j < wav.channels.length; ++j){
            pcm.add(wav.channels[j][i]);
          }
        }

        _ailiaVoiceModel.setReference(pcm, wav.samplesPerSecond, wav.channels.length, "水をマレーシアから買わなくてはならない。");
    }

    final audio = _ailiaVoiceModel.textToSpeech(targetText);
    _speaker.play(audio);

    _ailiaVoiceModel.close();

    print("Sueccess");

    setState(() {
      _predictText = "finish";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_predictText\n'),
        ),
      ),
    );
  }
}
