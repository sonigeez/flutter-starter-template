// ignore_for_file: constant_identifier_names

enum Flavor {
  patrika_community,
  patrika_community_dev,
  patrika_support,
  patrika_support_dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.patrika_community:
        return 'Patrika Community App';
      case Flavor.patrika_community_dev:
        return 'Patrika Community App - Dev';
      case Flavor.patrika_support:
        return 'Patrika Support App';
      case Flavor.patrika_support_dev:
        return 'Patrika Support App - Dev';
      case null:
        return 'title';
    }
  }
}
