//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ailia/ailia_plugin.h>
#include <ailia_audio/ailia_audio_plugin.h>
#include <ailia_voice/ailia_voice_plugin.h>
#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ailia_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AiliaPlugin");
  ailia_plugin_register_with_registrar(ailia_registrar);
  g_autoptr(FlPluginRegistrar) ailia_audio_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AiliaAudioPlugin");
  ailia_audio_plugin_register_with_registrar(ailia_audio_registrar);
  g_autoptr(FlPluginRegistrar) ailia_voice_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AiliaVoicePlugin");
  ailia_voice_plugin_register_with_registrar(ailia_voice_registrar);
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
