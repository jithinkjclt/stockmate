# StockMate – Flutter Inventory Management App

## Overview
StockMate is a Flutter mobile app designed to manage products efficiently. It demonstrates authentication, data handling, state management, and reporting features using modern Flutter practices.

---

## Features
- Authentication with Firebase (login, logout, persistent session using Shared Preferences)
- Product management: add, edit, delete, and view product details (id, title, description, status, createdDate)
- Dashboard showing summary (total items, in-stock vs out-of-stock)
- List and detail screens with card-based UI
- Export and share reports in PDF or CSV format
- Error handling for empty states, form validation, and network errors

---

## Tech Stack
- Flutter
- State Management: Cubit (flutter_bloc)
- Architecture: Clean Architecture (Data, Domain, Presentation layers)
- Backend: Firebase (Auth + Firestore)
- Reporting: pdf, printing, csv packages
- Persistent Login: Shared Preferences

---

