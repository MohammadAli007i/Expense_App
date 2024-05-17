
**Expense Tracker**
A Flutter-based mobile application for managing personal expenses. Users can add, update, delete, and filter expenses, with persistent data storage.

**Features**
Expense Management: Add, update, delete expenses with details such as amount, title, description, and date.
Date Filtering: Filter expenses by a date range.
Form Validation: Ensures input fields are valid before submission.
Data Persistence: Stores expense records in a local database.

**Screenshots**
![Screenshot 2024-05-17 115354](https://github.com/MohammadAli007i/Expense_App/assets/115215150/f127e1ca-e0c1-468e-b7cb-a57b04210a38)
![Screenshot 2024-05-17 193036](https://github.com/MohammadAli007i/Expense_App/assets/115215150/1b563116-f594-4950-a20d-9dd72255be1c)

**Prerequisites**
Flutter (version 2.0 or above)
Dart
A code editor (e.g., Android Stdio)

**Getting Started**

Clone the repository
git clone https://github.com/MohammadAli007i/expense_tracker.git
cd expense_tracker
Install dependencies

flutter pub get
Run the app
Connect a physical device or start an emulator, then run:


flutter run
Building for Release
To build the app for release:


flutter build apk --release
The release APK will be generated in the build/app/outputs/flutter-apk directory.

Folder Structure

expense_tracker/
|- android/             # Android-specific files
|- ios/                 # iOS-specific files
|- lib/                 # Dart code for the app
   |- database/         # Database helper class
   |- model/            # Data model class
   |- screens/          # UI screens
   |- main.dart         # Entry point of the app
|- test/                # Unit and widget tests
|- pubspec.yaml         # Project dependencies and configurations
Database Setup
The app uses a local SQLite database for storing expenses. No additional setup is required as the database is managed within the app.

Usage
Add Expense: Tap the floating action button (‘+’ icon), fill in the details, and tap "Add".
Update Expense: Tap on an existing expense to edit, modify the fields, and tap "Update".
Delete Expense: Swipe left on an expense item and tap the delete icon.
Filter Expenses: Tap the filter icon in the app bar, select a date range, and apply the filter.
Contributing
Contributions are welcome! Please follow these steps:

Fork the repository.
Create a new branch (git checkout -b feature/your-feature).
Commit your changes (git commit -am 'Add some feature').
Push to the branch (git push origin feature/your-feature).
Create a new Pull Request.
License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgments
Flutter
Dart
