import 'package:image_picker/image_picker.dart';

class voucherService{


  dynamic chooseFile() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {

        return image;

    });
  }






}