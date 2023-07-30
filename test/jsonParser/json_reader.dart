import 'dart:io';

String jsonParser(String name) => File('test/jsonParser/$name').readAsStringSync();
