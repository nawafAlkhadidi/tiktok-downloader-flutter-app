class TiktokModel {
  List<String>? video;
  List<String>? music;
  List<String>? cover;
  List<String>? originalWatermarkedVideo;
  List<String>? dynamicCover;
  List<String>? author;
  List<String>? region;
  List<String>? avatarThumb;
  List<String>? customVerify;

  TiktokModel(
      {this.video,
      this.music,
      this.cover,
      this.originalWatermarkedVideo,
      this.dynamicCover,
      this.author,
      this.region,
      this.avatarThumb,
      this.customVerify});

  TiktokModel.fromJson(Map<String, dynamic> json) {
    video = json['video'].cast<String>();
    music = json['music'].cast<String>();
    cover = json['cover'].cast<String>();
    originalWatermarkedVideo = json['OriginalWatermarkedVideo'].cast<String>();
    dynamicCover = json['dynamic_cover'].cast<String>();
    author = json['author'].cast<String>();
    region = json['region'].cast<String>();
    avatarThumb = json['avatar_thumb'].cast<String>();
    customVerify = json['custom_verify'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.video;
    data['music'] = this.music;
    data['cover'] = this.cover;
    data['OriginalWatermarkedVideo'] = this.originalWatermarkedVideo;
    data['dynamic_cover'] = this.dynamicCover;
    data['author'] = this.author;
    data['region'] = this.region;
    data['avatar_thumb'] = this.avatarThumb;
    data['custom_verify'] = this.customVerify;
    return data;
  }
}