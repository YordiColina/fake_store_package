import 'package:fake_store_package/models/auth/login_request.dart';
import 'package:fake_store_package/models/user/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_package/models/user/user.dart';

void main() {
  group('LoginRequest Model', () {
    test('should correctly serialize and deserialize LoginRequest', () {
      final loginJson = {
        'username': 'test_user',
        'password': 'secure_password'
      };

      final loginRequest = LoginRequest.fromJson(loginJson);
      expect(loginRequest.username, 'test_user');
      expect(loginRequest.password, 'secure_password');

      final jsonOutput = loginRequest.toJson();
      expect(jsonOutput, loginJson);
    });
  });

  group('User Model', () {
    final userJson = {
      'email': 'test@example.com',
      'username': 'test_user',
      'password': 'secure_password',
      'name': {'firstname': 'John', 'lastname': 'Doe'},
      'address': {
        'city': 'Test City',
        'street': 'Test Street',
        'number': 123,
        'zipcode': '12345',
        'geolocation': {'lat': '12.3456', 'long': '-65.4321'}
      },
      'phone': '123-456-7890'
    };

    test('should correctly serialize and deserialize User', () {
      final user = User.fromJson(userJson);
      expect(user.email, 'test@example.com');
      expect(user.username, 'test_user');
      expect(user.password, 'secure_password');
      expect(user.name.firstname, 'John');
      expect(user.name.lastname, 'Doe');
      expect(user.address.city, 'Test City');
      expect(user.address.geolocation.lat, '12.3456');

      final jsonOutput = user.toJson();
      expect(jsonOutput, userJson);
    });
  });

  group('GetUser Model', () {
    final getUserJson = {
      'email': 'getuser@example.com',
      'username': 'get_user',
      'password': 'get_password',
      'name': {'firstname': 'Jane', 'lastname': 'Smith'},
      'address': {
        'city': 'Another City',
        'street': 'Another Street',
        'number': 456,
        'zipcode': '54321',
        'geolocation': {'lat': '98.7654', 'long': '-12.3456'}
      },
      'phone': '987-654-3210'
    };

    test('should correctly serialize and deserialize GetUser', () {
      final getUser = GetUser.fromJson(getUserJson);
      expect(getUser.email, 'getuser@example.com');
      expect(getUser.username, 'get_user');
      expect(getUser.password, 'get_password');
      expect(getUser.name.firstname, 'Jane');
      expect(getUser.address.street, 'Another Street');
      expect(getUser.address.geolocation.long, '-12.3456');

      final jsonOutput = getUser.toJson();
      expect(jsonOutput, getUserJson);
    });
  });

  group('Name Model', () {
    test('should correctly serialize and deserialize Name', () {
      final nameJson = {'firstname': 'Alice', 'lastname': 'Brown'};

      final name = Name.fromJson(nameJson);
      expect(name.firstname, 'Alice');
      expect(name.lastname, 'Brown');

      final jsonOutput = name.toJson();
      expect(jsonOutput, nameJson);
    });
  });

  group('Address Model', () {
    test('should correctly serialize and deserialize Address', () {
      final addressJson = {
        'city': 'Some City',
        'street': 'Main Street',
        'number': 789,
        'zipcode': '67890',
        'geolocation': {'lat': '11.1111', 'long': '-99.9999'}
      };

      final address = Address.fromJson(addressJson);
      expect(address.city, 'Some City');
      expect(address.street, 'Main Street');
      expect(address.number, 789);
      expect(address.zipcode, '67890');
      expect(address.geolocation.lat, '11.1111');

      final jsonOutput = address.toJson();
      expect(jsonOutput, addressJson);
    });
  });

  group('Geolocation Model', () {
    test('should correctly serialize and deserialize Geolocation', () {
      final geolocationJson = {'lat': '33.3333', 'long': '-88.8888'};

      final geolocation = Geolocation.fromJson(geolocationJson);
      expect(geolocation.lat, '33.3333');
      expect(geolocation.long, '-88.8888');

      final jsonOutput = geolocation.toJson();
      expect(jsonOutput, geolocationJson);
    });
  });
}
