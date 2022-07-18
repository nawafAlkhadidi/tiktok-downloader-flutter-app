import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_downloader/ads_manager.dart';
import 'package:video_downloader/server.dart';
import 'package:video_downloader/tiktok_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool downloading = false;
  var progressString = "";
  late BannerAd _bannerAd;
  bool adIsLoaded = false;
  double progress = 0.0;
  TiktokModel? tiktok;

  @override
  void initState() {
    _initGoogleMobileAds();
    _bannerAd = BannerAd(
        adUnitId: AdsManager.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
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

  final TextEditingController _textController = TextEditingController();

  Future<void> downloadFile() async {
    setState(() {
      downloading = false;
    });
    tiktok = await Services.getTiktokDownload(uri: _textController.text);

    Dio dio = Dio();
    int name = Random().nextInt(1000);
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(tiktok!.video!.last, "${dir.path}/$name.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
          progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
          progress = (rec / total * 100).toDouble();
          print(progress);
        });
      });
      String path = "${dir.path}/$name.mp4";
      await GallerySaver.saveVideo(path).then((bool? success) {
        setState(() {
          print('Video is saved');
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      progressString = "Done to Save";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff72F3EE).withOpacity(0.8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Save Tik"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bannerAdWidget(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //! TextField
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 60,
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: "URL",
                            prefixIcon: Icon(Icons.add_link_sharp),
                            fillColor: Colors.white,
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: .6, color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: .6, color: Colors.black)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: .6, color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: .6, color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(width: .6, color: Colors.black)),
                          ),
                        ),
                      ),
                      //! IconButton
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff000000).withOpacity(0.8)),
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
              ],
            ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffFB2D53).withOpacity(0.95),
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(200)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        downloading
                            ? Column(
                                children: [
                                  Container(
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          tiktok!.cover!.last,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 20),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      color: const Color(0xffCFBC9F),
                                      backgroundColor: const Color(0xff0881A3),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    child: Text(
                                      "Downloading File: $progressString",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
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