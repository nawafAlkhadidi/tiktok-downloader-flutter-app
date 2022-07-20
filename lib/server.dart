import 'package:video_downloader/dio_helper.dart';
import 'package:video_downloader/tiktok_model.dart';

class Services {
  static Future<TiktokModel?> getTiktokDownload({
    required String uri,
  }) async {
    TiktokModel? tiktok;
    final res = await DioHelper.getWithToken(endpoint: "?url=$uri");
    tiktok = TiktokModel.fromJson(res.data);
    return tiktok;
  }
}
