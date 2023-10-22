import 'package:form_field_validator/form_field_validator.dart';

class FieldValidators {
  static FieldValidator<dynamic> get cityValidator => MultiValidator([
    RequiredValidator(errorText: 'Ville est requise'),
    MinLengthValidator(2, errorText: 'Une ville doit contenir au moins 2 caractères'),
    MaxLengthValidator(50, errorText: 'Une ville doit contenir au plus 50 caractères'),
  ]);

  static FieldValidator<dynamic> get postalCodeValidator => MultiValidator([
    RequiredValidator(errorText: 'Code postal est requis'),
    MinLengthValidator(5, errorText: 'Un code postal doit contenir au moins 5 chiffres'),
    MaxLengthValidator(5, errorText: 'Un code postal doit contenir au plus 5 chiffres'),
  ]);

  static FieldValidator<dynamic> get addressValidator => MultiValidator([
    RequiredValidator(errorText: 'Adresse est requise'),
    MinLengthValidator(2, errorText: 'Une adresse doit contenir au moins 2 caractères'),
    MaxLengthValidator(50, errorText: 'Une adresse doit contenir au plus 50 caractères'),
  ]);

  static FieldValidator<dynamic> get emailValidator => MultiValidator([
    RequiredValidator(errorText: 'Email est requis'),
    EmailValidator(errorText: 'Email n\'est pas valide'),
  ]);

  static FieldValidator<dynamic> get nameValidator => MultiValidator([
    RequiredValidator(errorText: 'Nom est requis'),
    MinLengthValidator(2, errorText: 'Un nom doit contenir au moins 2 caractères'),
    MaxLengthValidator(50, errorText: 'Un nom doit contenir au plus 50 caractères'),
  ]);

  static TextFieldValidator get passwordValidator => RequiredValidator(errorText: 'Mot de passe requis');


  static FieldValidator<dynamic> get phoneNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Numéro de téléphone requis'),
    MinLengthValidator(10, errorText: 'Un numéro de téléphone doit 10 chiffres'),
    MaxLengthValidator(10, errorText: 'Un numéro de téléphone doit 10 chiffres'),
  ]);

  static FieldValidator<dynamic> get socialWorkerNumberValidator => MultiValidator([
    RequiredValidator(errorText: 'Un numéro de travailleur social est requis'),
    MinLengthValidator(15, errorText: 'Un numéro de travailleur social doit contenir au moins 15 chiffres'),
    MaxLengthValidator(15, errorText: 'Un numéro de travailleur social doit contenir au plus 15 chiffres'),
  ]);

  static FieldValidator<dynamic> get amountValidator => MultiValidator([
    RequiredValidator(errorText: 'Un montant est requis'),
    MinLengthValidator(1, errorText: 'Le montant minimum est de 1€'),
    MaxLengthValidator(4, errorText: 'Le montant maximum est de 9999€'),
    // ne pas authoriser le zero
    PatternValidator(r'^(?!0+(?:\.0+)?$)(?:[1-9]\d*|0)(?:\.\d+)?$', errorText: 'Le montant ne peut pas être égal à 0€'),
  ]);
}