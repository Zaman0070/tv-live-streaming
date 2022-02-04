import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/models/Categories.dart';
import 'package:newsextra/models/SubCategories.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/providers/UploadMediaModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:newsextra/utils/TextStyles.dart';

import '../utils/my_colors.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import '../utils/Utility.dart';
import 'package:select_dialog/select_dialog.dart';
import '../utils/ApiUrl.dart';
import '../utils/Alerts.dart';
import '../models/Userdata.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../models/Files.dart';
import '../utils/img.dart';

class UploadMediaScreen extends StatefulWidget {
  static const routeName = "/UploadMediaScreen";
  UploadMediaScreen();

  @override
  UploadMediaScreenState createState() => new UploadMediaScreenState();
}

class UploadMediaScreenState extends State<UploadMediaScreen> {
  Userdata userdata;
  Files thumbnail;
  Files media;
  UploadMediaModel uploadMediaModel;

  final TextEditingController categoryController = new TextEditingController();
  final TextEditingController albumController = new TextEditingController();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController coinsController = new TextEditingController();
  final TextEditingController descriptionController =
      new TextEditingController();
  final TextEditingController durationController = new TextEditingController();
  final TextEditingController subCategoryController =
      new TextEditingController();

  pickVideos() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // allowCompression: true,
      allowMultiple: false,
      withData: false,
      allowedExtensions: ['mp4', 'mp3'],
    );
    if (mounted) {
      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.size);
        print(file.extension);
        print(file.path);

        final filePath = await FlutterAbsolutePath.getAbsolutePath(file.path);
        print("video absolute path " + filePath);
        media = new Files(
            link: filePath,
            type: "video",
            filetype: file.extension,
            length: file.size,
            thumbnail: "null");
        //genThumbnailFile(_selectedFiles.length - 1);
      }
      setState(() {});
    }
  }

  pickImages() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowMultiple: false,
      withData: false,
      allowedExtensions: ['png', 'PNG', 'JPEG', 'JPG', 'jpg', 'jpeg', 'gif'],
    );
    if (mounted) {
      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);

        thumbnail = new Files(
          link: file.path,
          type: "image",
          filetype: file.extension,
          length: file.size,
        );
      }
      setState(() {});
    }
  }

  validateandsubmit() async {
    String _title = titleController.text;
    String _description = descriptionController.text;
    String _duration = durationController.text;
    int _category = 0;
    if (uploadMediaModel.selectedCategory != null) {
      _category = uploadMediaModel.selectedCategory.id;
    }
    int _subcategory = 0;
    if (uploadMediaModel.selectedsubCategory != null) {
      _subcategory = uploadMediaModel.selectedsubCategory.id;
    }

    if (_title == "" || _description == "" || _duration == "") {
      Alerts.show(context, "Error", "Some fields were left empty");
      return;
    }
    if (_subcategory == 0 || _subcategory == 0) {
      Alerts.show(context, "Error",
          "Make sure you have selected a category, subcategory and an album for the media.");
      return;
    }

    if (thumbnail == null || media == null) {
      Alerts.show(context, "Error",
          "Make sure you have selected media thumbnail and media file to upload.");
      return;
    }
    submitPosttoServer(
      _title,
      _description,
      _duration,
      _category,
      _subcategory,
    );
  }

  submitPosttoServer(String title, String description, String duration,
      int category, int subcategory) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    FormData formData = FormData.fromMap({
      "country": Provider.of<AppStateNotifier>(context, listen: false)
          .selectedCountry
          .id,
      "description": description,
      "duration": duration,
      "category": category,
      "subcategory": subcategory,
      "title": title,
      "type": media.filetype == "mp3" ? "audio" : "video"
    });

    formData.files
        .add(MapEntry("thumbnail", MultipartFile.fromFileSync(thumbnail.link)));

    formData.files
        .add(MapEntry("media", MultipartFile.fromFileSync(media.link)));

    Dio dio = new Dio();

    try {
      var response = await dio.post(ApiUrl.createMediaApp, data: formData,
          onSendProgress: (int send, int total) {
        print((send / total) * 100);
      });
      Navigator.of(context).pop();
      print(response.data);

      Map<String, dynamic> res = json.decode(response.data);
      if (res["status"] == "error") {
        Alerts.show(context, t.error, "Could not process, please try again.");
        return;
      }
      Navigator.pop(context, true);
    } on DioError catch (e) {
      Navigator.of(context).pop();
      Alerts.show(context, t.error, e.message);
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
      } else {
        //print(e.request.headers);
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    userdata = Provider.of<AppStateNotifier>(context, listen: false).userdata;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uploadMediaModel = Provider.of<UploadMediaModel>(context);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Upload Media"), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.done_all),
          onPressed: () {
            validateandsubmit();
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Select Category",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    enableInteractiveSelection: false,
                    onTap: () {
                      SelectDialog.showModal<Categories>(
                        context,
                        searchBoxDecoration:
                            InputDecoration(labelText: "search"),
                        label: "Select Category",
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            height: 50,
                            child: ListTile(
                              isThreeLine: false,
                              selected: isSelected,
                              trailing: isSelected
                                  ? Icon(Icons.check)
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                              title: Text(
                                item.title,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        },
                        selectedValue: uploadMediaModel.selectedCategory,
                        items: uploadMediaModel.categories,
                        onChange: (Categories selected) {
                          //selectedBank = selected;
                          uploadMediaModel.selectedCategory = selected;
                          uploadMediaModel.selectedsubCategory = null;
                          setState(() {
                            subCategoryController.text = "";
                            categoryController.text = selected.title;
                          });
                          uploadMediaModel.fetchSubCategories(selected.id);
                        },
                        onFind: (String query) async {
                          List<Categories> searchListData = [];
                          uploadMediaModel.categories.forEach((item) {
                            if (item.title.toLowerCase().contains(query)) {
                              searchListData.add(item);
                            }
                          });
                          return searchListData;
                        },
                      );
                    },
                    keyboardType: TextInputType.text,
                    controller: categoryController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Select SubCategory",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    enableInteractiveSelection: false,
                    onTap: () {
                      SelectDialog.showModal<SubCategories>(
                        context,
                        searchBoxDecoration:
                            InputDecoration(labelText: "search"),
                        label: "Select SubCategory",
                        itemBuilder: (context, item, isSelected) {
                          return Container(
                            height: 50,
                            child: ListTile(
                              isThreeLine: false,
                              selected: isSelected,
                              trailing: isSelected
                                  ? Icon(Icons.check)
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                              title: Text(
                                item.title,
                                style: TextStyles.subhead(context)
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        },
                        selectedValue: uploadMediaModel.selectedsubCategory,
                        items: uploadMediaModel.subcategories,
                        onChange: (SubCategories selected) {
                          uploadMediaModel.selectedsubCategory = selected;

                          setState(() {
                            subCategoryController.text = selected.title;
                          });
                        },
                        onFind: (String query) async {
                          List<SubCategories> searchListData = [];
                          uploadMediaModel.subcategories.forEach((item) {
                            if (item.title.toLowerCase().contains(query)) {
                              searchListData.add(item);
                            }
                          });
                          return searchListData;
                        },
                      );
                    },
                    keyboardType: TextInputType.text,
                    controller: subCategoryController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Media Title",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Media Description",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Add Media Thumbnail",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 100,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      pickImages();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: thumbnail == null
                          ? Container(
                              width: 50,
                              height: 50,
                              color: MyColors.primary,
                              child: Center(
                                child: Icon(
                                  Icons.attach_file,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.file(
                                  File.fromUri(Uri.parse(thumbnail.link)),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Add Mp3 or Mp4 Media",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 150,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      pickVideos();
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: media == null
                            ? Container(
                                width: 50,
                                height: 50,
                                color: MyColors.primary,
                                child: Center(
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              )
                            : Column(children: [
                                Container(
                                  height: 60,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      media.filetype == "mp4"
                                          ? Icons.video_collection_outlined
                                          : Icons.music_video_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(media.link.split('/').last,
                                    style: TextStyles.caption(context)
                                        .copyWith(color: MyColors.grey_60)),
                              ])),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Media Duration (Format 00:00)",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: durationController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
