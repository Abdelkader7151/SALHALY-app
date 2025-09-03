# SALHALY (Flutter)

A service marketplace mobile app for booking home and mechanical services.

## 📊 Project: Service Marketplace App

Onboarding, authentication, category browsing, worker listings, bookings, payments, QR codes, and history.

### 🎯 Project Overview
- **UI/UX**: Designed in Figma (component-based, responsive; consistent typography and spacing)
- **Goal**: Provide an end-to-end booking experience
- **Approach**: Flutter app with Firebase backend and structured screens/services
- **Tools**: Flutter/Dart, Firebase (Core/Auth/Firestore)

### 🧭 Navigation Map
- Splash → Onboarding (`main.dart` → `SplashScreen` → `MyWidget`)
- MyWidget →
  - Sign up → `Signup.dart`
  - Login → `login.dart`
- After login → `HomeScreen.dart` (`HomePage`) with:
  - Side Drawer → Profile (`profile.dart`), Payment History (`PaymentHistory.dart`), About (`AboutPage.dart`), Promo Codes (`PromoCodes.dart`)
  - Quick Access + Categories → `CategoryPage.dart` → `workersList.dart` (by `categoryNumber`)
  - Notifications menu (inline in Home)
- Booking/Payment → Firestore `paymentHistory` entries; QR flow via `QrCodePage.dart`

### 🗄️ Database (Firestore) Implementation
- Collections observed in code:
  - `Users` — fields include: `email`, `firstName`, `lastName`, `photo`, `region`
  - `Workers` — fields include: `firstName`, `lastName`, `mobileNumber`, category fields
  - `paymentHistory` — fields include: `email`, `worker`, `date`, `time`, `state` (Active/Past/Cancelled)
- Data access highlighted in code:
  - Login updates `paymentHistory` state to `Past` if older than 2 hours
  - Drawer fetches `Users` by current email; worker phone lookup via `Workers`

### 💻 Code Implementation

#### Setup and Execution
```bash
# From my_application/
flutter pub get
flutter run
```
Ensure platform Firebase configs are valid for your environment.

#### Core Structure
```text
lib/
  main.dart              # Firebase init, splash → onboarding
  login.dart, Signup.dart
  HomeScreen.dart, CategoryPage.dart, workersList.dart
  payment.dart, PaymentHistory.dart, PromoCodes.dart, QrCodePage.dart
  profile.dart, AboutPage.dart, Feedback.dart, tracking.dart
  UserService.dart       # Firestore helpers for users and payments
assets/
  images/, gif/, users/, workers/
```

### 📈 Screens & Visuals
- Splash/home visuals and previews:

![gif](./assets/gif/salahly.gif)

- Logo and QR code:

![Logo](./assets/images/logoNoBg.png)
![QR](./assets/images/qrcode.png)

### 🔍 Key Features
- Auth (login/signup) with Firebase Auth
- Category browsing and worker list with ratings
- Booking with payments and promo codes
- QR code verification and history management

### 🛠️ Technologies Used
- Flutter/Dart
- Firebase Core/Auth/Firestore
- google_fonts, carousel_slider, fluttertoast, url_launcher, intl, font_awesome_flutter

### 📝 Notes
1. Drawer user card binds to Firestore `Users` data by email.
2. `paymentHistory` entries auto-marked as Past after 2 hours on next login.
3. Navigation uses `Navigator.push` and typed routes to feature screens.

---

## 👨‍💻 Author

**Abdelrhman Abdelkader**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Abdelkader7151)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/abdelrhman-abdelkader-6313a4291/)

