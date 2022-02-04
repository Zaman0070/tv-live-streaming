import '../i18n/strings.g.dart';
import '../utils/StringsUtils.dart';

class Onboarder {
  String image;
  String title;
  String hint;

  static List<Onboarder> getOnboardingItems() {
    List<Onboarder> items = [];
    for (int i = 0; i < t.onboardertitle.length; i++) {
      Onboarder obj = new Onboarder();
      obj.image = StringsUtils.onboarder_image[i];
      obj.title = t.onboardertitle[i];
      obj.hint = t.onboarderhints[i];
      items.add(obj);
    }
    return items;
  }
}
