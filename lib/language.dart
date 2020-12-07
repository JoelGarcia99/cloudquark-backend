class AppLanguage {
  String appTitle;
  String serverOnlineText;
  String serverOfflineText;

  static AppLanguage _instance;

  factory AppLanguage(){
    if(_instance==null){
      _instance = new AppLanguage._();
    }

    return _instance;
  }

  AppLanguage._();

  void fromJSON(Map<String, dynamic> data) {
    this.appTitle = data['app_title'] ?? "CloudQuark";
    this.serverOnlineText = data["server_online_text"] ?? "Online";
    this.serverOfflineText = data["server_offline_text"] ?? "Offline";
  }

}