
// Generated file. Do not edit.

import 'package:flutter/foundation.dart';
import 'package:fast_i18n/fast_i18n.dart';

const String _baseLocale = 'en';
String _locale = _baseLocale;
Map<String, Strings> _strings = {
	'ar': StringsAr.instance,
	'de': StringsDe.instance,
	'en': Strings.instance,
	'es': StringsEs.instance,
	'fr': StringsFr.instance,
	'it': StringsIt.instance,
	'pt': StringsPt.instance,
	'pt-br': StringsPtbr.instance,
};

/// use this to get your translations, e.g. t.someKey.anotherKey
Strings get t {
	return _strings[_locale];
}

class LocaleSettings {

	/// use the locale of the device, fallback to default locale
	static Future<void> useDeviceLocale() async {
		_locale = await FastI18n.findDeviceLocale(_strings.keys.toList(), _baseLocale);
	}

	/// set the locale, fallback to default locale
	static void setLocale(String locale) {
		_locale = FastI18n.selectLocale(locale, _strings.keys.toList(), _baseLocale);
	}

	/// get the current locale
	static String get currentLocale {
		return _locale;
	}

	/// get the base locale
	static String get baseLocale {
		return _baseLocale;
	}

	/// get the supported locales
	static List<String> get locales {
		return _strings.keys.toList();
	}
}

class StringsAr extends Strings {
	static StringsAr _instance = StringsAr();
	static StringsAr get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'جارٍ تهيئة التطبيق...';
	@override String get choosecategories => 'اختر الفئات';
	@override String get selectcategory => 'اختر الفئة';
	@override String get fetchingcategories => 'جلب الفئات';
	@override String get selectlanguage => 'اختار اللغة';
	@override String get chooseapplanguage => 'اختر لغة التطبيق';
	@override String get articles => 'مقالات';
	@override String get weather => 'تقارير الطقس';
	@override String get errorfetchingcategories => 'تعذر تحميل الفئات انقر لإعادة المحاولة';
	@override String get selectcategorieshint => 'يجب عليك تحديد فئة واحدة على الأقل قبل أن تتمكن من المتابعة.';
	@override String get allstories => 'كل القصص';
	@override String get searchhint => 'مقالات البحث';
	@override String get articlesloaderrormsg => 'لا يوجد عنصر للعرض ، اسحب لإعادة المحاولة';
	@override String get nobookmarkedarticles => 'لا توجد مقالات مرجعية';
	@override String get performingsearch => 'البحث في المقالات';
	@override String get nosearchresult => 'لم يتم العثور على نتائج';
	@override String get nosearchresulthint => 'حاول إدخال كلمة رئيسية أكثر عمومية';
	@override String get comments => 'تعليقات';
	@override String get logintoaddcomment => 'تسجيل الدخول لإضافة تعليق';
	@override String get writeamessage => 'اكتب رسالة...';
	@override String get nocomments => 'لا توجد تعليقات انقر لإعادة المحاولة';
	@override String get errormakingcomments => 'لا يمكن معالجة التعليق في الوقت الحالي..';
	@override String get errordeletingcomments => 'لا يمكن حذف هذا التعليق في الوقت الحالي..';
	@override String get erroreditingcomments => 'لا يمكن تعديل هذا التعليق في الوقت الحالي..';
	@override String get errorloadingmorecomments => 'لا يمكن تحميل المزيد من التعليقات في الوقت الحالي..';
	@override String get deletingcomment => 'حذف التعليق';
	@override String get editingcomment => 'تحرير التعليق';
	@override String get deletecommentalert => 'حذف تعليق';
	@override String get editcommentalert => 'تعديل التعليق';
	@override String get deletecommentalerttext => 'هل ترغب في حذف هذا التعليق؟ لا يمكن التراجع عن هذا الإجراء';
	@override String get loadmore => 'تحميل المزيد';
	@override String get errorloadingarticlecontent => 'لا يمكن تحميل محتوى المقالة انقر لإعادة المحاولة';
	@override String get guestuser => 'حساب زائر';
	@override String get username => 'اسم المستخدم';
	@override String get fullname => 'الاسم بالكامل';
	@override String get emailaddress => 'عنوان البريد الالكترونى';
	@override String get password => 'كلمه السر';
	@override String get repeatpassword => 'اعد كلمة السر';
	@override String get register => 'تسجيل';
	@override String get login => 'تسجيل الدخول';
	@override String get logout => 'تسجيل خروج';
	@override String get logoutfromapp => 'تسجيل الخروج من التطبيق?';
	@override String get logoutfromapphint => 'لن تتمكن من إبداء الإعجاب بالمقالات ومقاطع الفيديو أو التعليق عليها إذا لم تقم بتسجيل الدخول.';
	@override String get gotologin => 'اذهب إلى تسجيل الدخول';
	@override String get resetpassword => 'إعادة تعيين كلمة المرور';
	@override String get logintoaccount => 'هل لديك حساب؟ تسجيل الدخول';
	@override String get emptyfielderrorhint => 'تحتاج إلى ملء جميع الحقول';
	@override String get invalidemailerrorhint => 'تحتاج إلى إدخال عنوان بريد إلكتروني صالح';
	@override String get passwordsdontmatch => 'كلمات المرور لا تتطابق';
	@override String get processingpleasewait => 'يتم المعالجة .. الرجاء الانتظار...';
	@override String get createaccount => 'انشئ حساب';
	@override String get categories => 'التصنيفات';
	@override String get about => 'معلومات عنا';
	@override String get privacy => 'سياسة الخصوصية';
	@override String get terms => 'شروط التطبيق';
	@override String get rate => 'قيمنا';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'النشرة الجوية';
	@override String get windspeed => 'سرعة الرياح';
	@override String get sunrise => 'شروق الشمس';
	@override String get sunset => 'غروب الشمس';
	@override String get humidity => 'رطوبة';
	@override String get oneweekforecast => 'توقعات أسبوع واحد';
	@override String get fetchweatherforecasterror => 'حدث خطأ أثناء جلب بيانات الطقس';
	@override String get retryfetch => 'حاول مرة أخري';
	@override String get changecity => 'تغيير المدينة';
	@override String get nameofcity => 'اسم مدينتك';
	@override String get locationdenied => 'الموقع مرفوض!!';
	@override String get locationdisabled => 'الموقع معطل ، انتقل إلى الإعدادات وقم بتمكينه. ثم اضغط على أيقونة الموقع في شريط التطبيقات للمحاولة مرة أخرى.';
	@override String get enable => 'ممكن';
	@override String get pulluploadmore => 'سحب ما يصل الحمل';
	@override String get loadfailedretry => 'فشل التحميل! انقر فوق إعادة المحاولة!';
	@override String get releaseloadmore => 'الافراج لتحميل المزيد';
	@override String get nomoredata => 'لا مزيد من البيانات';
	@override String get appsettings => 'إعدادات التطبيقات';
	@override String get setupprefernces => 'قم بإعداد تفضيلاتك';
	@override String get receievepshnotifications => 'تلقي الإخطارات';
	@override String get nightmode => 'وضع الليل';
	@override String get showarticleimages => 'عرض الصور';
	@override String get showsmallarticleimages => 'عرض الصور الصغيرة';
	@override String get enablertl => 'ممكن RTL';
	@override String get ok => 'حسنا';
	@override String get oops => 'عفوًا!';
	@override String get save => 'حفظ';
	@override String get cancel => 'إلغاء';
	@override String get error => 'خطأ';
	@override String get retry => 'أعد المحاولة';
	@override String get success => 'نجاح';
	@override String get skiplogin => 'تخطي تسجيل الدخول';
	@override String get skipregister => 'تخطي تسجيل';
	@override String get dataloaderror => 'تعذر تحميل البيانات المطلوبة في الوقت الحالي ، تحقق من اتصال البيانات وانقر لإعادة المحاولة.';
	@override String get next => 'التالى';
	@override String get done => 'فهمتك';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'الأخبار والفيديو',
		'الراديو والطقس',
		'اكثر بكثير',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'المنشورات ذات الصلة';
	@override String get bookmarksnav => 'متجر كتبي';
	@override String get errorprocessingrequest => 'لا يمكن معالجة الطلب في الوقت الحالي ، يرجى المحاولة مرة أخرى.';
	@override String get errorReportingComment => 'الإبلاغ عن خطأ التعليق';
	@override String get reportingComment => 'الإبلاغ عن التعليق';
	@override List<String> get reportCommentsList => [
		'المحتوى التجاري غير المرغوب فيه أو البريد العشوائي',
		'مواد إباحية أو مواد جنسية صريحة',
		'كلام يحض على الكراهية أو عنف تصويري',
		'المضايقة أو التنمر',
	];
	@override String get articlesnav => 'مقالات';
	@override String get videosnav => 'أشرطة فيديو';
	@override String get radionav => 'مذياع';
	@override String get livetvnav => 'بث تلفزيوني مباشر';
	@override String get orloginwith => 'أو تسجيل الدخول باستخدام';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'قم بتسجيل الدخول باستخدام apple';
	@override String get logintoreply => 'تسجيل الدخول إلى إجابة';
	@override String get forgotpassword => 'هل نسيت كلمة المرور؟?';
	@override String get nobookmarkedvideos => 'لا توجد مقاطع فيديو مرجعية';
	@override String get replies => 'الردود';
	@override String get reply => 'الرد';
	@override String get livetvPlaylists => 'قوائم تشغيل LiveTV';
	@override String get emptyplaylist => 'لا توجد قوائم تشغيل';
	@override String get reportcomment => 'خيارات التقرير';
	@override String get feedsources => 'مصدر الخلاصات';
	@override String get follow => 'إتبع';
	@override String get unfollow => 'الغاء المتابعة';
}

