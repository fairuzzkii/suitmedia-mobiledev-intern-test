# Suitmedia Mobile Developer Intern Test

This Flutter application was built to complete the **Suitmedia Mobile Developer Intern Test**.  
It uses **Flutter SDK 3.8.1** and **Provider** for state management.

---

## 📱 Demo & Screenshots

[![Watch the demo](https://img.youtube.com/vi/0jNznlFy1fI/0.jpg)](https://www.youtube.com/watch?v=0jNznlFy1fI)


## 📸 Screenshots

<p float="left">
  <img src="https://github.com/user-attachments/assets/924b4ae0-bef5-4afa-9584-c3a46ec1e379" width="30%" />
  <img src="https://github.com/user-attachments/assets/2c129bb3-d7ee-4878-8d9d-f6ef7c377f11" width="30%" />
  <img src="https://github.com/user-attachments/assets/fc5b53dc-3b8e-4934-9b64-27857b612617" width="30%" />
</p>

---

## 🧩 Features Overview

### 🔹 First Screen (Palindrome Check)
- Contains **2 input fields**:
  - Name input
  - Sentence input (for palindrome check)
- **Check Button**: Displays dialog with:
  - `"isPalindrome"` if the sentence is a palindrome
  - `"not palindrome"` otherwise  
  Examples:
  - `kasur rusak` → ✅ isPalindrome
  - `step on no pets` → ✅ isPalindrome
  - `suitmedia` → ❌ not palindrome
- **Next Button**: Navigates to Second Screen

---

### 🔹 Second Screen (Welcome Page)
- Displays static text: `Welcome`
- Shows:
  - Name entered from First Screen
  - Selected User's Name (initially empty)
- **Choose a User Button**: Navigates to Third Screen

---

### 🔹 Third Screen (User List)
- Fetches user list from `https://reqres.in/api/users`
- Shows: `avatar`, `first_name`, `last_name`, `email`
- Features:
  - Pull to refresh
  - Pagination when scrolling to bottom (`page` & `per_page` query params)
  - Empty state UI if no data is returned
- On selecting a user:
  - Returns to **Second Screen**
  - Updates “Selected User Name” label (without navigating to a new screen)

---

## 🛠 Tech Stack

- **Flutter SDK**: 3.8.1
- **State Management**: Provider
- **HTTP Client**: `http`
- **UI**: Material design components
- **API**: Uses Reqres API to fetch user data

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- VS Code / Android Studio
- Emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/fairuzzkii/suitmedia-mobiledev-intern-test.git

# Navigate to the project folder
cd suitmedia-mobiledev-intern-test

# Get dependencies
flutter pub get

# Run the app
flutter run
