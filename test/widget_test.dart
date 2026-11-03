import 'package:flutter_test/flutter_test.dart';
import 'package:midterm_mobile_app/core/utils/validators.dart';
import 'package:midterm_mobile_app/data/models/employee_model.dart';
import 'package:midterm_mobile_app/data/models/product_model.dart';
import 'package:midterm_mobile_app/data/models/user_model.dart';

void main() {
  group('Data Models Tests', () {
    test('UserModel parses correctly from JSON', () {
      final json = {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.smith@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Smith',
        'image': 'https://dummyjson.com/icon/emilys/128',
        'accessToken': 'jwt_access_token_sample',
        'refreshToken': 'jwt_refresh_token_sample',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.username, 'emilys');
      expect(user.fullName, 'Emily Smith');
      expect(user.token, 'jwt_access_token_sample');
    });

    test('ProductModel parses correctly and formats price', () {
      final json = {
        'id': 101,
        'title': 'High-End Laptop',
        'description': 'Powerful development machine',
        'price': 1299.99,
        'rating': 4.85,
        'stock': 15,
        'category': 'laptops',
        'brand': 'TechCorp',
        'thumbnail': 'https://example.com/laptop.jpg',
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 101);
      expect(product.title, 'High-End Laptop');
      expect(product.formattedPrice, '\$1299.99');
      expect(product.displayImage, 'https://example.com/laptop.jpg');
    });

    test('EmployeeModel parses initials, full name, and nested company data', () {
      final json = {
        'id': 42,
        'firstName': 'Alexander',
        'lastName': 'Pierce',
        'email': 'alexander.pierce@company.com',
        'phone': '+1 555-0123',
        'company': {
          'title': 'Lead Architect',
          'department': 'Cloud Infrastructure',
        },
        'address': {
          'address': '742 Evergreen Terrace',
          'city': 'Springfield',
        },
      };

      final employee = EmployeeModel.fromJson(json);

      expect(employee.id, 42);
      expect(employee.fullName, 'Alexander Pierce');
      expect(employee.initials, 'AP');
      expect(employee.position, 'Lead Architect');
      expect(employee.department, 'Cloud Infrastructure');
      expect(employee.address, '742 Evergreen Terrace, Springfield');
    });
  });

  group('Validators Tests', () {
    test('validateRequired returns error on empty input', () {
      expect(Validators.validateRequired(''), isNotNull);
      expect(Validators.validateRequired('   '), isNotNull);
      expect(Validators.validateRequired('Valid'), isNull);
    });

    test('validateStrictEmail enforces email format', () {
      expect(Validators.validateStrictEmail('invalid-email'), isNotNull);
      expect(Validators.validateStrictEmail('test@domain.com'), isNull);
    });

    test('validatePhone validates phone numbers', () {
      expect(Validators.validatePhone('12'), isNotNull);
      expect(Validators.validatePhone('+1 555-0199'), isNull);
      expect(Validators.validatePhone('0987654321'), isNull);
    });
  });
}
