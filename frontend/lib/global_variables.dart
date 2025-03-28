import 'package:flutter_dotenv/flutter_dotenv.dart';

String uri = dotenv.env['API_URI'] ?? "http://default-value.com";
 