import 'package:newsextra/i18n/strings.g.dart';

class StringsUtils {
  //Api url
  static const String BASEURL = "https://stations.africa/";
  static const String TERMS = BASEURL + "terms";
  static const String PRIVACY = BASEURL + "privacy";
  static const String ABOUT = BASEURL + "about";

  //list of strings used in the app
  /* static const String app_name = "NewsExtra";
  static const String loading_app = "initializing app...";
  static const String radio_placeholder = "NewsExtra Radio";
  static const String choose_categories = "Choose Categories";
  static const String select_category = "Select Category";
  static const String fetching_categories = "Fetching Categories";
  static const String articles = "Articles";
  static const String videos = "Videos";
  static const String weather = "Weather Reports";
  static const String livetvPlaylists = "LiveTV Playlists";
  static const String emptyplaylist = "No Playlists";
  static const String error_fetching_categories =
      "Could not load Categories \nclick to retry";
  static const String select_categories_hint =
      "You must select atleast one category before you can proceed.";
  static const String all_stories = "All Stories";
  static const String search_hint = "Search Articles & Videos";
  static const String articles_load_error_msg =
      "No Item to display, \nPull to Retry";
  static const String no_bookmarked_articles = "No Bookmarked Articles";
  static const String no_bookmarked_videos = "No Bookmarked Videos";
  static const String error_fetching_radio =
      "Could not load Radio \nclick to retry";
  static const String performing_search = "Searching Articles and Videos";
  static const String no_search_result = "No results Found";
  static const String no_search_result_hint = "Try input more general keyword";
  static const String comments = "Comments";
  static const String replies = "Replies";
  static const String reply = "Reply";
  static const String login_to_add_comment = "Login to add a comment";
  static const String login_to_reply = "Login to reply";
  static const String write_a_message = "Write a message...";
  static const String no_comments = "No Comments found \nclick to retry";
  static const String error_making_comments =
      "Cannot process commenting at the moment..";
  static const String error_deleting_comments =
      "Cannot delete this comment at the moment..";
  static const String error_editing_comments =
      "Cannot edit this comment at the moment..";
  static const String error_loadingmore_comments =
      "Cannot load more comments at the moment..";
  static const String deleting_comment = "Deleting comment";
  static const String editing_comment = "Editing comment";
  static const String delete_comment_alert = "Delete Comment";
  static const String edit_comment_alert = "Edit Comment";
  static const String delete_comment_alert_text =
      "Do you wish to delete this comment? This action cannot be undone";
  static const String load_more = "load more";
  static const String error_loading_article_content =
      "Could not load article content \nclick to retry";

  //login, register, forgot password strings
  static const String guest_user = "Guest User";
  static const String full_name = "Full Name";
  static const String email_address = "Email Address";
  static const String password = "Password";
  static const String repeat_password = "Repeat Password";
  static const String register = "Register";
  static const String login = "Login";
  static const String logout = "Logout";
  static const String logout_from_app = "Logout from app?";
  static const String logout_from_app_hint =
      "You wont be able to like or comment on articles and videos if you are not logged in.";
  static const String go_to_login = "Go to Login";
  static const String reset_password = "Reset Password";
  static const String login_to_account = "Already have an account? Login";
  static const String empty_field_error_hint =
      "You need to fill all the fields";
  static const String invalid_email_error_hint =
      "You need to enter a valid email address";
  static const String passwords_dont_match = "Passwords dont match";
  static const String processing_please_wait = "Processing, Please wait...";
  static const String create_account = "Create an account";
  static const String forgot_password = "Forgot Password?";
  static const String or_login_with = "Or Login With";
  static const String facebook = "Facebook";
  static const String google = "Google";
  static const String apple_signin = "Signin with apple";

  //menu fab items
  static const String more_options = "More Options";
  static const String categories = "Categories";
  static const String about = "About Us";
  static const String privacy = "Privacy Policy";
  static const String terms = "App Terms";
  static const String rate = "Rate Us";
  static const String version = "1.0";

  //weather strings
  static const String weather_deafault_city = "Lagos";
  static const String weather_forecast = "Weather Forecast";
  static const String wind_speed = "wind speed";
  static const String sunrise = "sunrise";
  static const String sunset = "sunset";
  static const String humidity = "humidity";
  static const String one_week_forecast = "One Week Forecast";
  static const String fetch_weather_forecast_error =
      "There was an error fetching weather data";
  static const String retry_fetch = "Try Again";
  static const String change_city = "Change city";
  static const String name_of_city = 'Name of your city';
  static const String location_denied = "Location is denied!!";
  static const String location_disabled =
      "Location is disabled, Go to settings and enable it. Then Tap the location icon on the app bar to try again.";
  static const String enable = "Enable";

  //pull refresh strings
  static const String pull_up_load_more = "pull up load";
  static const String load_failed_retry = "Load Failed!Click retry!";
  static const String release_load_more = "release to load more";
  static const String no_more_data = "No more Data";

  //Bottom Navigation strings
  static const String articles_nav = "Articles";
  static const String videos_nav = "Videos";
  static const String bookmarks_nav = "Bookmarks";
  static const String radio_nav = "Radio";
  static const String livetv_nav = "Live TV";

  //App settings strings
  static const String app_settings = "App Settings";
  static const String setup_prefernces = "Setup Your Preferences";
  static const String receieve_psh_notifications = "Recieve Notifications";
  static const String night_mode = "Night Mode";
  static const String show_article_images = "Show Images";
  static const String show_small_article_images = "Show Small Images";
  static const String enable_rtl = "Enable RTL";

  //commonly used strings
  static const String ok = "Ok";
  static const String oops = "Ooops!";
  static const String save = "Save";
  static const String cancel = "Cancel";
  static const String error = "Error";
  static const String retry = "RETRY";
  static const String success = "Success";
  static const String skip_login = "Skip Login";
  static const String skip_register = "Skip Registration";
  static const String data_load_error =
      "Could not load requested data at the moment, check your data connection and click to retry.";

  //report comment array
  static const String errorReportingComment = "Error Reporting Comment";
  static const String reportingComment = "Reporting Comment";
  static const String report_comment = "Report Options";
  static List<String> reportCommentsList = [
    "Unwanted commercial content or spam",
    "Pornography or sexual explicit material",
    "Hate speech or graphic violence",
    "Harassment or bullying"
  ];

  //onboarding page
  static const String next = "NEXT";
  static const String done = "GOT IT";

  static const List<String> onboarder_title = [
    app_name,
    "News & Videos",
    "Radio & Weather",
    "So Much More"
  ];
  static const List<String> onboarder_hints = [
    "Multi-purpose Android, IOS and Web News App, everything you need to launch your own RSS news app.",
    "Curated feeds from different websites and videos from different youtube channels combined as a single feed.",
    "Radio player with support for multiple radio channels, weather forecasts and LiveTV Channels.",
    "Packed with so many features: LiveTV channels, Push Notifications, Admob, User Accounts, Comments, Bookmarks etc.",
  ];
  */
  //subscriptions
  static const String loginrequired = "Login Required";
  static const String loginrequiredhint =
      "To subscribe on this platform, you need to be logged in. Create a free account now or log in to your existing account.";
  static const String subscriptions = "App Subscriptions";
  static const String subscribe = "SUBSCRIBE";
  static const String subscribehint = "Subscription Required";
  static const String playsubscriptionrequiredhint =
      "You need to subscribe before you can listen to or watch this media.";
  static const String previewsubscriptionrequiredhint =
      "You have reached the allowed preview duration for this media. You need to subscribe to continue listening or watching this media.";

