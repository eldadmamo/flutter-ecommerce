import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess
}) {
  //Switch statement to handle different http status codes
  switch(response.statusCode){
    case 200:
       onSuccess();
       break;
    case 400:
       showSnackBar(context, json.decode(response.body)['msg']);
       break;
    case 500:
       showSnackBar(context, json.decode(response.body)['error']);
       break;
    case 201:
       onSuccess();
       break;
  }
}

void showSnackBar(BuildContext context, String title){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}

