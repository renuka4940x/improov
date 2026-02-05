import 'package:improov/src/data/models/enums/subscription_type.dart';
import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  DateTime? firstLaunchDate;

  //subscription type
  @enumerated
  SubscriptionType subscriptionType = SubscriptionType.none;

  //get subscription type
  bool get isPro => subscriptionType != SubscriptionType.none;
}