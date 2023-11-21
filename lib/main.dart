import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pa_mobile/app.dart';
import 'package:pa_mobile/shared/firebase/firebase_api.dart';
import 'package:pa_mobile/shared/services/storage/jwt_secure_storage.dart';
import 'package:pa_mobile/shared/services/storage/stay_login_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51Nt6kLAMwqibCvaHmV7QHn8TywuAhZM0CG0kSTCm5BVM0JKRxRheV3HaqKgZC2j13cQNlGJnV4SneBSZtHxHc3NM00pHQS5Iur';
  await dotenv.load(fileName: 'assets/.env');
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  final isLogged = await autoLogin();
  print(isLogged);
  final isVolunteer = await isVolunteers();
  print(isVolunteer);
  runApp(MyApp(
    isLogged: isLogged,
    isVolunteer: isVolunteer,
  ));
}

Future<bool> autoLogin() async {
  if (await StayLoginSecureStorage().readStayLogin()) {
    final jwtToken = await JwtSecureStorage().readJwtToken();
    return jwtToken != null;
  }
  await JwtSecureStorage().deleteJwtToken();
  return false;
}

Future<bool> isVolunteers() async {
  if (await StayLoginSecureStorage().readIsVolunteer()) {
    return true;
  }
  return false;
}
