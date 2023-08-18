const String apiUrl =
    String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');
const String baseUrl = '$apiUrl/v1';
const String graphqlUrl = '$apiUrl/graphql';
const String socketUrl = '$apiUrl/socket';