class StringsDe extends Strings {
	static StringsDe _instance = StringsDe();
	static StringsDe get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'App initialisieren...';
	@override String get selectlanguage => 'Sprache auswählen';
	@override String get chooseapplanguage => 'Wählen Sie App Language';
	@override String get choosecategories => 'Wählen Sie Kategorien';
	@override String get selectcategory => 'Kategorie wählen';
	@override String get fetchingcategories => 'Kategorien abrufen';
	@override String get articles => 'Artikel';
	@override String get weather => 'Wetterberichte';
	@override String get errorfetchingcategories => 'Kategorien konnten nicht geladen werden \nKlicken Sie, um es erneut zu versuchen';
	@override String get selectcategorieshint => 'Sie müssen mindestens eine Kategorie auswählen, bevor Sie fortfahren können.';
	@override String get allstories => 'Alle Geschichten';
	@override String get searchhint => 'Artikel suchen';
	@override String get articlesloaderrormsg => 'Kein Element zum Anzeigen, \nZum Wiederholen ziehen';
	@override String get nobookmarkedarticles => 'Keine mit Lesezeichen versehenen Artikel';
	@override String get performingsearch => 'Artikel suchen';
	@override String get nosearchresult => 'Keine Ergebnisse gefunden';
	@override String get nosearchresulthint => 'Versuchen Sie, ein allgemeineres Schlüsselwort einzugeben';
	@override String get comments => 'Bemerkungen';
	@override String get logintoaddcomment => 'Melden Sie sich an, um einen Kommentar hinzuzufügen';
	@override String get writeamessage => 'Eine Nachricht schreiben...';
	@override String get nocomments => 'Keine Kommentare gefunden \nKlicken Sie, um es erneut zu versuchen';
	@override String get errormakingcomments => 'Kommentare können derzeit nicht verarbeitet werden..';
	@override String get errordeletingcomments => 'Dieser Kommentar kann momentan nicht gelöscht werden..';
	@override String get erroreditingcomments => 'Dieser Kommentar kann momentan nicht bearbeitet werden..';
	@override String get errorloadingmorecomments => 'Derzeit können keine weiteren Kommentare geladen werden..';
	@override String get deletingcomment => 'Kommentar löschen';
	@override String get editingcomment => 'Kommentar bearbeiten';
	@override String get deletecommentalert => 'Kommentar löschen';
	@override String get editcommentalert => 'Kommentar bearbeiten';
	@override String get deletecommentalerttext => 'Möchten Sie diesen Kommentar löschen? Diese Aktion kann nicht rückgängig gemacht werden';
	@override String get loadmore => 'Mehr laden';
	@override String get errorloadingarticlecontent => 'Artikelinhalt konnte nicht geladen werden \nKlicken Sie, um es erneut zu versuchen';
	@override String get guestuser => 'Gastbenutzer';
	@override String get username => 'Nutzername';
	@override String get fullname => 'Vollständiger Name';
	@override String get emailaddress => 'E-Mail-Addresse';
	@override String get password => 'Passwort';
	@override String get repeatpassword => 'Wiederhole das Passwort';
	@override String get register => 'Registrieren';
	@override String get login => 'Anmeldung';
	@override String get logout => 'Ausloggen';
	@override String get logoutfromapp => 'Abmelden von der App?';
	@override String get logoutfromapphint => 'Sie können Artikel und Videos nicht mögen oder kommentieren, wenn Sie nicht angemeldet sind.';
	@override String get gotologin => 'Gehen Sie zu Login';
	@override String get resetpassword => 'Passwort zurücksetzen';
	@override String get logintoaccount => 'Sie haben bereits ein Konto? Anmeldung';
	@override String get emptyfielderrorhint => 'Sie müssen alle Felder ausfüllen';
	@override String get invalidemailerrorhint => 'Sie müssen eine gültige E-Mail-Adresse eingeben';
	@override String get passwordsdontmatch => 'Passwörter stimmen nicht überein';
	@override String get processingpleasewait => 'Verarbeite .. Bitte warten...';
	@override String get createaccount => 'Ein Konto erstellen';
	@override String get categories => 'Kategorien';
	@override String get about => 'Über uns';
	@override String get privacy => 'Datenschutz-Bestimmungen';
	@override String get terms => 'App-Bedingungen';
	@override String get rate => 'Bewerten Sie uns';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Wettervorhersage';
	@override String get windspeed => 'Windgeschwindigkeit';
	@override String get sunrise => 'Sonnenaufgang';
	@override String get sunset => 'Sonnenuntergang';
	@override String get humidity => 'Feuchtigkeit';
	@override String get oneweekforecast => 'Eine Woche Prognose';
	@override String get fetchweatherforecasterror => 'Beim Abrufen der Wetterdaten ist ein Fehler aufgetreten';
	@override String get retryfetch => 'Versuchen Sie es nochmal';
	@override String get changecity => 'Stadt wechseln';
	@override String get nameofcity => 'Name Ihrer Stadt';
	@override String get locationdenied => 'Standort wird verweigert!!';
	@override String get locationdisabled => 'Standort ist deaktiviert. Gehen Sie zu Einstellungen und aktivieren Sie sie. Tippen Sie anschließend auf das Standortsymbol in der App-Leiste, um es erneut zu versuchen.';
	@override String get enable => 'Aktivieren';
	@override String get pulluploadmore => 'Last hochziehen';
	@override String get loadfailedretry => 'Laden fehlgeschlagen! Klicken Sie auf Wiederholen!';
	@override String get releaseloadmore => 'loslassen, um mehr zu laden';
	@override String get nomoredata => 'Keine Daten mehr';
	@override String get appsettings => 'App Einstellungen';
	@override String get setupprefernces => 'Richten Sie Ihre Einstellungen ein';
	@override String get receievepshnotifications => 'Benachrichtigungen erhalten';
	@override String get nightmode => 'Nacht-Modus';
	@override String get showarticleimages => 'Bilder anzeigen';
	@override String get showsmallarticleimages => 'Kleine Bilder anzeigen';
	@override String get enablertl => 'Aktivieren RTL';
	@override String get ok => 'In Ordnung';
	@override String get oops => 'Hoppla!';
	@override String get save => 'sparen';
	@override String get cancel => 'Stornieren';
	@override String get error => 'Error';
	@override String get retry => 'WIEDERHOLEN';
	@override String get success => 'Erfolg';
	@override String get skiplogin => 'Login überspringen';
	@override String get skipregister => 'Registrierung überspringen';
	@override String get dataloaderror => 'Die angeforderten Daten konnten momentan nicht geladen werden. Überprüfen Sie Ihre Datenverbindung und klicken Sie, um es erneut zu versuchen.';
	@override String get next => 'NÄCHSTER';
	@override String get done => 'ICH HABS';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'zusammenhängende Posts';
	@override String get bookmarksnav => 'Lesezeichen';
	@override String get errorprocessingrequest => 'Die Anfrage kann momentan nicht bearbeitet werden. Bitte versuchen Sie es erneut.';
	@override String get errorReportingComment => 'Kommentar zur Fehlerberichterstattung';
	@override String get reportingComment => 'Kommentar melden';
	@override List<String> get reportCommentsList => [
		'Unerwünschte kommerzielle Inhalte oder Spam',
		'Pornografie oder sexuelles explizites Material',
		'Hassreden oder grafische Gewalt',
		'Belästigung oder Mobbing',
	];
	@override String get articlesnav => 'Artikel';
	@override String get videosnav => 'Videos';
	@override String get radionav => 'Radio';
	@override String get livetvnav => 'Live Fernsehen';
	@override String get orloginwith => 'Oder Login mit';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Melden Sie sich mit an apple';
	@override String get logintoreply => 'Anmelden um zu Antworten';
	@override String get forgotpassword => 'Forgot Password?';
	@override String get nobookmarkedvideos => 'Keine mit Lesezeichen versehenen Videos';
	@override String get replies => 'Antworten';
	@override String get reply => 'Antworten';
	@override String get livetvPlaylists => 'LiveTV-Wiedergabelisten';
	@override String get emptyplaylist => 'Keine Wiedergabelisten';
	@override String get reportcomment => 'Berichtsoptionen';
	@override String get feedsources => 'Füttert Quelle';
	@override String get follow => 'Folgen';
	@override String get unfollow => 'nicht mehr folgen';
}

