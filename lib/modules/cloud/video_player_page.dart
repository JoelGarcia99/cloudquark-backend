import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {

  final String name;
  final String localRoute;
  final String networkRoute;

  VideoPlayerPage({this.name, this.localRoute, this.networkRoute});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        widget.networkRoute
    );

    initPlayer();
    super.initState();
  }

  Future<void> initPlayer()async {
    await _controller.initialize();
      
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: _controller.value.aspectRatio,
      allowFullScreen: true,
      autoInitialize: true,
      looping: false,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Video player'),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _chewieController != null && _chewieController.videoPlayerController.value.initialized? 
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              ):CircularProgressIndicator(),
            ListTile(
              leading: Icon(Icons.video_library),
              title: Text('Video name'),
              subtitle: Text(widget.name ?? "NA"),
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Local route'),
              subtitle: Text(widget.localRoute ?? "NA"),
            ),
            ListTile(
              leading: Icon(Icons.network_wifi),
              title: Text('Network route'),
              subtitle: Text(widget.networkRoute.replaceAll('>', '/') ?? "NA"),
            ),
          ],
        ),
      ),
    );
  }
}