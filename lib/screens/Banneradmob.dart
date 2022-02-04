import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/providers/SubscriptionModel.dart';
import 'package:provider/provider.dart';
import '../utils/Adverts.dart';

class Banneradmob extends StatefulWidget {
  const Banneradmob({Key key}) : super(key: key);

  @override
  _BanneradmobState createState() => _BanneradmobState();
}

class _BanneradmobState extends State<Banneradmob> {
  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        break;
      case AdmobAdEvent.opened:
        break;
      case AdmobAdEvent.closed:
        break;
      case AdmobAdEvent.failedToLoad:
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Visibility(
        visible: Provider.of<SubscriptionModel>(
              context,
            ).isSubscribed ==
            false,
        child: Provider.of<AppStateNotifier>(context, listen: false)
                .loadFacebookAds
            ? Container(
                //alignment: Alignment(0.5, 1),
                child: FacebookBannerAd(
                  placementId: Adverts.getFacebookBannerAdUnit(),
                  bannerSize: BannerSize.STANDARD,
                  listener: (result, value) {
                    switch (result) {
                      case BannerAdResult.ERROR:
                        print("Error: $value");
                        break;
                      case BannerAdResult.LOADED:
                        print("Loaded: $value");
                        break;
                      case BannerAdResult.CLICKED:
                        print("Clicked: $value");
                        break;
                      case BannerAdResult.LOGGING_IMPRESSION:
                        print("Logging Impression: $value");
                        break;
                    }
                  },
                ),
              )
            : Container(
                margin: EdgeInsets.only(bottom: 0.0),
                child: AdmobBanner(
                  adUnitId: Adverts.getBannerAdUnitId(),
                  adSize: AdmobBannerSize.BANNER,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                    handleEvent(event, args, 'Banner');
                  },
                  onBannerCreated: (AdmobBannerController controller) {
                    // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                    // Normally you don't need to worry about disposing this yourself, it's handled.
                    // If you need direct access to dispose, this is your guy!
                    // controller.dispose();
                  },
                ),
              ),
      ),
    );
  }
}
