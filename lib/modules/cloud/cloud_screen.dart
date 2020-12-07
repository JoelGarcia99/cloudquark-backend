import 'package:cloudquark/modules/cloud/responsability.dart';
import 'package:cloudquark/modules/cloud/service.dart';
import 'package:cloudquark/state/directory_state.dart';
import 'package:cloudquark/state/provider.dart';
import 'package:flutter/material.dart';

import 'package:cloudquark/widgets/PrimaryHeader.dart';

class CloudScreen extends StatelessWidget {

  final service = CloudService();
  final responsability = FolderHandler();

  CloudScreen(){
    responsability.setNextHandler(new VideoOpenhandler());
  }

  @override
  Widget build(BuildContext context) {

    final dirPro = ProviderState().ofDirectory(context);
    dirPro.routeSink("");
    service.dirElements();

    return SafeArea(
      child: Scaffold(
        body: Column(
            children: [
              PrimaryHeader("Cloud", backBtn: false,),
              _getRouteTile(dirPro),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _getFileExplorer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _getRouteTile(DirectoryState dirPro) {

    return StreamBuilder(
      stream: dirPro.routeStream,
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return ListTile(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              if(snapshot.data=="") return;

              final r = dirPro.previousRoute();
              dirPro.routeSink(r);
              service.dirElements(path: r);              
            }
          ),
          title: Text("Home"+snapshot.data.replaceAll(r'>', "\\")),
        );
      },
    );

  }

  Widget _getFileExplorer() {
    return StreamBuilder(
      stream: service.elements,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        final widgets = List<Widget>.from(snapshot.data["files"].map((element){
          Map<String, dynamic> _element = Map<String, dynamic>.from(element);
          _element.addAll({"context": context});

          return responsability.handle(_element);
        }));

        return Column(
          children: widgets
        );

      },
    );
  }
}