import 'package:image_picker/image_picker.dart';

class VoucherService {
  dynamic chooseFile() async {
    return await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((image) {
      return image;
    });
  }
}
