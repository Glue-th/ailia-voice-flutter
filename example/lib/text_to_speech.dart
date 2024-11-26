import 'package:ailia_voice/ailia_voice.dart' as ailia_voice_dart;
import 'package:ailia_voice/ailia_voice_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wav/wav.dart';

import 'package:flutter/services.dart';

import 'dart:typed_data';

class Speaker {
  void play(AiliaVoiceResult audio, String outputPath) async {
    Float64List channel = Float64List(audio.pcm.length);
    for (int i = 0; i < channel.length; i++) {
      channel[i] = audio.pcm[i];
    }

    List<Float64List> channels = List<Float64List>.empty(growable: true);
    channels.add(channel);

    Wav wav = Wav(channels, audio.sampleRate, WavFormat.pcm16bit);

    await wav.writeFile(outputPath);

    final player = AudioPlayer();
    await player.play(DeviceFileSource(outputPath));
  }

  void playOnly(String outputPath) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(outputPath));
  }
}

class TextToSpeech {
  final _speaker = Speaker();
  AiliaVoiceModel? _ailiaVoiceModel = AiliaVoiceModel();

  static const int MODEL_TYPE_TACOTRON2 = 0;
  static const int MODEL_TYPE_GPT_SOVITS_JA = 1;
  static const int MODEL_TYPE_GPT_SOVITS_EN = 2;

  int modelType = -1;

  init() {}

  destroy() {
    // Terminate
    _ailiaVoiceModel?.close();
    _ailiaVoiceModel = null;
  }

  List<String> getVoicesList(int modelType) {
    List<String> voiceList = List<String>.empty(growable: true);

    voiceList.add("taylor swift (2s)");
    voiceList.add("taylor swift (4s)");
    voiceList.add("taylor swift (15s)");
    voiceList.add("trump (3s)");
    voiceList.add("trump (9s)");
    voiceList.add("ken");
    voiceList.add("japan girl");
    voiceList.add("ano (1)");
    voiceList.add("ano (2)");
    voiceList.add("boy11 (1)");
    voiceList.add("boy11 (2)");
    voiceList.add("ega (1)");
    voiceList.add("ega (2)");
    voiceList.add("hotta (1)");
    voiceList.add("hotta (2)");
    voiceList.add("kaz (1)");
    voiceList.add("kaz (2)");
    voiceList.add("man17 (1)");
    voiceList.add("man17 (2)");
    voiceList.add("man18 (1)");
    voiceList.add("man18 (2)");
    voiceList.add("sana (1)");
    voiceList.add("sana (2)");
    voiceList.add("woman1 (1)");
    voiceList.add("woman1 (2)");
    voiceList.add("woman2 (1)");
    voiceList.add("woman2 (2)");
    voiceList.add("woman3 (1)");
    voiceList.add("woman3 (2)");
    voiceList.add("woman10 (1)");
    voiceList.add("woman10 (2)");
    voiceList.add("woman15");
    voiceList.add("woman17 (1)");
    voiceList.add("woman17 (2)");
    voiceList.add("woman23");

    return voiceList;
  }

  List<String> getModels() {
    List<String> modelList = List<String>.empty(growable: true);

    modelList.add("GPT_SOVITS_EN");
    modelList.add("GPT_SOVITS_JA");

    return modelList;
  }

