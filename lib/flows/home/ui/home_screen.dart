import 'package:flutter/material.dart';
import 'package:pa_mobile/flows/authentication/ui/login_screen.dart';
import 'package:pa_mobile/flows/inscription/ui/register_screen.dart';
import 'package:pa_mobile/shared/widget/xbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntent;

  TextStyle textTitleStyle(Color color) {
    return TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  TextStyle textSubTitleStyle() {
    return const TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle textDescriptionStyle() {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black.withOpacity(0.5),
    );
  }

  Widget actionDecorator({required Widget child}) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 78,
                        backgroundImage:
                            AssetImage('assets/images/drapeau.jpeg'),
                      ),
                    ),
                    Text(
                      'CROIX',
                      style: textTitleStyle(Colors.black),
                    ),
                    Text(
                      'ROUGE',
                      style: textTitleStyle(Colors.redAccent),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Bienvenue',
                      style: textSubTitleStyle(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Application dédiée aux bénéficiare de l'unité local du Val d'Orge.",
                        textAlign: TextAlign.center,
                        style: textDescriptionStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(150, 150), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.redAccent, // button color
                  child: InkWell(
                    splashColor: Colors.black, // splash color
                    onTap: () async {
                      await makePayment();
                    }, // button pressed
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ), // icon
                        Text(
                          'Donate ?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actionDecorator(
              child: Row(
                children: [
                  Expanded(
                    child: XButton(
                      borderRadius: 0,
                      color: Colors.redAccent,
                      onPressed: () => onRegister(context),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: XButton(
                      borderRadius: 0,
                      color: Colors.white,
                      onPressed: () => onConnect(context),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'EUR');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Successful!"),
                ],
              ),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  void onRegister(BuildContext context) {
    Navigator.pushNamed(
      context,
      RegisterScreen.routeName,
    );
  }

  void onConnect(BuildContext context) {
    Navigator.pushNamed(
      context,
      LoginScreen.routeName,
    );
  }
}
