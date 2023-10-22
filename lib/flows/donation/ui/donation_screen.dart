import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa_mobile/flows/donation/ui/donation.dart';
import 'package:pa_mobile/flows/donation/ui/summary_screen.dart';
import 'package:pa_mobile/shared/validators/field_validators.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  static const routeName = '/donation';

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController civilityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  int amount = 0;
  int _index = 0;
  final _amountFormKey = GlobalKey<FormState>();
  final _personalInformationFormKey = GlobalKey<FormState>();
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  List<bool> hasTryToSubmit = [
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation'),
      ),
      body: Center(
        child: Stepper(
          currentStep: _index,
          controlsBuilder: (context, detail) =>
              Wrap(
                children: <Widget>[
                  if (!(_index == 0))
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: onStepCancel,
                        child: const Text('Précédent'),
                      ),
                    ),
                  if (!(_index == 1))
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: onStepContinue,
                        child: const Text('Suivant'),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextButton(
                        onPressed: makePayment,
                        child: const Text("Récapitulatif"),
                      ),
                    ),
                ],
              ),
          onStepTapped: (int index) {
            if (index < _index) {
              setState(() {
                _index = index;
              });
            } else if (index == _index) {} else {
              onStepContinue();
            }
          },
          steps: <Step>[
            Step(
              isActive: _index >= 0,
              title: const Text('Mon Soutien'),
              state: _index >= 0 && hasTryToSubmit[0]
                  ? (isAmountFormValid()
                  ? StepState.complete
                  : StepState.error)
                  : StepState.indexed,
              content: Form(
                key: _amountFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Montant',
                          icon: Icon(Icons.euro),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.amountValidator,
                        onSaved: (value) {
                          amount = int.parse(value!);
                        },
                        focusNode: _focusNodes[0],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Step(
              state: _index >= 1 && hasTryToSubmit[1]
                  ? (isPersonalInformationFormValid()
                  ? StepState.complete
                  : StepState.error)
                  : StepState.indexed,
              isActive: _index >= 1,
              title: const Text('Informations Personnelles'),
              content: Form(
                key: _personalInformationFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'email@email.com',
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        validator: FieldValidators.emailValidator,
                        focusNode: _focusNodes[1],
                      ),
                    ),
                    Padding(
                      //civilite choose between M, Mme, Mlle
                      padding: const EdgeInsets.all(4),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Civilité',
                          icon: Icon(Icons.person),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ), items: const [
                        DropdownMenuItem(
                          value: 'M',
                          child: Text('M'),
                        ),
                        DropdownMenuItem(
                          value: 'Mme',
                          child: Text('Mme'),
                        ),
                        DropdownMenuItem(
                          value: 'Mlle',
                          child: Text('Mlle'),
                        ),
                      ],
                        onChanged: (Object? value) {
                          civilityController.text = value as String;
                        },
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          icon: Icon(Icons.account_circle),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.nameValidator,
                        focusNode: _focusNodes[3],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          icon: Icon(Icons.account_circle),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        controller: lastNameController,
                        validator: FieldValidators.nameValidator,
                        focusNode: _focusNodes[4],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Adresse',
                          icon: Icon(Icons.home),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.addressValidator,
                        focusNode: _focusNodes[5],
                        controller: addressController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Code Postal',
                          icon: Icon(Icons.home),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.postalCodeValidator,
                        focusNode: _focusNodes[6],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        controller: zipCodeController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ville',
                          icon: Icon(Icons.home),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: FieldValidators.cityValidator,
                        focusNode: _focusNodes[7],
                        controller: cityController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pays',
                          icon: Icon(Icons.home),
                          fillColor: Color(0xfff3f3f4),
                          filled: true,
                          border: OutlineInputBorder(),
                        ), items: const [
                        DropdownMenuItem(
                          value: 'France',
                          child: Text('France'),
                        ),
                        DropdownMenuItem(
                          value: 'Belgique',
                          child: Text('Belgique'),
                        ),
                        DropdownMenuItem(
                          value: 'Suisse',
                          child: Text('Suisse'),
                        ),
                      ],
                        onChanged: (Object? value) {
                          countryController.text = value as String;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onStepCancel() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
    setState(() {});
  }

  void onStepContinue() {
    switch (_index) {
      case 0:
        hasTryToSubmit[0] = true;
        if (_amountFormKey.currentState!.validate()) {
          _amountFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      case 1:
        hasTryToSubmit[1] = true;
        if (_personalInformationFormKey.currentState!.validate()) {
          _personalInformationFormKey.currentState!.save();
          if (_index <= 2) {
            setState(() {
              _index += 1;
            });
          }
        }
        break;
      default:
        break;
    }
    setState(() {});
  }

  bool isAmountFormValid() {
    return _amountFormKey.currentState!.validate();
  }

  bool isPersonalInformationFormValid() {
    return _personalInformationFormKey.currentState!.validate();
  }

  Future<void> makePayment() async {
    if (!isAmountFormValid() || !isPersonalInformationFormValid()) {
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(
          donation: Donation(
            amount: amount,
            email: emailController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            address: addressController.text,
            city: cityController.text,
            civility: civilityController.text,
            country: countryController.text,
            zipCode: zipCodeController.text,
          ),
        ),
      ),
    );
  }
}
