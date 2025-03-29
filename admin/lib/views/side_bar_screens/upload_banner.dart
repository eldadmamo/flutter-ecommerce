import 'package:admin/controllers/banner_controller.dart';
import 'package:admin/views/side_bar_screens/widgets/banner_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadBanner extends StatefulWidget {
  static const String id = '\banner-screen';
  const UploadBanner({super.key});

  @override
  State<UploadBanner> createState() => _UploadBannerState();
}

class _UploadBannerState extends State<UploadBanner> {
  final BannerController _bannerController = BannerController();
   dynamic _image;
   pickImage() async{
   FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false 
    );

    if (result!= null){
      setState(() {
        _image = result.files.first.bytes;
      });
    }
   }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: Text("Banners", style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 36 
            ),),
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        Row(
          children: [
            Container(
                width: 150, 
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5,), 
                ),
                child: Center(
                  child: _image!=null 
                  ? Image.memory(_image)
                  : Text('Category image'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: ()async{
                    await _bannerController.UploadBanner(pickedImage: _image, context: context);
                  }, 
                  child: Text('Save')
                ),
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){
            pickImage();
          }, child: Text('Pick Image')),
        ),
        Divider(
          color: Colors.grey, 
        ),
        BannerWidget()
      ], 
    );
  }
}