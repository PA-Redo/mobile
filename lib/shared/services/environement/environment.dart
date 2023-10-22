class Environment {
  static String get apiURL => const String.fromEnvironment(
        'API_URL',
        defaultValue: 'https://back.nainssa.com',
        //defaultValue: 'http://localhost:8080',
      );
}
