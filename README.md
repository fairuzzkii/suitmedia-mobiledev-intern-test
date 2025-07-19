# Suitmedia Mobile Developer Intern Test

This Flutter application was built to complete the **Suitmedia Mobile Developer Intern Test**.  
It uses **Flutter SDK 3.8.1** and **Provider** for state management.

---

## 📱 Demo & Screenshots

https://user-images.githubusercontent.com/your-username/demo-video.mp4

| First Screen | Second Screen| Third Screen |
|-----------------|---------------------|-------------|
| ![1](screenshots/1.png) | ![2](screenshots/2.png) | ![3](screenshots/3.png) |

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
