import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:video_downloader/ads_manager.dart';
import 'package:video_downloader/center_loading.dart';
import 'package:video_downloader/server.dart';
import 'package:video_downloader/tiktok_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //////////////////////!    !///////////////////////
  bool downloading = false;
  bool startDownloading = false;
  var progressString = "";
  late BannerAd _bannerAd;
  bool adIsLoaded = false;
  bool isEmpty = false;
  double progress = 0.0;
  TiktokModel? tiktok;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Dio dio = Dio();
 //////////////////////!    !///////////////////////
  @override
  void initState() {
    _initGoogleMobileAds();
    _bannerAd = BannerAd(
        adUnitId: AdsManager.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.largeBanner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() => adIsLoaded = true);
          },
          onAdFailedToLoad: (ad, error) {
            setState(() => adIsLoaded = false);
          },
        ));
    _bannerAd.load();
    super.initState();
  }

  Future<void> downloadFile() async {
    setState(() {
      downloading = false;
      startDownloading = false;
      isEmpty = false;
    });
    try {
      if (_textController.value.text == "") {
        setState(() => isEmpty = true);
      }
      if (_textController.value.text.contains("tiktok")) {
        setState(() {
          downloading = false;
          startDownloading = true;
          isEmpty = false;
        });
        tiktok = await Services.getTiktokDownload(uri: _textController.text);
        if (tiktok!.code == 0) {
          int name = Random().nextInt(1000);
          try {
            var dir = await getApplicationDocumentsDirectory();
            String path = "${dir.path}/$name.mp4";
            await dio.download(tiktok!.data!.play!, path,
                onReceiveProgress: (rec, total) {
              setState(() {
                downloading = true;
                startDownloading = false;
                progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
                progress = (rec / total * 100).toDouble();
              });
            });
            await GallerySaver.saveVideo(path);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
           _textController.clear();
          setState(() {
            progressString = "تم الحفظ إلى البوم الكاميرا";
          });
        } else {
          setState(() {
            _textController.clear();
            downloading = false;
            startDownloading = false;
            isEmpty = true;
          });
        }
      } else{
         setState(() => isEmpty = true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0EA49F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Save Tik"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 _bannerAdWidget(),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.27,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //! TextField and IconButton
                            SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //! TextFormField
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 60,
                                    child: TextFormField(
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        labelText: "URL",
                                        prefixIcon: Icon(Icons.add_link_sharp),
                                        fillColor: Colors.white,
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                width: .6,
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                width: .6,
                                                color: Colors.black)),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                width: .6,
                                                color: Colors.black)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                width: .6,
                                                color: Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide(
                                                width: .6,
                                                color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                  //! IconButton
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xff000000)
                                            .withOpacity(0.8)),
                                    child: MaterialButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          downloadFile();
                                        },
                                        child: const Icon(
                                          Icons.download_for_offline,
                                          color: Color(0xffFB2D53),
                                          size: 25,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            isEmpty
                                ? const SizedBox(
                                    height: 22,
                                    child: Text(
                                      "أدخل رابط صحيح ",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 22,
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration:   BoxDecoration(
                    color:const  Color(0xffFB2D53),
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(200)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          startDownloading
                              ? const CustomLoading()
                              : downloading
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 170,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                tiktok!.data!.cover!,
                                              ),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: LinearPercentIndicator(
                                            alignment: MainAxisAlignment.center,
                                            width: 200,
                                            lineHeight: 14.0,
                                            percent: progress / 100,
                                            barRadius:
                                                const Radius.circular(20),
                                            backgroundColor:
                                                const Color(0xffCFBC9F),
                                            progressColor:
                                                const Color(0xff0881A3),
                                          ),
                                        ),
                                        Text(
                                          progressString ==
                                                  "تم الحفظ إلى البوم الكاميرا"
                                              ? progressString
                                              : "$progressString : جاري التحميل",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  Widget _bannerAdWidget() {
    if (adIsLoaded) {
      return Container(
        margin: const EdgeInsets.all(8),
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: AdWidget(
          ad: _bannerAd,
        ),
      );
    } else {
      return SizedBox(
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
      );
    }
  }
}
