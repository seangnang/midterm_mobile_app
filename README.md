# WorkPulse – Flutter Employee & Product Management Application

A complete, modern, enterprise-grade mobile application developed with **Flutter, Dart, GetX, Dio, Repository Pattern, and JWT Authentication**.

Designed with a clean, high-end **Blue & White** visual identity (#2563EB Professional Blue & #FFFFFF Crisp White) following clean architecture and separation of concerns.

---

## 📱 Technology Stack

- **Framework**: Flutter & Dart (Null-Safe)
- **State Management, DI & Navigation**: GetX (`get: ^4.6.6`)
- **Networking & REST API**: Dio (`dio: ^5.7.0`)
- **Session & Token Persistence**: GetStorage (`get_storage: ^2.1.1`)
- **Design Pattern**: Repository Pattern (Providers ➔ Repositories ➔ Controllers ➔ Views)
- **Security**: JWT Authentication with Dio Interceptors (Automatic Token Attachment, 401 Session Expiration & Refresh)
- **Formatting & Dates**: Intl (`intl: ^0.19.0`)

---

## 🎨 Design Direction: Blue & White Palette

- **Primary Color**: `#2563EB` (Professional Royal Blue)
- **Primary Dark**: `#1D4ED8`
- **Primary Container**: `#EFF6FF` (Soft Light Blue)
- **Background**: `#F8FAFC` (Clean Crisp Light White)
- **Cards & Surfaces**: `#FFFFFF` (Pure White with Subtle Shadows)
- **Typography & Details**: Dark Slate Navy (`#0F172A`) & Crisp White text on Blue backgrounds

---

## 🚀 Key Modules & Capabilities

### 1. Authentication & JWT Management
- **Login Screen**:
  - Email / Username and Password fields
  - Password visibility toggle (Show / Hide)
  - "Remember session" checkbox
  - Real-time form validation
  - API error message feedback banner
  - Pre-filled demo credentials chip for instant testing
- **JWT Security & Interceptors**:
  - Interceptor automatically attaches `Authorization: Bearer <token>` to all protected endpoints.
  - Automatically captures HTTP 401 errors, attempts token refresh, or safely clears session and redirects to `/login`.
  - Clean Logout action with confirmation dialog.

### 2. Dashboard & Navigation
- **Top Welcome Card**:
  - Gradient Blue hero card with white typography and logged-in user profile avatar.
- **Summary Metrics Cards**:
  - Live Total Products count
  - Live Total Employees count
- **Quick Action Buttons**:
  - Add Employee, Products Catalog, Staff List, Account Profile.
- **Recent Employees**:
  - Quick view of recent employee records.
- **Bottom Navigation Bar**:
  - Home, Products, Employees, Profile.

### 3. Product Catalog Module
- **Product Cards**:
  - High-res product images with fallback placeholders and loading indicators.
  - Product title, category tag, rating with star icon, brand, and stock status.
  - Formatted price in prominent blue.
- **Search & Filtering**:
  - Real-time search query with instant clear button.
  - Horizontally scrollable category filter chips.
- **Details Bottom Sheet**:
  - Interactive bottom sheet displaying full product details and description upon tap.
- **States**:
  - Loading skeleton / indicator, empty state, and error state with retry.
  - Pull-to-refresh support.

### 4. Employee Management Module (Full CRUD)
- **Employee Directory**:
  - Clean list of employee cards with profile avatars / initials.
  - Displays Full Name, Position, Department, Email, and Phone.
  - Real-time search by name, position, or department.
- **Create Employee (POST)**:
  - Form with First Name, Last Name, Email, Phone, Position, Department, and Address.
  - Strict email and phone number format validation.
  - Prepend created employee directly to list on success.
- **Update Employee (PUT/PATCH)**:
  - Edit existing employee with form pre-population.
  - Real-time update in reactive list.
- **Delete Employee (DELETE)**:
  - Destructive action with confirmation dialog clearly showing the employee's name.
  - Instant removal from reactive state upon API confirmation.
  - GetX Snackbar feedback.

### 5. Profile & Settings
- Account details overview.
- Current active REST API Base URL indicator.
- Sign out action.

---

## 📂 Project Architecture

```
lib/
├── main.dart                               # App entry point, session check & initial route
│
├── app/
│   ├── bindings/
│   │   └── initial_binding.dart            # Global dependency injection (Repositories, Providers, Controllers)
│   ├── routes/
│   │   ├── app_pages.dart                  # GetX route mappings & page transitions
│   │   └── app_routes.dart                 # Named route constants
│   └── theme/
│       ├── app_colors.dart                 # Blue & White color system
│       ├── app_text_styles.dart            # Typography hierarchy
│       └── app_theme.dart                  # Light Theme Material 3 configuration
│
├── core/
│   ├── network/
│   │   ├── api_client.dart                 # Centralized Dio HTTP client
│   │   ├── api_endpoints.dart              # Single source of truth for Base URL & endpoints
│   │   └── auth_interceptor.dart           # JWT bearer token & 401 handling interceptor
│   ├── storage/
│   │   └── token_storage.dart              # GetStorage persistence for tokens and user session
│   ├── utils/
│   │   ├── app_exceptions.dart             # Standardized error & exception handling
│   │   └── validators.dart                 # Form validation rules (email, phone, required)
│   └── widgets/
│       ├── custom_button.dart              # Reusable elevated and outlined buttons with loading
│       ├── custom_text_field.dart          # Reusable styled text field with error & password support
│       ├── empty_state_widget.dart         # Friendly empty illustration & message
│       ├── error_widget.dart               # Error state widget with retry button
│       └── loading_widget.dart             # Centered loading spinner
│
├── data/
│   ├── models/
│   │   ├── employee_model.dart             # Employee model with initials, full name & JSON serialization
│   │   ├── product_model.dart              # Product model with price formatting & JSON serialization
│   │   └── user_model.dart                 # User auth profile model
│   ├── providers/
│   │   ├── auth_api_provider.dart          # Raw REST API calls for auth
│   │   ├── employee_api_provider.dart      # Raw REST API calls for employees (CRUD)
│   │   └── product_api_provider.dart       # Raw REST API calls for products
│   └── repositories/
│       ├── auth_repository.dart            # Auth business logic & session caching
│       ├── employee_repository.dart        # Employee data mapping & CRUD operations
│       └── product_repository.dart         # Product data mapping, count & categories
│
├── features/
│   ├── auth/
│   │   ├── controllers/auth_controller.dart
│   │   └── views/login_view.dart
│   ├── dashboard/
│   │   ├── controllers/dashboard_controller.dart
│   │   └── views/
│   │       ├── dashboard_view.dart         # Root Scaffold with BottomNavigationBar
│   │       └── home_tab_view.dart          # Dashboard stats, quick actions & recent employees
│   ├── employees/
│   │   ├── controllers/employee_controller.dart
│   │   ├── views/
│   │   │   ├── employee_form_view.dart     # Shared Add & Edit form view
│   │   │   └── employee_list_view.dart     # Employees list with search & actions
│   │   └── widgets/employee_card.dart
│   ├── products/
│   │   ├── controllers/product_controller.dart
│   │   ├── views/product_list_view.dart    # Product grid/list with filters
│   │   └── widgets/product_card.dart
│   └── profile/
│       ├── controllers/profile_controller.dart
│       └── views/profile_view.dart
│
└── shared/
    └── constants/
        └── app_constants.dart              # App name, demo credentials & defaults
```

---

## ⚙️ Configuring the REST API Base URL

The application is configured out of the box to connect to a live REST API (`https://dummyjson.com`), meaning it works immediately with full authentication, products listing, and employee CRUD without any local backend required.

To connect to your own custom backend server (e.g. Node.js, Express, FastAPI, Django, Laravel):

1. Open `lib/core/network/api_endpoints.dart`:
```dart
class ApiEndpoints {
  // Update this to your backend server URL:
  static String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  // static String baseUrl = 'http://localhost:8000/api'; // iOS Simulator / Web / Windows
  ...
}
```

---

## 🔑 Demo Credentials (Out of the Box)

For immediate testing, the login screen comes pre-filled with demo credentials:

- **Username**: `seangnuy`
- **Password**: `nang123`

You can also enter any other valid credentials configured on your API.

---

## 🧪 Running & Verifying

### 1. Fetch Dependencies
```bash
flutter pub get
```

### 2. Run Static Analysis (0 errors, 0 warnings)
```bash
flutter analyze
```

### 3. Run Unit & Model Tests (All passing)
```bash
flutter test
```

### 4. Run the Mobile Application
```bash
flutter run
```
