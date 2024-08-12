# Flutter-Sleep-App

This Flutter-based Android application is designed to help users monitor and improve their sleep quality by logging their sleep patterns, calculating their sleep needs, and providing access to reliable sleep-related information.

## Features

### 1. **Sleep Log Entry**
- Every morning, users can enter a sleep log to rate their sleep quality from the previous night.
- Users can answer questions about potential factors that might have influenced their sleep (e.g., stress, caffeine intake, etc.).
- The sleep logs are stored securely in a Google Firebase database for easy retrieval and analysis.

### 2. **Sleep Need Calculator**
- The app includes a Sleep Need Calculator that estimates the amount of sleep a user requires based on their age, gender, weight, and other relevant factors.
- This feature provides personalized recommendations to help users optimize their sleep schedules.

### 3. **Sleep History**
- **Log View**: Users can view their most recent sleep logs in a simple list format, allowing them to easily track their sleep patterns over time.
- **Graph View**: A graphical representation of the user's sleep history, showing the amount of sleep they got each night over the past week. This visual aid helps users identify trends and make informed adjustments to their sleep habits.

### 4. **Info Tab**
- The Info Tab provides users with curated resources to improve their sleep knowledge.
- It includes a collection of YouTube videos and links to reliable sources of information on sleep health and best practices.

## Technology Stack

- **Flutter**: The app is developed using Flutter, ensuring a smooth and responsive user experience across Android devices.
- **Firebase**: Google Firebase is used as the backend database to store sleep logs and user data securely.

## Installation

To run this app on your local machine, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-repo/sleep-tracker-app.git
    ```
2. **Navigate to the project directory**:
    ```bash
    cd sleep-tracker-app
    ```
3. **Install dependencies**:
    ```bash
    flutter pub get
    ```
4. **Configure Firebase**:
    - Set up a Firebase project and add your Android app to it.
    - Download the `google-services.json` file from the Firebase console and place it in the `android/app` directory.
    - Make sure Firebase is properly configured in your project.

5. **Run the app**:
    ```bash
    flutter run
    ```
