List<String> imageFormats = [
  'png',
  'jpg',
  'jpeg',
  'gif',
  'bmp',
  'tiff',
  'tif',
  'webp',
  'svg',
  'heic',
  'heif',
  'raw',
  'ico',
];

bool useImage(String path) {
  bool have = false;
  final lastS = path.split('.').last.toLowerCase();
  for (final form in imageFormats) {
    if (form == lastS) {
      have = true;
      break;
    }
  }
  return have;
}