  List<String> getModelList(int modelType) {
    List<String> modelList = List<String>.empty(growable: true);

    if (modelType == MODEL_TYPE_GPT_SOVITS_JA ||
        modelType == MODEL_TYPE_GPT_SOVITS_EN) {
      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/char.bin");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/COPYING");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/left-id.def");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/matrix.bin");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/pos-id.def");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/rewrite.def");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/right-id.def");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/sys.dic");

      modelList.add("open_jtalk");
      modelList.add("open_jtalk_dic_utf_8-1.11/unk.dic");
    }

    if (modelType == MODEL_TYPE_GPT_SOVITS_EN) {
      modelList.add("g2p_en");
      modelList.add("averaged_perceptron_tagger_classes.txt");

      modelList.add("g2p_en");
      modelList.add("averaged_perceptron_tagger_tagdict.txt");

      modelList.add("g2p_en");
      modelList.add("averaged_perceptron_tagger_weights.txt");

      modelList.add("g2p_en");
      modelList.add("cmudict");

      modelList.add("g2p_en");
      modelList.add("g2p_decoder.onnx");

      modelList.add("g2p_en");
      modelList.add("g2p_encoder.onnx");

      modelList.add("g2p_en");
      modelList.add("homographs.en");
    }

    if (modelType == ailia_voice_dart.AILIA_VOICE_MODEL_TYPE_TACOTRON2 ||
        modelType == MODEL_TYPE_TACOTRON2) {
      modelList.add("tacotron2");
      modelList.add("encoder.onnx");

      modelList.add("tacotron2");
      modelList.add("decoder_iter.onnx");

      modelList.add("tacotron2");
      modelList.add("postnet.onnx");

      modelList.add("tacotron2");
      modelList.add("waveglow.onnx");
    }

    if (modelType == ailia_voice_dart.AILIA_VOICE_MODEL_TYPE_GPT_SOVITS ||
        modelType == MODEL_TYPE_GPT_SOVITS_EN) {
      modelList.add("gpt-sovits");
      modelList.add("t2s_encoder.onnx");

      modelList.add("gpt-sovits");
      modelList.add("t2s_fsdec.onnx");

      modelList.add("gpt-sovits");
      modelList.add("t2s_sdec.opt3.onnx");

      modelList.add("gpt-sovits");
      modelList.add("vits.onnx");

      modelList.add("gpt-sovits");
      modelList.add("cnhubert.onnx");
    }

    return modelList;
  }

  Future<int> openModel(
      String encoderFile,
      String decoderFile,
      String postnetFile,
      String waveglowFile,
      String? sslFile,
      String? dicFolderOpenJtalk,
      String? dicFolderG2PEn,
      int modelType) async {
    // Open and Inference
    var startTime = DateTime.now().millisecondsSinceEpoch;
    this.modelType = modelType;
    _ailiaVoiceModel!.openModel(
        encoderFile,
        decoderFile,
        postnetFile,
        waveglowFile,
        sslFile,
        (modelType == MODEL_TYPE_TACOTRON2)
            ? ailia_voice_dart.AILIA_VOICE_MODEL_TYPE_TACOTRON2
            : ailia_voice_dart.AILIA_VOICE_MODEL_TYPE_GPT_SOVITS,
        ailia_voice_dart.AILIA_VOICE_CLEANER_TYPE_BASIC,
        ailia_voice_dart.AILIA_ENVIRONMENT_ID_AUTO);
    if (dicFolderOpenJtalk != null) {
      _ailiaVoiceModel!.openDictionary(dicFolderOpenJtalk,
          ailia_voice_dart.AILIA_VOICE_DICTIONARY_TYPE_OPEN_JTALK);
    }
    if (dicFolderG2PEn != null) {
      _ailiaVoiceModel!.openDictionary(
          dicFolderG2PEn, ailia_voice_dart.AILIA_VOICE_DICTIONARY_TYPE_G2P_EN);
    }

    await this.loadVoice(getVoicesList(this.modelType).first);

    var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
    print("Load model take $totalTime ms");
    print(
        "If error code != 0, see here: https://github.com/axinc-ai/ailia-voice-flutter/blob/4f7f3866bccaccba45b81d3005795f078276a230/lib/ailia_voice.dart");
    return totalTime;
  }

  Future<int> loadVoice(String voice) async {
    var startTime = DateTime.now().millisecondsSinceEpoch;
    print("Loading voice $voice");
    if (modelType == MODEL_TYPE_GPT_SOVITS_JA ||
        modelType == MODEL_TYPE_GPT_SOVITS_EN) {
      // Japan girl
      var referenceText = "水をマレーシアから買わなくてはならない。";
      var referenceFile = "assets/reference_audio_girl.wav";

      if (voice == "ken") {
        referenceText = "Inference This is an album";
        referenceFile = "assets/ken.wav";
      }

      if (voice == "taylor swift (2s)") {
        referenceText = "This is a pretty dark album";
        referenceFile = "assets/taylor_2s.wav";
      }

      if (voice == "taylor swift (4s)") {
        referenceText = "If I had a really joyful experience making something. This is a pretty dark album";
        referenceFile = "assets/taylor_4s.wav";
      }

      if (voice == "taylor swift (15s)") {
        referenceText = "is just as important as how proud you are of it in the end. And I think it really informs how proud I am of something. If I had a really joyful experience making something. This is a pretty dark album, but I'd say I had more fun making it than any album I I.";
        referenceFile = "assets/taylor_15s.wav";
      }

      if (voice == "trump (9s)") {
        referenceText = "26 people that said that never happened. Who would say it? Who would say it? Nobody would say it. Stupid person or a person that's mentally";
        referenceFile = "assets/trump_9s.wav";
      }

      if (voice == "trump (3s)") {
        referenceText = "26 people that said that never happened.";
        referenceFile = "assets/trump_3s.wav";
      }

      if (voice == "japan girl") {
        referenceText = "水をマレーシアから買わなくてはならない。";
        referenceFile = "assets/reference_audio_girl.wav";
      }

      if (voice == "ano (1)") {
        referenceText = "ました、あのです。よろしゅうおねがいいたします";
        referenceFile = "assets/ano.wav";
      }

      if (voice == "ano (2)") {
        referenceText = "ました、あのです。よろしゅうお願い致します";
        referenceFile = "assets/ano.wav";
      }

      if (voice == "boy11 (1)") {
        referenceText = "ま、よろしくね！";
        referenceFile = "assets/boy11.wav";
      }

      if (voice == "boy11 (2)") {
        referenceText = "ま、宜しくね！";
        referenceFile = "assets/boy11.wav";
      }

      if (voice == "ega (1)") {
        referenceText = "この、どうがをとってる、きょう";
        referenceFile = "assets/ega.wav";
      }

      if (voice == "ega (2)") {
        referenceText = "この、動画をとってる、今日";
        referenceFile = "assets/ega.wav";
      }

      if (voice == "hotta (1)") {
        referenceText = "だいじょうぶだけどこれちょっと、じかんが";
        referenceFile = "assets/hotta.wav";
      }

      if (voice == "hotta (2)") {
        referenceText = "大丈夫だけどこれちょっと、時間が";
        referenceFile = "assets/hotta.wav";
      }

      if (voice == "kaz (1)") {
        referenceText = "じゃあここは、はいじょするでいいですよね";
        referenceFile = "assets/kaz.wav";
      }

      if (voice == "kaz (2)") {
        referenceText = "じゃあここは、排除するでいいですよね";
        referenceFile = "assets/kaz.wav";
      }

      if (voice == "man17 (1)") {
        referenceText = "よろしくたのむ";
        referenceFile = "assets/man17.wav";
      }

      if (voice == "man17 (2)") {
        referenceText = "宜しく頼む";
        referenceFile = "assets/man17.wav";
      }

      if (voice == "man18 (1)") {
        referenceText = "よろしくおねがいします";
        referenceFile = "assets/man18.wav";
      }

      if (voice == "man18 (2)") {
        referenceText = "宜しくお願いします";
        referenceFile = "assets/man18.wav";
      }

      if (voice == "sana (1)") {
        referenceText = "はるということで、ぜんしょく、ぜひつかって";
        referenceFile = "assets/sana.wav";
      }

      if (voice == "sana (2)") {
        referenceText = "春ということで、全色、是非使って";
        referenceFile = "assets/sana.wav";
      }

      if (voice == "woman1 (1)") {
        referenceText = "がんばったね";
        referenceFile = "assets/woman1.wav";
      }

      if (voice == "woman1 (2)") {
        referenceText = "頑張ったね";
        referenceFile = "assets/woman1.wav";
      }

      if (voice == "woman2 (1)") {
        referenceText = "じゅんびは、いいですか";
        referenceFile = "assets/woman2.wav";
      }

      if (voice == "woman2 (2)") {
        referenceText = "準備は、いいですか";
        referenceFile = "assets/woman2.wav";
      }

      if (voice == "woman3 (1)") {
        referenceText = "ごちそうさまでした";
        referenceFile = "assets/woman3.wav";
      }

      if (voice == "woman3 (2)") {
        referenceText = "ごちそう様でした";
        referenceFile = "assets/woman3.wav";
      }

      if (voice == "woman10 (1)") {
        referenceText = "よろしくたのむぞ";
        referenceFile = "assets/woman10.wav";
      }

      if (voice == "woman10 (2)") {
        referenceText = "宜しく頼むぞ";
        referenceFile = "assets/woman10.wav";
      }

      if (voice == "woman15") {
        referenceText = "やりました！";
        referenceFile = "assets/woman15.wav";
      }

      if (voice == "woman17 (1)") {
        referenceText = "よろしくおねがいね";
        referenceFile = "assets/woman17.wav";
      }

      if (voice == "woman17 (2)") {
        referenceText = "宜しくお願いね";
        referenceFile = "assets/woman17.wav";
      }

      if (voice == "woman23") {
        referenceText = "これでどう？";
        referenceFile = "assets/woman23.wav";
      }

      print("Reference $referenceFile");

      ByteData data = await rootBundle.load(referenceFile);
      final wav = Wav.read(data.buffer.asUint8List());

      List<double> pcm = List<double>.empty(growable: true);

      for (int i = 0; i < wav.channels[0].length; ++i) {
        // print("add channel $i")
        for (int j = 0; j < wav.channels.length; ++j) {
          pcm.add(wav.channels[j][i]);
        }
      }

      String referenceFeature = _ailiaVoiceModel!.g2p(
          referenceText,
          modelType == MODEL_TYPE_GPT_SOVITS_JA
              ? ailia_voice_dart.AILIA_VOICE_G2P_TYPE_GPT_SOVITS_JA
              : ailia_voice_dart.AILIA_VOICE_G2P_TYPE_GPT_SOVITS_EN);
      _ailiaVoiceModel!.setReference(
          pcm, wav.samplesPerSecond, wav.channels.length, referenceFeature);
    }
    var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
    print("Load voice $voice takes $totalTime ms");
    return totalTime;
  }

  Future<int> inference(String targetText, String outputPath) async {
    // Get Audio and Play
    var startTime = DateTime.now().millisecondsSinceEpoch;
    String targetFeature = targetText;
    if (modelType == MODEL_TYPE_GPT_SOVITS_JA) {
      targetFeature = _ailiaVoiceModel!
          .g2p(targetText, ailia_voice_dart.AILIA_VOICE_G2P_TYPE_GPT_SOVITS_JA);
    }
    if (modelType == MODEL_TYPE_GPT_SOVITS_EN) {
      targetFeature = _ailiaVoiceModel!
          .g2p(targetText, ailia_voice_dart.AILIA_VOICE_G2P_TYPE_GPT_SOVITS_EN);
    }

    final audio = _ailiaVoiceModel!.inference(targetFeature);
    _speaker.play(audio, outputPath);
    var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
    print("Inference $targetText takes $totalTime ms");
    return totalTime;
  }

  void play(String outputPath) {
    _speaker.playOnly(outputPath);
  }
}
