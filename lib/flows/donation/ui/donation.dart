class Donation {
  Donation({
    required this.amount,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.civility,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.country,
  });

  final int amount;
  final String email;
  final String firstName;
  final String lastName;
  final String civility;
  final String address;
  final String city;
  final String zipCode;
  final String country;

  String encode() {

    return '{'
        '"amount": $amount,'
        '"email": "$email",'
        '"firstName": "$firstName",'
        '"lastName": "$lastName",'
        '"civility": "$civility",'
        '"address": "$address",'
        '"city": "$city",'
        '"zipCode": "$zipCode",'
        '"country": "$country"'
        '}';
  }
}
