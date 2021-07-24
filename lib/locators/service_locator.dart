import 'package:get_it/get_it.dart';
import 'package:phonnytunes_application/services/call_sms.dart';

GetIt locator = GetIt.instance;

void clientsetupLocator() {
  locator.registerSingleton(CallsAndMessagesService());
}