  //media popupmenu options
  static const String download = "Download";
  static const String addplaylist = "Add to playlist";
  static const String bookmark = "Bookmark";
  static const String unbookmark = "UnBookmark";
  static const String share = "Share";
  static const String deletemedia = "Delete File";
  static const String deletemediahint =
      "Do you wish to delete this downloaded file? This action cannot be undone.";
  static const String bookmarksMedia = "My Bookmarks";
  static const String noitemstodisplay = "No Items To Display";
  static const String notsupported = "Not Supported";
  static const String cleanupresources = "Cleaning up resources";
  static const String grantstoragepermission =
      "Please grant accessing storage permission to continue";
  static const String share_file_title = "Watch or Listen to ";
  static String share_file_body = "Via " + t.appname + " App, Download now at ";
  static const String share_text = "Enjoy unlimited Audio & Video streaming";
  static const String share_text_hint =
      "Join the Video and Audio streaming platform that lets you watch and listen to millions of files from around the world. Download now at";

  //comments
  static const String comments = "Comments";
  static const String replies = "Replies";
  static const String reply = "Reply";
  static const String login_to_add_comment = "Login to add a comment";
  static const String login_to_reply = "Login to reply";
  static const String write_a_message = "Write a message...";
  static const String no_comments = "No Comments found \nclick to retry";
  static const String error_making_comments =
      "Cannot process commenting at the moment..";
  static const String error_deleting_comments =
      "Cannot delete this comment at the moment..";
  static const String error_editing_comments =
      "Cannot edit this comment at the moment..";
  static const String error_loadingmore_comments =
      "Cannot load more comments at the moment..";
  static const String deleting_comment = "Deleting comment";
  static const String editing_comment = "Editing comment";
  static const String delete_comment_alert = "Delete Comment";
  static const String edit_comment_alert = "Edit Comment";
  static const String delete_comment_alert_text =
      "Do you wish to delete this comment? This action cannot be undone";
  static const String load_more = "load more";
  //report comment array
  static const String errorReportingComment = "Error Reporting Comment";
  static const String reportingComment = "Reporting Comment";
  static const String report_comment = "Report Options";
  static List<String> reportCommentsList = [
    "Unwanted commercial content or spam",
    "Pornography or sexual explicit material",
    "Hate speech or graphic violence",
    "Harassment or bullying"
  ];