class Strings {
	static Strings _instance = Strings();
	static Strings get instance => _instance;

	String get appname => 'Streama Buzz';
	String get loadingapp => 'initializing app...';
	String get selectlanguage => 'Select Language';
	String get chooseapplanguage => 'Choose App Language';
	String get choosecategories => 'Choose Categories';
	String get selectcategory => 'Select Category';
	String get fetchingcategories => 'Fetching Categories';
	String get articles => 'Articles';
	String get weather => 'Weather Reports';
	String get errorfetchingcategories => 'Could not load Categories \nclick to retry';
	String get selectcategorieshint => 'You must select atleast one category before you can proceed.';
	String get allstories => 'All Stories';
	String get searchhint => 'Search Articles';
	String get articlesloaderrormsg => 'No Item to display, \nPull to Retry';
	String get nobookmarkedarticles => 'No Bookmarked Articles';
	String get performingsearch => 'Searching Articles';
	String get nosearchresult => 'No results Found';
	String get nosearchresulthint => 'Try input more general keyword';
	String get comments => 'Comments';
	String get logintoaddcomment => 'Login to add a comment';
	String get writeamessage => 'Write a message...';
	String get nocomments => 'No Comments found \nclick to retry';
	String get errormakingcomments => 'Cannot process commenting at the moment..';
	String get errordeletingcomments => 'Cannot delete this comment at the moment..';
	String get erroreditingcomments => 'Cannot edit this comment at the moment..';
	String get errorloadingmorecomments => 'Cannot load more comments at the moment..';
	String get deletingcomment => 'Deleting comment';
	String get editingcomment => 'Editing comment';
	String get deletecommentalert => 'Delete Comment';
	String get editcommentalert => 'Edit Comment';
	String get deletecommentalerttext => 'Do you wish to delete this comment? This action cannot be undone';
	String get loadmore => 'load more';
	String get errorloadingarticlecontent => 'Could not load article content \nclick to retry';
	String get guestuser => 'Guest User';
	String get username => 'Username';
	String get fullname => 'Full Name';
	String get emailaddress => 'Email Address';
	String get password => 'Password';
	String get repeatpassword => 'Repeat Password';
	String get register => 'Register';
	String get login => 'Login';
	String get logout => 'Logout';
	String get logoutfromapp => 'Logout from app?';
	String get logoutfromapphint => 'You wont be able to like or comment on articles and videos if you are not logged in.';
	String get gotologin => 'Go to Login';
	String get resetpassword => 'Reset Password';
	String get logintoaccount => 'Already have an account? Login';
	String get emptyfielderrorhint => 'You need to fill all the fields';
	String get invalidemailerrorhint => 'You need to enter a valid email address';
	String get passwordsdontmatch => 'Passwords dont match';
	String get processingpleasewait => 'Processing, Please wait...';
	String get createaccount => 'Create an account';
	String get categories => 'Categories';
	String get about => 'About Us';
	String get privacy => 'Privacy Policy';
	String get terms => 'App Terms';
	String get rate => 'Rate Us';
	String get version => '1.0';
	String get weatherdeafaultcity => 'Lagos';
	String get weatherforecast => 'Weather Forecast';
	String get windspeed => 'wind speed';
	String get sunrise => 'sunrise';
	String get sunset => 'sunset';
	String get humidity => 'humidity';
	String get oneweekforecast => 'One Week Forecast';
	String get fetchweatherforecasterror => 'There was an error fetching weather data';
	String get retryfetch => 'Try Again';
	String get changecity => 'Change city';
	String get nameofcity => 'Name of your city';
	String get locationdenied => 'Location is denied!!';
	String get locationdisabled => 'Location is disabled, Go to settings and enable it. Then Tap the location icon on the app bar to try again.';
	String get enable => 'Enable';
	String get pulluploadmore => 'pull up load';
	String get loadfailedretry => 'Load Failed!Click retry!';
	String get releaseloadmore => 'release to load more';
	String get nomoredata => 'No more Data';
	String get appsettings => 'App Settings';
	String get setupprefernces => 'Setup Your Preferences';
	String get receievepshnotifications => 'Recieve Notifications';
	String get nightmode => 'Night Mode';
	String get showarticleimages => 'Show Images';
	String get showsmallarticleimages => 'Show Small Images';
	String get enablertl => 'Enable RTL';
	String get ok => 'Ok';
	String get oops => 'Ooops!';
	String get save => 'Save';
	String get cancel => 'Cancel';
	String get error => 'Error';
	String get retry => 'RETRY';
	String get success => 'Success';
	String get skiplogin => 'Skip Login';
	String get skipregister => 'Skip Registration';
	String get dataloaderror => 'Could not load requested data at the moment, check your data connection and click to retry.';
	String get next => 'NEXT';
	String get done => 'GOT IT';
	List<String> get onboardertitle => [
		'Streama Buzz',
		'LIVE TV & RADIO',
		'BREAKING NEWS',
		'E-ZONE',
	];
	List<String> get onboarderhints => [
		'Radio, News, LIVE TV, Music, Videos and Movies all in one app.',
		'Watch Online TV and Listen to your favorite radio station.',
		'Get the latest and breaking news happening in your Area.',
		'Listen and download to the best music and movies from the Entertainment Zone.',
	];
	String get relatedposts => 'Related Posts';
	String get bookmarksnav => 'Bookmarks';
	String get errorprocessingrequest => 'Request cannot be processed\n at the moment,\n please try again.';
	String get errorReportingComment => 'Error Reporting Comment';
	String get reportingComment => 'Reporting Comment';
	List<String> get reportCommentsList => [
		'Unwanted commercial content or spam',
		'Pornography or sexual explicit material',
		'Hate speech or graphic violence',
		'Harassment or bullying',
	];
	String get articlesnav => 'Articles';
	String get videosnav => 'Videos';
	String get radionav => 'Radio';
	String get livetvnav => 'Live TV';
	String get orloginwith => 'Or Login With';
	String get facebook => 'Facebook';
	String get google => 'Google';
	String get applesignin => 'Signin with apple';
	String get logintoreply => 'Login to reply';
	String get forgotpassword => 'Forgot Password?';
	String get nobookmarkedvideos => 'No Bookmarked Videos';
	String get replies => 'Replies';
	String get reply => 'Reply';
	String get livetvPlaylists => 'LiveTV Playlists';
	String get emptyplaylist => 'No Playlists';
	String get reportcomment => 'Report Options';
	String get feedsources => 'Feeds Source';
	String get follow => 'Follow';
	String get unfollow => 'Unfollow';
}

