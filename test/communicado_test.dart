import 'package:flutter_test/flutter_test.dart';
import 'package:communicado/communicado.dart';
import 'package:communicado/communicado_platform_interface.dart';
import 'package:communicado/communicado_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCommunicadoPlatform
    with MockPlatformInterfaceMixin
    implements CommunicadoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CommunicadoPlatform initialPlatform = CommunicadoPlatform.instance;

  test('$MethodChannelCommunicado is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCommunicado>());
  });

  test('getPlatformVersion', () async {
    Communicado communicadoPlugin = Communicado();
    MockCommunicadoPlatform fakePlatform = MockCommunicadoPlatform();
    CommunicadoPlatform.instance = fakePlatform;

    expect(await communicadoPlugin.getPlatformVersion(), '42');
  });
}
