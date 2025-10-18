## flutter_alarm_app
**A flutter project to demonstrate my problem-solving skills**

## Features Implemented

**User Management**
- Abstract `User` class with `Id`, `Name`, `Email`, and `ShowInfo()` method  
- Derived classes: `Student`, `Mentor`, `Organization` (demonstrates inheritance & polymorphism)

**Internship Module**
- `Internship` class with `Title`, `Duration`, `Mentor`, and list of `Applicants`  
- Uses **composition** — `Organization` *has* multiple `Internship` objects

**Task System**
- `TaskItem` class with private fields and public properties (shows **encapsulation**)  
- Students submit tasks; Mentors review and give feedback

**Notification System**
- `INotifiable` interface implemented by `User` subclasses  
- Console notifications displayed when students apply or tasks are reviewed

**Certificate System**
- `ICertifiable` interface implemented by `Student`  
- Automatically generates a certificate after completing 3 or more tasks

**Main Program Flow**
- Organization creates an internship  
- Students apply  
- Mentor assigns & reviews tasks  
- Notifications displayed and certificate auto-generated


## What I Learned

- How to design classes and relationships using OOP principles  
- How abstraction and interfaces make code **modular and reusable**  
- How composition models **real-world ownership** (e.g an organisation owns internships)  
- How encapsulation protects class data  
- How polymorphism allows handling multiple object types through a common interface  

---

## Screenshots


<img width="975" height="710" alt="image" src="https://github.com/user-attachments/assets/63f5b581-2e9f-445d-9fde-be8eb28d940e" />
<img width="975" height="675" alt="image" src="https://github.com/user-attachments/assets/89d3f83e-0a79-4e9c-84b0-80b8a3d6e38a" />


---

## Getting Started

To run the project locally, follow these steps:

1. **Clone the repository**
    ```bash
    git clone https://github.com/Hasan-Uddin/flutter_alarm_app.git
    cd flutter_alarm_app
3. **Install dependencies**
    ```bash
    flutter pub get
4. **Run the app**
    ```bash
    flutter run
5. **build**
    - for web
        ```bash
        flutter build web
    - for Android
        ```bash
        flutter build apk

and so on...