class StringsEs extends Strings {
	static StringsEs _instance = StringsEs();
	static StringsEs get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'inicializando la aplicación...';
	@override String get selectlanguage => 'Seleccione el idioma';
	@override String get chooseapplanguage => 'Elija el idioma de la aplicación';
	@override String get choosecategories => 'Elija Categorías';
	@override String get selectcategory => 'selecciona una categoría';
	@override String get fetchingcategories => 'Obtener categorías';
	@override String get articles => 'Artículos';
	@override String get weather => 'Informes meteorológicos';
	@override String get errorfetchingcategories => 'No se pudieron cargar las categorías \nhaga clic para volver a intentarlo';
	@override String get selectcategorieshint => 'Debe seleccionar al menos una categoría antes de poder continuar.';
	@override String get allstories => 'Todas las historias';
	@override String get searchhint => 'Buscar artículos';
	@override String get articlesloaderrormsg => 'No hay elemento para mostrar, \nTire para reintentar';
	@override String get nobookmarkedarticles => 'No hay artículos marcados';
	@override String get performingsearch => 'Búsqueda de artículos';
	@override String get nosearchresult => 'No se han encontrado resultados';
	@override String get nosearchresulthint => 'Intente ingresar una palabra clave más general';
	@override String get comments => 'Comentarios';
	@override String get logintoaddcomment => 'Inicia sesión para añadir un comentario';
	@override String get writeamessage => 'Escribe un mensaje...';
	@override String get nocomments => 'No se encontraron comentarios \nhaga clic para volver a intentarlo';
	@override String get errormakingcomments => 'No se pueden procesar los comentarios en este momento..';
	@override String get errordeletingcomments => 'No se puede eliminar este comentario en este momento..';
	@override String get erroreditingcomments => 'No se puede editar este comentario en este momento..';
	@override String get errorloadingmorecomments => 'No se pueden cargar más comentarios en este momento..';
	@override String get deletingcomment => 'Eliminando comentario';
	@override String get editingcomment => 'Editando comentario';
	@override String get deletecommentalert => 'Eliminar comentario';
	@override String get editcommentalert => 'Editar comentario';
	@override String get deletecommentalerttext => '¿Deseas borrar este comentario? Esta acción no se puede deshacer';
	@override String get loadmore => 'carga más';
	@override String get errorloadingarticlecontent => 'No se pudo cargar el contenido del artículo. Haz clic para volver a intentarlo.';
	@override String get guestuser => 'Usuario invitado';
	@override String get username => 'Nombre de usuario';
	@override String get fullname => 'Nombre completo';
	@override String get emailaddress => 'Dirección de correo electrónico';
	@override String get password => 'Contraseña';
	@override String get repeatpassword => 'Repite la contraseña';
	@override String get register => 'Registrarse';
	@override String get login => 'Iniciar sesión';
	@override String get logout => 'Cerrar sesión';
	@override String get logoutfromapp => '¿Salir de la aplicación?';
	@override String get logoutfromapphint => 'No podrá dar me gusta o comentar artículos y videos si no ha iniciado sesión.';
	@override String get gotologin => 'Ir a Iniciar sesión';
	@override String get resetpassword => 'Restablecer la contraseña';
	@override String get logintoaccount => '¿Ya tienes una cuenta? Iniciar sesión';
	@override String get emptyfielderrorhint => 'Necesitas llenar todos los campos';
	@override String get invalidemailerrorhint => 'Debes ingresar una dirección de correo electrónico válida';
	@override String get passwordsdontmatch => 'Las contraseñas no coinciden';
	@override String get processingpleasewait => 'Procesando .. por favor espere...';
	@override String get createaccount => 'Crea una cuenta';
	@override String get categories => 'Categorías';
	@override String get about => 'Sobre nosotros';
	@override String get privacy => 'Política de privacidad';
	@override String get terms => 'Términos de la aplicación';
	@override String get rate => 'Nos califica';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Pronóstico del tiempo';
	@override String get windspeed => 'velocidad del viento';
	@override String get sunrise => 'amanecer';
	@override String get sunset => 'puesta de sol';
	@override String get humidity => 'humedad';
	@override String get oneweekforecast => 'Pronóstico de una semana';
	@override String get fetchweatherforecasterror => 'Se produjo un error al obtener los datos meteorológicos.';
	@override String get retryfetch => 'Inténtalo de nuevo';
	@override String get changecity => 'Cambiar de ciudad';
	@override String get nameofcity => 'Nombre de tu ciudad';
	@override String get locationdenied => 'La ubicación es denegada!!';
	@override String get locationdisabled => 'La ubicación está deshabilitada, vaya a la configuración y habilítela. Luego toque el ícono de ubicación en la barra de la aplicación para volver a intentarlo.';
	@override String get enable => 'Habilitar';
	@override String get pulluploadmore => 'levantar la carga';
	@override String get loadfailedretry => '¡Error de carga! Haga clic en reintentar!';
	@override String get releaseloadmore => 'suelte para cargar más';
	@override String get nomoredata => 'No más datos';
	@override String get appsettings => 'Ajustes de Aplicacion';
	@override String get setupprefernces => 'Configure sus preferencias';
	@override String get receievepshnotifications => 'Recibir notificaciones';
	@override String get nightmode => 'Modo nocturno';
	@override String get showarticleimages => 'Mostrar imagenes';
	@override String get showsmallarticleimages => 'Mostrar imágenes pequeñas';
	@override String get enablertl => 'Habilitar RTL';
	@override String get ok => 'Okay';
	@override String get oops => 'Vaya!';
	@override String get save => 'Salvar';
	@override String get cancel => 'Cancelar';
	@override String get error => 'Error';
	@override String get retry => 'REVER';
	@override String get success => 'Éxito';
	@override String get skiplogin => 'Omitir inicio de sesión';
	@override String get skipregister => 'Evitar el registro';
	@override String get dataloaderror => 'No se pudieron cargar los datos solicitados en este momento, verifique su conexión de datos y haga clic para volver a intentarlo.';
	@override String get next => 'SIGUIENTE';
	@override String get done => 'ENTENDIDO';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'Artículos Relacionados';
	@override String get bookmarksnav => 'Mis marcadores';
	@override String get errorprocessingrequest => 'La solicitud no se puede procesar en este momento, inténtelo de nuevo..';
	@override String get errorReportingComment => 'Comentario de informe de error';
	@override String get reportingComment => 'Informe de comentario';
	@override List<String> get reportCommentsList => [
		'Contenido comercial no deseado o spam',
		'Pornografía o material sexual explícito',
		'Discurso de odio o violencia gráfica',
		'Acoso o intimidación',
	];
	@override String get articlesnav => 'Artículos';
	@override String get videosnav => 'Videos';
	@override String get radionav => 'Radio';
	@override String get livetvnav => 'Televisión en vivo';
	@override String get orloginwith => 'O inicie sesión con';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Inicia sesión con apple';
	@override String get logintoreply => 'Inicia sesión para responder';
	@override String get forgotpassword => '¿Has olvidado tu contraseña?';
	@override String get nobookmarkedvideos => 'No hay videos marcados';
	@override String get replies => 'Respuestas';
	@override String get reply => 'Respuesta';
	@override String get livetvPlaylists => 'Listas de reproducción de LiveTV';
	@override String get emptyplaylist => 'Sin listas de reproducción';
	@override String get reportcomment => 'Opciones de informe';
	@override String get feedsources => 'Fuente de feeds';
	@override String get follow => 'seguir';
	@override String get unfollow => 'dejar de seguir';
}

