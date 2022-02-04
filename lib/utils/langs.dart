enum AppLanguage {
  English,
  French,
  Spanish,
  Portugese,
  PortugeseBR,
  GERMAN,
  ITALIAN,
  ARABIC
}

/// Returns enum value name without enum class name.
String enumName(AppLanguage anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appLanguageData = {
  AppLanguage.English: {"value": "en", "name": "English", "locale": "en_US"},
  AppLanguage.French: {"value": "fr", "name": "French", "locale": "fr_FR"},
  AppLanguage.Spanish: {"value": "es", "name": "Spanish", "locale": "es_ES"},
  AppLanguage.Portugese: {
    "value": "pt",
    "name": "Português",
    "locale": "pt_BR"
  },
  AppLanguage.PortugeseBR: {
    "value": "pt-br",
    "name": "Português do brasil",
    "locale": "pt_BR"
  },
  AppLanguage.GERMAN: {"value": "de", "name": "German", "locale": "de_DE"},
  AppLanguage.ITALIAN: {"value": "it", "name": "Italian", "locale": "it_IT"},
  AppLanguage.ARABIC: {"value": "ar", "name": "Arabic", "locale": "ar_AE"},
};
