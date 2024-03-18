import 'dart:ui';

String detectLanguage({required String string}) {

  String languageCodes = 'en';

  final RegExp persian = RegExp(r'^[\u0600-\u06FF]+');
  final RegExp english = RegExp(r'^[a-zA-Z]+');
  final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');
  final RegExp chinese = RegExp(r'^[\u4E00-\u9FFF]+');
  final RegExp japanese = RegExp(r'^[\u3040-\u30FF]+');
  final RegExp korean = RegExp(r'^[\uAC00-\uD7AF]+');
  final RegExp ukrainian = RegExp(r'^[\u0400-\u04FF\u0500-\u052F]+');
  final RegExp russian = RegExp(r'^[\u0400-\u04FF]+');
  final RegExp italian = RegExp(r'^[\u00C0-\u017F]+');
  final RegExp french = RegExp(r'^[\u00C0-\u017F]+');
  final RegExp spanish = RegExp(r'[\u00C0-\u024F\u1E00-\u1EFF\u2C60-\u2C7F\uA720-\uA7FF\u1D00-\u1D7F]+');

  if (persian.hasMatch(string)) languageCodes = 'fa';
  if (english.hasMatch(string)) languageCodes = 'en';
  if (arabic.hasMatch(string)) languageCodes = 'ar';
  if (chinese.hasMatch(string)) languageCodes = 'zh';
  if (japanese.hasMatch(string)) languageCodes = 'ja';
  if (korean.hasMatch(string)) languageCodes = 'ko';
  if (russian.hasMatch(string)) languageCodes = 'ru';
  if (ukrainian.hasMatch(string)) languageCodes = 'uk';
  if (italian.hasMatch(string)) languageCodes = 'it';
  if (french.hasMatch(string)) languageCodes = 'fr';
  if (spanish.hasMatch(string)) languageCodes = 'es';

  return languageCodes;
}
TextDirection? textDirection(Locale appLocale, String? text) {
  final textLang = detectLanguage(string: text ?? '');
  if (textLang == appLocale.languageCode) return null;
  if (textLang == 'ar' && text != null) return TextDirection.rtl;
  if (textLang == 'en' && text != null) return TextDirection.ltr;
  return null;
}