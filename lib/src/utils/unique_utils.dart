import 'package:uuid/uuid.dart';

String get randomId => "${Uuid().v4()}-${DateTime.now()}";