class StringsFr extends Strings {
	static StringsFr _instance = StringsFr();
	static StringsFr get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'initialisation de l\'application...';
	@override String get choosecategories => 'Choisissez les catégories';
	@override String get selectlanguage => 'Choisir la langue';
	@override String get chooseapplanguage => 'Choisissez la langue de l\'application';
	@override String get selectcategory => 'Choisir une catégorie';
	@override String get fetchingcategories => 'Récupération des catégories';
	@override String get articles => 'Des articles';
	@override String get weather => 'Rapports météorologiques';
	@override String get errorfetchingcategories => 'Impossible de charger les catégories cliquez pour réessayer';
	@override String get selectcategorieshint => 'Vous devez sélectionner au moins une catégorie avant de pouvoir continuer.';
	@override String get allstories => 'Toutes les histoires';
	@override String get searchhint => 'Rechercher des articles';
	@override String get articlesloaderrormsg => 'Aucun élément à afficher, tirez pour réessayer';
	@override String get nobookmarkedarticles => 'Aucun article ajouté aux favoris';
	@override String get performingsearch => 'Recherche d\'articles';
	@override String get nosearchresult => 'Aucun résultat trouvé';
	@override String get nosearchresulthint => 'Essayez de saisir un mot clé plus général';
	@override String get comments => 'commentaires';
	@override String get logintoaddcomment => 'Connectez-vous pour ajouter un commentaire';
	@override String get writeamessage => 'Écrire un message...';
	@override String get nocomments => 'Aucun commentaire trouvé cliquez pour réessayer';
	@override String get errormakingcomments => 'Impossible de traiter les commentaires pour le moment..';
	@override String get errordeletingcomments => 'Impossible de supprimer ce commentaire pour le moment..';
	@override String get erroreditingcomments => 'Impossible de modifier ce commentaire pour le moment..';
	@override String get errorloadingmorecomments => 'Impossible de charger plus de commentaires pour le moment..';
	@override String get deletingcomment => 'Suppression du commentaire';
	@override String get editingcomment => 'Modification du commentaire';
	@override String get deletecommentalert => 'Supprimer le commentaire';
	@override String get editcommentalert => 'Modifier le commentaire';
	@override String get deletecommentalerttext => 'Souhaitez-vous supprimer ce commentaire? Cette action ne peut pas être annulée';
	@override String get loadmore => 'charger plus';
	@override String get errorloadingarticlecontent => 'Impossible de charger le contenu de l\'article \ncliquez pour réessayer';
	@override String get guestuser => 'Utilisateur invité';
	@override String get username => 'Nom d\'utilisateur';
	@override String get fullname => 'Nom complet';
	@override String get emailaddress => 'Adresse e-mail';
	@override String get password => 'Mot de passe';
	@override String get repeatpassword => 'Répéter le mot de passe';
	@override String get register => 'S\'inscrire';
	@override String get login => 'S\'identifier';
	@override String get logout => 'Se déconnecter';
	@override String get logoutfromapp => 'Déconnexion de l\'application?';
	@override String get logoutfromapphint => 'Vous ne pourrez pas aimer ou commenter des articles et des vidéos si vous n\'êtes pas connecté.';
	@override String get gotologin => 'aller à la connexion';
	@override String get resetpassword => 'réinitialiser le mot de passe';
	@override String get logintoaccount => 'Vous avez déjà un compte? S\'identifier';
	@override String get emptyfielderrorhint => 'Vous devez remplir tous les champs';
	@override String get invalidemailerrorhint => 'Vous devez saisir une adresse e-mail valide';
	@override String get passwordsdontmatch => 'les mots de passe ne correspondent pas';
	@override String get processingpleasewait => 'Traitement, veuillez patienter...';
	@override String get createaccount => 'Créer un compte';
	@override String get categories => 'Catégories';
	@override String get about => 'À propos de nous';
	@override String get privacy => 'Politique de confidentialité';
	@override String get terms => 'Termes de l\'application';
	@override String get rate => 'Évaluez nous';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Prévisions météorologiques';
	@override String get windspeed => 'vitesse du vent';
	@override String get sunrise => 'lever du soleil';
	@override String get sunset => 'le coucher du soleil';
	@override String get humidity => 'humidité';
	@override String get oneweekforecast => 'Prévisions sur une semaine';
	@override String get fetchweatherforecasterror => 'Une erreur s\'est produite lors de la récupération des données météorologiques';
	@override String get retryfetch => 'Réessayer';
	@override String get changecity => 'Changer de ville';
	@override String get nameofcity => 'Nom de votre ville';
	@override String get locationdenied => 'L\'emplacement est refusé!!';
	@override String get locationdisabled => 'La localisation est désactivée, accédez aux paramètres et activez-la. Appuyez ensuite sur l\'icône de localisation dans la barre d\'applications pour réessayer.';
	@override String get enable => 'Activer';
	@override String get pulluploadmore => 'tirer la charge';
	@override String get loadfailedretry => 'Échec du chargement! Cliquez sur Réessayer!';
	@override String get releaseloadmore => 'relâchez pour charger plus';
	@override String get nomoredata => 'Plus de données';
	@override String get appsettings => 'Paramètres de l\'application';
	@override String get setupprefernces => 'Configurez vos préférences';
	@override String get receievepshnotifications => 'Recevoir des notifications';
	@override String get nightmode => 'Mode nuit';
	@override String get showarticleimages => 'Afficher les images';
	@override String get showsmallarticleimages => 'Afficher les petites images';
	@override String get enablertl => 'Activer RTL';
	@override String get ok => 'D\'accord';
	@override String get oops => 'Oups!';
	@override String get save => 'sauver';
	@override String get cancel => 'Annuler';
	@override String get error => 'Erreur';
	@override String get retry => 'RETENTER';
	@override String get success => 'Succès';
	@override String get skiplogin => 'Passer l\'identification';
	@override String get skipregister => 'Sauter l\'inscription';
	@override String get dataloaderror => 'Impossible de charger les données demandées pour le moment, vérifiez votre connexion de données et cliquez pour réessayer.';
	@override String get next => 'PROCHAIN';
	@override String get done => 'JE L\'AI';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'Articles Similaires';
	@override String get bookmarksnav => 'Mes marque-pages';
	@override String get errorprocessingrequest => 'La demande ne peut pas être traitée pour le moment, veuillez réessayer.';
	@override String get errorReportingComment => 'Commentaire de rapport d\'erreur';
	@override String get reportingComment => 'Signaler un commentaire';
	@override List<String> get reportCommentsList => [
		'Contenu commercial indésirable ou spam',
		'Pornographie ou matériel sexuel explicite',
		'Discours haineux ou violence graphique',
		'Harcèlement ou intimidation',
	];
	@override String get articlesnav => 'Des articles';
	@override String get videosnav => 'Vidéos';
	@override String get radionav => 'Radio';
	@override String get livetvnav => 'En direct';
	@override String get orloginwith => 'Ou connectez-vous avec';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Se connecter avec apple';
	@override String get logintoreply => 'Connectez-vous pour répondre';
	@override String get forgotpassword => 'Mot de passe oublié?';
	@override String get nobookmarkedvideos => 'Aucune vidéo ajoutée aux favoris';
	@override String get replies => 'réponses';
	@override String get reply => 'Réponse';
	@override String get livetvPlaylists => 'Listes de lecture LiveTV';
	@override String get emptyplaylist => 'Aucune liste de lecture';
	@override String get reportcomment => 'Options de rapport';
	@override String get feedsources => 'Source des flux';
	@override String get follow => 'Suivre';
	@override String get unfollow => 'Se désabonner';
}

