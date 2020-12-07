import 'package:cloudquark/modules/cloud/service.dart';
import 'package:cloudquark/state/provider.dart';
import 'package:flutter/material.dart';

import 'video_player_page.dart';

abstract class ChainOfResponsability {

  ChainOfResponsability nextHandler;
  final service = new CloudService();

  void setNextHandler(ChainOfResponsability handler){
    this.nextHandler = handler;
  }

  Widget handle(Map<String, dynamic> task);

  String findExtension(String name) {
    RegExp reg = new RegExp(r'\.\w+$');
    return name.substring(reg.firstMatch(name)?.start ?? "");
  }
}

class FolderHandler extends ChainOfResponsability{
  
  @override
  Widget handle(Map<String, dynamic> task) {
    
    final request = task["isDir"]? "folder":"file";

    if(request == "folder"){
      return ListTile(
        leading: Icon(Icons.folder),
        title: Text(task["element"] ?? "No name"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: (){
          final context = task["context"];
          final rxRoute = ProviderState().ofDirectory(context);

          CloudService().dirElements(path: rxRoute.nextRoute(task["element"]));
        },
      );
    }

    return super.nextHandler.handle(task);

  }

}

class VideoOpenhandler extends ChainOfResponsability{

  final supportedExt = ["mp4"];

  @override
  Widget handle(Map<String, dynamic> task) {

    String ext = super.findExtension(task["element"]).toLowerCase();
    ext = ext.substring(1);

    if(supportedExt.indexOf(ext) > -1){

      BuildContext context = task["context"];
      String path = ProviderState().ofDirectory(context).route+">"+task["element"];
      
      String networkRoute = super.service.getFilePath(path);

      return ListTile(
        leading: Icon(Icons.ondemand_video),
        title: Text(task["element"] ?? "No name"),
        trailing: Icon(Icons.play_arrow),
        onTap: (){
          return Navigator.of(context).push(MaterialPageRoute(
            builder: (context)=>VideoPlayerPage(
              name: task["element"],
              localRoute: "Home"+path.replaceAll(r'>', "\\"),
              networkRoute: networkRoute        
            )
          ));
        },
      );
    }  

    return nextHandler.handle(task);
  }
}