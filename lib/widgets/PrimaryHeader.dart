import 'package:cloudquark/modules/cloud/service.dart';
import 'package:flutter/material.dart';

import 'package:cloudquark/language.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PrimaryHeader extends StatefulWidget {

  final bool backBtn;
  final String title;  
  final String host = DotEnv().env['HOST'];
  final String port = DotEnv().env['PORT'];

  PrimaryHeader(this.title, {this.backBtn=true});

  @override
  _PrimaryHeaderState createState() => _PrimaryHeaderState();
}

class _PrimaryHeaderState extends State<PrimaryHeader> {
  final language = new AppLanguage();  
  final headerTextColor = Colors.white;

  bool serverOnline = false;

  @override
  void initState() {

    CloudService().dirElements();
    
    IO.Socket socket = IO.io("http://${widget.host}:${widget.port}/", {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on("connect", (_)=>setState((){this.serverOnline=true;}));
    socket.on("disconnect", (_)=>setState((){this.serverOnline=false;}));
    
    socket.connect();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final serverColor = serverOnline? Colors.yellow : Colors.grey;
    final serverText = serverOnline? language.serverOnlineText:language.serverOfflineText;

    return CustomPaint(
      painter: PrimaryHeaderPainter(context),
      child: Container(
        height: 180,
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _headerOPT(headerTextColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width:45.0,),
                Icon(Icons.online_prediction, color: serverColor),
                SizedBox(width:5.0,),
                Text(serverText, style: TextStyle(color: serverColor),),
                SizedBox(width:10.0,),
              ],
            ),
            SizedBox(height: 50.0,),
            Text(
              this.widget.title ?? "Sin título",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _headerOPT(Color headerTextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            this.widget.backBtn?IconButton(
              icon: Icon(Icons.arrow_back_ios, color: headerTextColor,), 
              onPressed: (){}
            ):SizedBox(width: 20,),
            Text(
              language.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
                color: headerTextColor
              ),
            )
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.info_outline, color: headerTextColor,),
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: headerTextColor,),
              onPressed: (){},
            ),
          ],
        )
      ],
    );
  }
}

class PrimaryHeaderPainter extends CustomPainter {

  final BuildContext context;
  PrimaryHeaderPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = new Paint();

    painter.color = Theme.of(context).secondaryHeaderColor;
    painter.style = PaintingStyle.fill;
    painter.strokeWidth = 2.0;

    final path = new Path();

    path.lineTo(0, size.height*0.8);
    path.quadraticBezierTo(size.width*0.5, size.height*0.3, size.width, size.height*0.8);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(PrimaryHeaderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(PrimaryHeaderPainter oldDelegate) => false;
}