class StringsIt extends Strings {
	static StringsIt _instance = StringsIt();
	static StringsIt get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'inizializzazione dell\'app...';
	@override String get choosecategories => 'Scegli Categorie';
	@override String get selectlanguage => 'Seleziona la lingua';
	@override String get chooseapplanguage => 'Scegli la lingua dell\'app';
	@override String get selectcategory => 'Seleziona categoria';
	@override String get fetchingcategories => 'Recupero delle categorie';
	@override String get articles => 'Articoli';
	@override String get weather => 'Bollettini meteorologici';
	@override String get errorfetchingcategories => 'Impossibile caricare le categorie \nfai clic per riprovare';
	@override String get selectcategorieshint => 'È necessario selezionare almeno una categoria prima di poter procedere.';
	@override String get allstories => 'Tutte le storie';
	@override String get searchhint => 'Cerca articoli';
	@override String get articlesloaderrormsg => 'Nessun elemento da visualizzare, \nTira per riprovare';
	@override String get nobookmarkedarticles => 'Nessun articolo aggiunto ai segnalibri';
	@override String get performingsearch => 'Ricerca di articoli';
	@override String get nosearchresult => 'Nessun risultato trovato';
	@override String get nosearchresulthint => 'Prova a inserire una parola chiave più generica';
	@override String get comments => 'Commenti';
	@override String get logintoaddcomment => 'Esegui il login per aggiungere un commento';
	@override String get writeamessage => 'Scrivi un messaggio...';
	@override String get nocomments => 'Nessun commento trovato \nfai clic per riprovare';
	@override String get errormakingcomments => 'Al momento non è possibile elaborare i commenti..';
	@override String get errordeletingcomments => 'Al momento non è possibile eliminare questo commento..';
	@override String get erroreditingcomments => 'Al momento non è possibile modificare questo commento..';
	@override String get errorloadingmorecomments => 'Al momento non è possibile caricare altri commenti..';
	@override String get deletingcomment => 'Eliminazione del commento';
	@override String get editingcomment => 'Modifica commento';
	@override String get deletecommentalert => 'Elimina commento';
	@override String get editcommentalert => 'Modifica commento';
	@override String get deletecommentalerttext => 'Vuoi eliminare questo commento? Questa azione non può essere annullata';
	@override String get loadmore => 'caricare di più';
	@override String get errorloadingarticlecontent => 'Impossibile caricare il contenuto dell\'articolo \nfai clic per riprovare';
	@override String get guestuser => 'Utente ospite';
	@override String get username => 'Nome utente';
	@override String get fullname => 'Nome e cognome';
	@override String get emailaddress => 'Indirizzo email';
	@override String get password => 'Parola d\'ordine';
	@override String get repeatpassword => 'Ripeti la password';
	@override String get register => 'Registrati';
	@override String get login => 'Accesso';
	@override String get logout => 'Disconnettersi';
	@override String get logoutfromapp => 'Disconnettersi dall\'app?';
	@override String get logoutfromapphint => 'Non sarai in grado di mettere mi piace o commentare articoli e video se non sei loggato.';
	@override String get gotologin => 'Vai al login';
	@override String get resetpassword => 'Resetta la password';
	@override String get logintoaccount => 'Hai già un account? Accesso';
	@override String get emptyfielderrorhint => 'Devi compilare tutti i campi';
	@override String get invalidemailerrorhint => 'Devi inserire un indirizzo email valido';
	@override String get passwordsdontmatch => 'Le password non corrispondono';
	@override String get processingpleasewait => 'Elaborazione, attendere prego...';
	@override String get createaccount => 'Crea un account';
	@override String get categories => 'Categorie';
	@override String get about => 'Riguardo a noi';
	@override String get privacy => 'politica sulla riservatezza';
	@override String get terms => 'Termini dell\'app';
	@override String get rate => 'Valutaci';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Previsioni del tempo';
	@override String get windspeed => 'velocità del vento';
	@override String get sunrise => 'Alba';
	@override String get sunset => 'tramonto';
	@override String get humidity => 'umidità';
	@override String get oneweekforecast => 'Previsione di una settimana';
	@override String get fetchweatherforecasterror => 'Si è verificato un errore durante il recupero dei dati meteo';
	@override String get retryfetch => 'Riprova';
	@override String get changecity => 'Cambia città';
	@override String get nameofcity => 'Nome della tua città';
	@override String get locationdenied => 'La posizione è negata!!';
	@override String get locationdisabled => 'La posizione è disabilitata, vai alle impostazioni e abilitala. Quindi tocca l\'icona della posizione sulla barra delle app per riprovare.';
	@override String get enable => 'Abilitare';
	@override String get pulluploadmore => 'tirare su il carico';
	@override String get loadfailedretry => 'Caricamento non riuscito. Fai clic su Riprova!';
	@override String get releaseloadmore => 'rilascia per caricarne di più';
	@override String get nomoredata => 'Niente più dati';
	@override String get appsettings => 'Impostazioni dell\'app';
	@override String get setupprefernces => 'Imposta le tue preferenze';
	@override String get receievepshnotifications => 'Ricevi notifiche';
	@override String get nightmode => 'Modalità notturna';
	@override String get showarticleimages => 'Mostra immagini';
	@override String get showsmallarticleimages => 'Mostra immagini piccole';
	@override String get enablertl => 'Abilitare RTL';
	@override String get ok => 'Ok';
	@override String get oops => 'Ops!';
	@override String get save => 'Salva';
	@override String get cancel => 'Annulla';
	@override String get error => 'Errore';
	@override String get retry => 'RIPROVA';
	@override String get success => 'Successo';
	@override String get skiplogin => 'Salta il login';
	@override String get skipregister => 'Salta registrazione';
	@override String get dataloaderror => 'Al momento non è possibile caricare i dati richiesti, controlla la connessione dati e fai clic per riprovare.';
	@override String get next => 'IL PROSSIMO';
	@override String get done => 'FATTO';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'Post correlati';
	@override String get bookmarksnav => 'I miei segnalibri';
	@override String get errorprocessingrequest => 'La richiesta non può essere elaborata al momento, riprova.';
	@override String get errorReportingComment => 'Commento segnalazione errori';
	@override String get reportingComment => 'Commento di segnalazione';
	@override List<String> get reportCommentsList => [
		'Contenuti commerciali indesiderati o spam',
		'Pornografia o materiale sessuale esplicito',
		'Incitamento all\'odio o violenza esplicita',
		'Molestie o bullismo',
	];
	@override String get articlesnav => 'Articoli';
	@override String get videosnav => 'Videos';
	@override String get radionav => 'Radio';
	@override String get livetvnav => 'Tv dal vivo';
	@override String get orloginwith => 'Oppure accedi con';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Accedi con apple';
	@override String get logintoreply => 'Accedi per rispondere';
	@override String get forgotpassword => 'Ha dimenticato la password?';
	@override String get nobookmarkedvideos => 'Nessun video aggiunto ai preferiti';
	@override String get replies => 'Risposte';
	@override String get reply => 'rispondere';
	@override String get livetvPlaylists => 'Playlist di LiveTV';
	@override String get emptyplaylist => 'Nessuna playlist';
	@override String get reportcomment => 'Opzioni rapporto';
	@override String get feedsources => 'Fonte dei feed';
	@override String get follow => 'Seguire';
	@override String get unfollow => 'Smetti di seguire';
}

