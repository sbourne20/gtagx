import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:customtag/modal/garapinTagModel.dart';
import 'package:customtag/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GarapInTag extends StatefulWidget {
  GarapInTag({
    @required this.onClose,
    this.width,
    this.labeltext,
    this.onSubmitted,
    this.tagStream,
    this.onImagePicked,
    this.imageStream,
    this.database,
    this.onDeleteImage,
  });
  final double width;
  final String labeltext;
  final Stream tagStream;
  final Stream imageStream;
  final Database database;
  Function(String) onClose;
  Function(String) onSubmitted;
  Function(PickedFile, String) onImagePicked;
  Function(String, String) onDeleteImage;

  @override
  _GarapInTagState createState() => _GarapInTagState();
}

class _GarapInTagState extends State<GarapInTag> {
  final _picker = ImagePicker();
  final current = new ValueNotifier(0);

  List<Builder> _buildImageTag(List<dynamic> _listImages, String tagID) {
    return _listImages.asMap().entries.map((e) {
      String value = e.value;

      return Builder(
        builder: (BuildContext context) {
          return Stack(children: [
            Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  child: Image.file(
                    File(value),
                    fit: BoxFit.cover,
                    //width: 250,
                    height: 80,
                  ),
                  borderRadius: BorderRadius.circular(10),
                )),
            Positioned(
              right: 0,
              top: 0,
              width: 22,
              height: 22,
              child: MaterialButton(
                height: 22,
                onPressed: () => widget.onDeleteImage(value, tagID),
                //onPressed: widget.onDeleteImage(index),
                color: Colors.red,
                textColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 15,
                ),
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
              ),
            ),
          ]);
        },
      );
    }).toList();
  }

  Widget _buildImagePosTag(List<dynamic> _listImages) {
    return ValueListenableBuilder(
        valueListenable: current,
        builder: (context, value, child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _listImages.map((e) {
                int index = _listImages.indexOf(e);
                return Builder(builder: (BuildContext context) {
                  return Container(
                    width: index == value ? 7.0 : 5.0,
                    height: index == value ? 7.0 : 5.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == value
                          ? Colors.purpleAccent
                          : Color(0xFFC3C3C3),
                    ),
                  );
                });
              }).toList());
        });
  }

  Widget _buildTextTag(BuildContext context, String tags, String tagID) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tags,
              //this.widget.text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontStyle: FontStyle.normal),
              //textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              width: 25,
              child: MaterialButton(
                height: 22,
                onPressed: () async {
                  final pickedFile =
                      await _picker.getImage(source: ImageSource.gallery);
                  widget.onImagePicked(pickedFile, tagID);
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  size: 15,
                ),
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
              ),
            ),
            Container(
              width: 25,
              child: MaterialButton(
                height: 22,
                onPressed: () {
                  setState(() {
                    this.widget.onClose(tagID);
                    //print("here");
                    //this.widget.onClose();
                  });
                },
                color: Colors.grey,
                textColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 15,
                ),
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagImage(List<dynamic> imageFile, String tagID) {
    return Container(
      width: 80,
      //height: 80,
      //color: Colors.black,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 1,
                  autoPlay: false,
                  height: 80,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) => current.value = index),
              items: _buildImageTag(imageFile, tagID),
            ),
            Positioned(
                left: 10,
                right: 10,
                bottom: 0,
                child: _buildImagePosTag(imageFile)),
          ],
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context, String tags, String tagID,
      List<dynamic> imageFile) {
    double height;

    imageFile == null
        ? height = 26
        : imageFile != null && imageFile.length == 0
            ? height = 26
            : height = 110;

    return Container(
      //height: (imageFile.length > 0) || (imageFile == null) ? 26 : 110,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          height == 26 ? Container() : _buildTagImage(imageFile, tagID),
          _buildTextTag(context, tags, tagID),
        ],
      ),
    );
  }

  Widget _buildContainerTag(BuildContext context) {
    return Container(
      //color: Colors.black,
      width: widget.width,
      height: 280, //------------> container total
      child: Column(
        children: [
          Container(
            child: Material(
                child: TextField(
              onSubmitted: widget.onSubmitted,
              style: TextStyle(fontSize: 12, color: Colors.black),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                hintText: widget.labeltext,
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            )),
          ),
          Container(
            width: widget.width,
            height: 240,
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder(
                stream: widget.tagStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      List<GarapinTagModel> data = snapshot.data;
                      List<Widget> children = List<Widget>();

                      data.forEach((element) {
                        children.add(_buildTags(context, element.title,
                            element.iddoc, element.tagImage));
                      });

                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.vertical,
                        verticalDirection: VerticalDirection.down,
                        children: children,
                        spacing: 3,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                      );
                      //return Container();
                    }
                    return CircularProgressIndicator();
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //return _buildTags(context);
    return _buildContainerTag(context);
  }
}
