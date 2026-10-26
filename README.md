# 🕌 Salaama Muslim Junior School - Management System
**DESTINED TO SUCCEED - بسم الله الرحمن الرحيم**

Complete School Management System for Salaama Muslim Junior School, Nansana - Kampala, Uganda.

## 🎓 Features

### 10 User Roles (First Time SignUp + Category + Second Time Auto Login)
1. **Super Admin** - Full control, Staff management, Fees, Reports
2. **Head Teacher** - Academics, Teachers, Classes P7
3. **Deputy Head Teacher** - Academics support
4. **Director of Studies (DOS)** - Exams, Report cards
5. **Bursar** - Fees tracking, Cashflow, Payment vouchers
6. **Teacher** - Attendance, Marks, Tahfiizu, Chat with parents
7. **Student** - View marks, Fees balance, Tahfiizu progress
8. **Parent** - View child performance, Fees, Chat with teacher
9. **Support Staff** - Limited access
10. **Guest** - View only

### 4 Tabs (All Dashboards)
1. **Academics** - Classes P7, Subjects, Marks, Report Cards (EN/AR)
2. **Fees & Finance** - Fees tracking, Cashflow, PDF Receipt with Share
3. **Tahfiizu** - Qur'an Juz 1-30, ممتاز Certificate, Arabic progress
4. **Communication** - Chat Teacher-Parent-Student, Announcements

### Key Workflows (As Requested)
- **SignUp First Time:** Name + Email + Phone + Category → Save to Firestore
- **Select Category:** After SignUp, Select 1 of 10 Categories → Save
- **SignIn Second Time:** Email + Password Only → Auto redirect to Dashboard by Category (No Category select again)
- **All PDFs:** Exact logo on all PDFs (Fees Receipt, Report Card, ممتاز Certificate) + Share button

## 🛠️ Tech Stack
- Flutter 3.x
- Firebase Auth + Firestore
- Provider State Management
- PDF + Printing (EN/AR with Arabic font)
- Share Plus

## 📁 Project Structure