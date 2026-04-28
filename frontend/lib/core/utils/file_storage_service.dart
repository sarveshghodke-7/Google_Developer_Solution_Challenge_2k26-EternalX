import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  Future<Directory> get _localUploadsDir async {
    final directory = await getApplicationDocumentsDirectory();
    final uploadDir = Directory('${directory.path}/uploads');
    if (!await uploadDir.exists()) {
      await uploadDir.create(recursive: true);
    }
    return uploadDir;
  }
  Future<File?> pickAndSaveReport() async {
    await cleanUpOldFiles();
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      File originalFile = File(result.files.single.path!);
      final uploadDir = await _localUploadsDir;
      final fileName = result.files.single.name;
      final newFilePath = '${uploadDir.path}/$fileName';
      final savedFile = await originalFile.copy(newFilePath);
      return savedFile;
    }
    return null; 
  }
  Future<void> cleanUpOldFiles() async {
    final uploadDir = await _localUploadsDir;
    
    if (await uploadDir.exists()) {
      final List<FileSystemEntity> files = uploadDir.listSync();
      final DateTime now = DateTime.now();

      for (var file in files) {
        if (file is File) {
          final FileStat stat = await file.stat();
          final Duration age = now.difference(stat.modified);
          if (age.inHours >= 24) {
            await file.delete();
            print('Deleted old cached file: ${file.path}');
          }
        }
      }
    }
  }
}
