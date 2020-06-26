import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({Key key, @required this.camera}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  //화면이 첫 실행됬을때 두번째 화면인 사진화면으로 기본세팅
  int _selectedIndex = 0;
  //페이지뷰 위젯을 컨트롤하는 컨트롤러. 첫 화면은 1번째로 지정
  var _pageController = PageController(initialPage: 0);
  CameraController _controller;
  //카메라를 실행후 준비가 되면 이걸로 신호를 받음
  Future<void> _initializeControllerFuture;

  //상태가 트리에 추가되는 시점
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      //카메라 화질
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _takePhotoPage(),
    );
  }

  Widget _takePhotoPage() {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Column(
              children: <Widget>[
                Container(
                  //화면을 1:1 비율로 자름
                  width: size.width,
                  height: size.height * 0.8,
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: size.width,
                          height: size.width / _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Scaffold(
                            appBar: AppBar(
                              toolbarOpacity: 0.0,
                            ),
                            body: Center(
                              child: Text("camera"),
                            ),
                          ),
                          fullscreenDialog: true,
                        ));
                      },
                      child: Icon(Icons.album),
                    ),
                    RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Scaffold(
                            appBar: AppBar(
                              toolbarOpacity: 0.0,
                            ),
                            body: Center(
                              child: Text("QR"),
                            ),
                          ),
                          fullscreenDialog: true,
                        ));
                      },
                      child: Icon(Icons.center_focus_weak),
                    ),
                  ],
                ),
              ],
            );
          return CircularProgressIndicator();
        });
  }

  Widget _takeVideoPage() {
    return Container(color: Colors.deepOrange);
  }
}