class StringsPt extends Strings {
	static StringsPt _instance = StringsPt();
	static StringsPt get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'inicializando o aplicativo...';
	@override String get choosecategories => 'Escolha as categorias';
	@override String get selectcategory => 'Selecione a Categoria';
	@override String get fetchingcategories => 'Buscando categorias';
	@override String get selectlanguage => 'Selecione o idioma';
	@override String get chooseapplanguage => 'Escolha o idioma do aplicativo';
	@override String get articles => 'Artigos';
	@override String get weather => 'Previsões do tempo';
	@override String get errorfetchingcategories => 'Não foi possível carregar as categorias \nclique para tentar novamente';
	@override String get selectcategorieshint => 'Você deve selecionar pelo menos uma categoria antes de prosseguir.';
	@override String get allstories => 'Todas as histórias';
	@override String get searchhint => 'Artigos de pesquisa';
	@override String get articlesloaderrormsg => 'Nenhum item para exibir, \nPuxe para tentar novamente';
	@override String get nobookmarkedarticles => 'Nenhum artigo marcado';
	@override String get performingsearch => 'Pesquisando Artigos';
	@override String get nosearchresult => 'Nenhum resultado encontrado';
	@override String get nosearchresulthint => 'Tente inserir palavras-chave mais gerais';
	@override String get comments => 'Comentários';
	@override String get logintoaddcomment => 'Faça login para adicionar um comentário';
	@override String get writeamessage => 'Escreve uma mensagem...';
	@override String get nocomments => 'Nenhum comentário encontrado \nclique para tentar novamente';
	@override String get errormakingcomments => 'Não é possível processar comentários no momento..';
	@override String get errordeletingcomments => 'Não é possível excluir este comentário no momento..';
	@override String get erroreditingcomments => 'Não é possível editar este comentário no momento..';
	@override String get errorloadingmorecomments => 'Não é possível carregar mais comentários no momento..';
	@override String get deletingcomment => 'Não é possível carregar mais comentários no momento';
	@override String get editingcomment => 'Editando comentário';
	@override String get deletecommentalert => 'Apagar Comentário';
	@override String get editcommentalert => 'Editar Comentário';
	@override String get deletecommentalerttext => 'Você deseja deletar este comentário? Essa ação não pode ser desfeita';
	@override String get loadmore => 'Carregue mais';
	@override String get errorloadingarticlecontent => 'Não foi possível carregar o conteúdo do artigo \nclique para tentar novamente';
	@override String get guestuser => 'Usuário Convidado';
	@override String get fullname => 'Nome completo';
	@override String get username => 'Nome do usuário';
	@override String get emailaddress => 'Endereço de e-mail';
	@override String get password => 'Senha';
	@override String get repeatpassword => 'Repita a senha';
	@override String get register => 'Registro';
	@override String get login => 'Conecte-se';
	@override String get logout => 'Sair';
	@override String get logoutfromapp => 'Sair do aplicativo?';
	@override String get logoutfromapphint => 'Você não poderá curtir ou comentar em artigos e vídeos se não estiver logado.';
	@override String get gotologin => 'Vá para o Login';
	@override String get resetpassword => 'Redefinir senha';
	@override String get logintoaccount => 'já tem uma conta? Conecte-se';
	@override String get emptyfielderrorhint => 'Você precisa preencher todos os campos';
	@override String get invalidemailerrorhint => 'Você precisa inserir um endereço de e-mail válido';
	@override String get passwordsdontmatch => 'As senhas não coincidem';
	@override String get processingpleasewait => 'Processando ... Por favor aguarde...';
	@override String get createaccount => 'Crie a sua conta aqui';
	@override String get categories => 'Categorias';
	@override String get about => 'Sobre nós';
	@override String get privacy => 'Privacy Policy';
	@override String get terms => 'Termos do aplicativo';
	@override String get rate => 'Nos avalie';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Previsão do tempo';
	@override String get windspeed => 'velocidade do vento';
	@override String get sunrise => 'nascer do sol';
	@override String get sunset => 'pôr do sol';
	@override String get humidity => 'umidade';
	@override String get oneweekforecast => 'Previsão de uma semana';
	@override String get fetchweatherforecasterror => 'Ocorreu um erro ao obter dados meteorológicos';
	@override String get retryfetch => 'Try Again';
	@override String get changecity => 'Mudar de cidade';
	@override String get nameofcity => 'Nome da sua cidade';
	@override String get locationdenied => 'Localização negada!!';
	@override String get locationdisabled => 'A localização está desativada. Vá para as configurações e ative-a. Em seguida, toque no ícone de localização na barra de aplicativos para tentar novamente.';
	@override String get enable => 'Habilitar';
	@override String get pulluploadmore => 'puxar a carga';
	@override String get loadfailedretry => 'Falha ao carregar! Clique em repetir!';
	@override String get releaseloadmore => 'solte para carregar mais';
	@override String get nomoredata => 'Sem mais dados';
	@override String get appsettings => 'Configurações do aplicativo';
	@override String get setupprefernces => 'Configure suas preferências';
	@override String get receievepshnotifications => 'Receber notificações';
	@override String get nightmode => 'Modo noturno';
	@override String get showarticleimages => 'Mostrar imagens';
	@override String get showsmallarticleimages => 'Mostrar imagens pequenas';
	@override String get enablertl => 'Habilitar RTL';
	@override String get ok => 'Está bem';
	@override String get oops => 'Opa!';
	@override String get save => 'Salve';
	@override String get cancel => 'Cancelar';
	@override String get error => 'Erro';
	@override String get retry => 'TENTAR NOVAMENTE';
	@override String get success => 'Sucesso';
	@override String get skiplogin => 'Pular login';
	@override String get skipregister => 'Ignorar registro';
	@override String get dataloaderror => 'Não foi possível carregar os dados solicitados no momento, verifique sua conexão de dados e clique para tentar novamente.';
	@override String get next => 'PRÓXIMO';
	@override String get done => 'ENTENDI';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'Postagens Relacionadas';
	@override String get bookmarksnav => 'Meus marcadores de livro';
	@override String get errorprocessingrequest => 'A solicitação não pode ser processada no momento, tente novamente.';
	@override String get errorReportingComment => 'Comentário do Error Reporting';
	@override String get reportingComment => 'Comentário de relatório';
	@override List<String> get reportCommentsList => [
		'Conteúdo comercial indesejado ou spam',
		'Pornografia ou material sexual explícito',
		'Discurso de ódio ou violência gráfica',
		'Assédio ou intimidação',
	];
	@override String get articlesnav => 'Artigos';
	@override String get videosnav => 'Vídeos';
	@override String get radionav => 'Rádio';
	@override String get livetvnav => 'TV ao vivo';
	@override String get orloginwith => 'Ou faça login com';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Entrar com apple';
	@override String get logintoreply => 'Entre para responder';
	@override String get forgotpassword => 'Esqueceu a senha?';
	@override String get nobookmarkedvideos => 'Nenhum vídeo favorito';
	@override String get replies => 'Respostas';
	@override String get reply => 'Resposta';
	@override String get livetvPlaylists => 'LiveTV Playlists';
	@override String get emptyplaylist => 'Sem listas de reprodução';
	@override String get reportcomment => 'Opções de relatório';
	@override String get feedsources => 'Fonte de Feeds';
	@override String get follow => 'Segue';
	@override String get unfollow => 'Deixar de seguir';
}

class StringsPtbr extends Strings {
	static StringsPtbr _instance = StringsPtbr();
	static StringsPtbr get instance => _instance;