  static List<String> feedbackoptions = [
    "General contact/complains",
    "Upload Music Audio or Video",
    "Add a radio station",
  ];

  static List<String> searchoptions = [
    "Radio",
    "Live Tv",
    "Music and Videos",
    "Articles",
  ];

  static const String errorReportingRadio = "Error Reporting Radio";
  static const String reportingRadio = "Reporting Radio";
  static const String successReportingRadio =
      "Thank You!, we will let you know as soon as issues with this radio is resolved.";

  static List<String> reportRadioList = [
    "Radio is broken and cannot be played",
    "Hate speech or violent content",
    "Harassment or bullying content"
  ];

  static List<String> productIds = <String>[
    'weekly',
    'monthly',
    'yearly',
  ];
  static const List<String> onboarder_image = [
    "launcher_icon.png",
    "launcher_icon.png",
    "launcher_icon.png",
    "launcher_icon.png",
  ];

  static const String start_subscription = "Unlock Premium Features";
  static const String start_subscription_hint =
      "Unlock premium features to start your journey to a never-ending media streaming experience";
  static const String suggestedforyou = "Suggested for you";
  static const String tracks = "Tracks";
  static const String livetvchannels = "Live Tv Channels";
  static const String trendingvideos = "Trending Videos";
  static const String trendingaudios = "Trending Audios";
  static const String trendingvideoshint =
      "Hot & Popular Videos On Streama Buzz";
  static const String trendingaudioshint =
      "Hot & Popular Audios On Streama Buzz";
  static const String newvideoshint = "New Videos from all categories";
  static const String newaudioshint = "New Audios from all categories";
  static const String livetv = "Live Tv";
  static const String hotandtrending = "Hot and Trending";
  static const String videotracks = "Video Tracks";
  static const String audiotracks = "Audio Tracks";
}
