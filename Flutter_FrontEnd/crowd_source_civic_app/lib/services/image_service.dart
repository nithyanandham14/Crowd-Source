import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();
XFile? image;

Future<void> pickImage() async {
  image = await _picker.pickImage(
    source: ImageSource.gallery, // or ImageSource.camera
  );

  if (image != null) {
    // print("Image path: ${image!.path}");
  }
}