	@override String get appname => 'NewsExtra';
	@override String get loadingapp => 'inicializando o aplicativo...';
	@override String get choosecategories => 'Escolha as categorias';
	@override String get selectcategory => 'Selecione a Categoria';
	@override String get fetchingcategories => 'Buscando categorias';
	@override String get selectlanguage => 'Selecione o idioma';
	@override String get chooseapplanguage => 'Escolha o idioma do aplicativo';
	@override String get articles => 'Artigos';
	@override String get weather => 'Previsões do tempo';
	@override String get errorfetchingcategories => 'Não foi possível carregar as categorias \nclique para tentar novamente';
	@override String get selectcategorieshint => 'Você deve selecionar pelo menos uma categoria antes de prosseguir.';
	@override String get allstories => 'Todas as histórias';
	@override String get searchhint => 'Artigos de pesquisa';
	@override String get articlesloaderrormsg => 'Nenhum item para exibir, \nPuxe para tentar novamente';
	@override String get nobookmarkedarticles => 'Nenhum artigo marcado';
	@override String get performingsearch => 'Pesquisando Artigos';
	@override String get nosearchresult => 'Nenhum resultado encontrado';
	@override String get nosearchresulthint => 'Tente inserir palavras-chave mais gerais';
	@override String get comments => 'Comentários';
	@override String get logintoaddcomment => 'Faça login para adicionar um comentário';
	@override String get writeamessage => 'Escreve uma mensagem...';
	@override String get nocomments => 'Nenhum comentário encontrado \nclique para tentar novamente';
	@override String get errormakingcomments => 'Não é possível processar comentários no momento..';
	@override String get errordeletingcomments => 'Não é possível excluir este comentário no momento..';
	@override String get erroreditingcomments => 'Não é possível editar este comentário no momento..';
	@override String get errorloadingmorecomments => 'Não é possível carregar mais comentários no momento..';
	@override String get deletingcomment => 'Não é possível carregar mais comentários no momento';
	@override String get editingcomment => 'Editando comentário';
	@override String get deletecommentalert => 'Apagar Comentário';
	@override String get editcommentalert => 'Editar Comentário';
	@override String get deletecommentalerttext => 'Você deseja deletar este comentário? Essa ação não pode ser desfeita';
	@override String get loadmore => 'Carregue mais';
	@override String get errorloadingarticlecontent => 'Não foi possível carregar o conteúdo do artigo \nclique para tentar novamente';
	@override String get guestuser => 'Usuário Convidado';
	@override String get fullname => 'Nome completo';
	@override String get username => 'Nome do usuário';
	@override String get emailaddress => 'Endereço de e-mail';
	@override String get password => 'Senha';
	@override String get repeatpassword => 'Repita a senha';
	@override String get register => 'Registro';
	@override String get login => 'Conecte-se';
	@override String get logout => 'Sair';
	@override String get logoutfromapp => 'Sair do aplicativo?';
	@override String get logoutfromapphint => 'Você não poderá curtir ou comentar em artigos e vídeos se não estiver logado.';
	@override String get gotologin => 'Vá para o Login';
	@override String get resetpassword => 'Redefinir senha';
	@override String get logintoaccount => 'já tem uma conta? Conecte-se';
	@override String get emptyfielderrorhint => 'Você precisa preencher todos os campos';
	@override String get invalidemailerrorhint => 'Você precisa inserir um endereço de e-mail válido';
	@override String get passwordsdontmatch => 'As senhas não coincidem';
	@override String get processingpleasewait => 'Processando ... Por favor aguarde...';
	@override String get createaccount => 'Crie a sua conta aqui';
	@override String get categories => 'Categorias';
	@override String get about => 'Sobre nós';
	@override String get privacy => 'Privacy Policy';
	@override String get terms => 'Termos do aplicativo';
	@override String get rate => 'Nos avalie';
	@override String get version => '1.0';
	@override String get weatherdeafaultcity => 'Lagos';
	@override String get weatherforecast => 'Previsão do tempo';
	@override String get windspeed => 'velocidade do vento';
	@override String get sunrise => 'nascer do sol';
	@override String get sunset => 'pôr do sol';
	@override String get humidity => 'umidade';
	@override String get oneweekforecast => 'Previsão de uma semana';
	@override String get fetchweatherforecasterror => 'Ocorreu um erro ao obter dados meteorológicos';
	@override String get retryfetch => 'Try Again';
	@override String get changecity => 'Mudar de cidade';
	@override String get nameofcity => 'Nome da sua cidade';
	@override String get locationdenied => 'Localização negada!!';
	@override String get locationdisabled => 'A localização está desativada. Vá para as configurações e ative-a. Em seguida, toque no ícone de localização na barra de aplicativos para tentar novamente.';
	@override String get enable => 'Habilitar';
	@override String get pulluploadmore => 'puxar a carga';
	@override String get loadfailedretry => 'Falha ao carregar! Clique em repetir!';
	@override String get releaseloadmore => 'solte para carregar mais';
	@override String get nomoredata => 'Sem mais dados';
	@override String get appsettings => 'Configurações do aplicativo';
	@override String get setupprefernces => 'Configure suas preferências';
	@override String get receievepshnotifications => 'Receber notificações';
	@override String get nightmode => 'Modo noturno';
	@override String get showarticleimages => 'Mostrar imagens';
	@override String get showsmallarticleimages => 'Mostrar imagens pequenas';
	@override String get enablertl => 'Habilitar RTL';
	@override String get ok => 'Está bem';
	@override String get oops => 'Opa!';
	@override String get save => 'Salve';
	@override String get cancel => 'Cancelar';
	@override String get error => 'Erro';
	@override String get retry => 'TENTAR NOVAMENTE';
	@override String get success => 'Sucesso';
	@override String get skiplogin => 'Pular login';
	@override String get skipregister => 'Ignorar registro';
	@override String get dataloaderror => 'Não foi possível carregar os dados solicitados no momento, verifique sua conexão de dados e clique para tentar novamente.';
	@override String get next => 'PRÓXIMO';
	@override String get done => 'ENTENDI';
	@override List<String> get onboardertitle => [
		'WordPress News',
		'News & Videos',
		'Radio & Weather',
		'So Much More',
	];
	@override List<String> get onboarderhints => [
		'Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.',
		'Curated feeds from different websites and videos from different youtube channels combined as a single feed.',
		'Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.',
		'Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.',
	];
	@override String get relatedposts => 'Postagens Relacionadas';
	@override String get bookmarksnav => 'Meus marcadores de livro';
	@override String get errorprocessingrequest => 'A solicitação não pode ser processada no momento, tente novamente.';
	@override String get errorReportingComment => 'Comentário do Error Reporting';
	@override String get reportingComment => 'Comentário de relatório';
	@override List<String> get reportCommentsList => [
		'Conteúdo comercial indesejado ou spam',
		'Pornografia ou material sexual explícito',
		'Discurso de ódio ou violência gráfica',
		'Assédio ou intimidação',
	];
	@override String get articlesnav => 'Artigos';
	@override String get videosnav => 'Vídeos';
	@override String get radionav => 'Rádio';
	@override String get livetvnav => 'TV ao vivo';
	@override String get orloginwith => 'Ou faça login com';
	@override String get facebook => 'Facebook';
	@override String get google => 'Google';
	@override String get applesignin => 'Entrar com apple';
	@override String get logintoreply => 'Entre para responder';
	@override String get forgotpassword => 'Esqueceu a senha?';
	@override String get nobookmarkedvideos => 'Nenhum vídeo favorito';
	@override String get replies => 'Respostas';
	@override String get reply => 'Resposta';
	@override String get livetvPlaylists => 'LiveTV Playlists';
	@override String get emptyplaylist => 'Sem listas de reprodução';
	@override String get reportcomment => 'Opções de relatório';
	@override String get feedsources => 'Fonte de Feeds';
	@override String get follow => 'Segue';
	@override String get unfollow => 'Deixar de seguir';
}
