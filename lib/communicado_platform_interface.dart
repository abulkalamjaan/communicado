import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'communicado_method_channel.dart';

abstract class CommunicadoPlatform extends PlatformInterface {
  /// Constructs a CommunicadoPlatform.
  CommunicadoPlatform() : super(token: _token);

  static final Object _token = Object();

  static CommunicadoPlatform _instance = MethodChannelCommunicado();

  /// The default instance of [CommunicadoPlatform] to use.
  ///
  /// Defaults to [MethodChannelCommunicado].
  static CommunicadoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CommunicadoPlatform] when
  /// they register themselves.
  static set instance(CommunicadoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
