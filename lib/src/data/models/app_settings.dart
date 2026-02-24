import 'package:improov/src/data/enums/subscription_type.dart';
import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0;

  DateTime? firstLaunchDate;

  //name
  String? nickname;

  //theme
  bool isDarkMode = false;

  //subscription type
  @enumerated
  SubscriptionType subscriptionType = SubscriptionType.none;

  //get subscription type
  bool get isPro => subscriptionType != SubscriptionType.none;
}