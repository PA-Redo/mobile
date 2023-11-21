class Environment {
  static String get apiURL => const String.fromEnvironment(
        'API_URL',
        //defaultValue: 'https://back.nainssa.com',
        //defaultValue: 'http://localhost:8080',
        defaultValue: 'http://10.0.2.2:8080',
      );
}
