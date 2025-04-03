import 'package:flutter_dotenv/flutter_dotenv.dart';

String uri = dotenv.env['API_URI'] ?? "http://default-value.com";

String cloud = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "http://default-value.com";

String upload = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? "http://default-value.com";

