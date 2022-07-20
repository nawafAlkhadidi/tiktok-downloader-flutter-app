class TiktokModel {
  int? code;
  String? msg;
  double? processedTime;
  Data? data;

  TiktokModel({code, msg, processedTime, data});

  TiktokModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    processedTime = json['processed_time'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['processed_time'] = processedTime;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? awemeId;
  String? id;
  String? region;
  String? title;
  String? cover;
  String? originCover;
  String? play;
  String? wmplay;
  String? music;
  MusicInfo? musicInfo;
  int? playCount;
  int? diggCount;
  int? commentCount;
  int? shareCount;
  int? downloadCount;
  int? createTime;
  Author? author;

  Data(
      {awemeId,
      id,
      region,
      title,
      cover,
      originCover,
      play,
      wmplay,
      music,
      musicInfo,
      playCount,
      diggCount,
      commentCount,
      shareCount,
      downloadCount,
      createTime,
      author});

  Data.fromJson(Map<String, dynamic> json) {
    awemeId = json['aweme_id'];
    id = json['id'];
    region = json['region'];
    title = json['title'];
    cover = json['cover'];
    originCover = json['origin_cover'];
    play = json['play'];
    wmplay = json['wmplay'];
    music = json['music'];
    musicInfo = json['music_info'] != null
        ?  MusicInfo.fromJson(json['music_info'])
        : null;
    playCount = json['play_count'];
    diggCount = json['digg_count'];
    commentCount = json['comment_count'];
    shareCount = json['share_count'];
    downloadCount = json['download_count'];
    createTime = json['create_time'];
    author =
        json['author'] != null ?  Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aweme_id'] = awemeId;
    data['id'] = id;
    data['region'] = region;
    data['title'] = title;
    data['cover'] = cover;
    data['origin_cover'] = originCover;
    data['play'] = play;
    data['wmplay'] = wmplay;
    data['music'] = music;
    if (musicInfo != null) {
      data['music_info'] = musicInfo!.toJson();
    }
    data['play_count'] = playCount;
    data['digg_count'] = diggCount;
    data['comment_count'] = commentCount;
    data['share_count'] = shareCount;
    data['download_count'] = downloadCount;
    data['create_time'] = createTime;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    return data;
  }
}

class MusicInfo {
  String? id;
  String? title;
  String? play;
  String? cover;
  String? author;
  bool? original;
  int? duration;
  String? album;

  MusicInfo(
      {id,
      title,
      play,
      cover,
      author,
      original,
      duration,
      album});

  MusicInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    play = json['play'];
    cover = json['cover'];
    author = json['author'];
    original = json['original'];
    duration = json['duration'];
    album = json['album'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['play'] = play;
    data['cover'] = cover;
    data['author'] = author;
    data['original'] = original;
    data['duration'] = duration;
    data['album'] = album;
    return data;
  }
}

class Author {
  String? id;
  String? uniqueId;
  String? nickname;
  String? avatar;

  Author({id, uniqueId, nickname, avatar});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    nickname = json['nickname'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['unique_id'] = uniqueId;
    data['nickname'] = nickname;
    data['avatar'] = avatar;
    return data;
  }
}