import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'communicado_platform_interface.dart';

/// An implementation of [CommunicadoPlatform] that uses method channels.
class MethodChannelCommunicado extends CommunicadoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('communicado');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
