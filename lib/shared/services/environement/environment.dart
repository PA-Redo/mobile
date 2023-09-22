class Environment {
  static String get apiURL => const String.fromEnvironment(
        'API_URL',
        //defaultValue: 'https://api.nainssa.fr:443',
        defaultValue: 'http://localhost:8080',
      );
}
