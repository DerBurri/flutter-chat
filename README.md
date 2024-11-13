# Flutter Chat App

This is a simple chat application built with Flutter for the frontend and a Go backend, deployed in Codesphere. This README provides setup instructions, deployment steps, and a brief overview of the app's features.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Setup and Deployment](#setup-and-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Usage](#usage)

## Features
- Real-time messaging
- User authentication
- Responsive UI for web use
- Backend API for chat management

## Technologies Used
- **Frontend**: Flutter (Web)
- **Backend**: Go
- **Deployment**: Codesphere landscape

## Setup and Deployment

### Requirements
- Codesphere account
- Flutter SDK
- Boost Workspace Plan

### Steps
1. **Clone the repository**: Clone this project to your local machine.
   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. **Configure Dependencies**: Codesphere will automatically install dependencies through the pipeline configuration.

3. **Prepare and Run Stages**:
   - In Codesphere, go to the CI Tab.
   - Start the **Prepare** stage, which will build and set up the required dependencies.
   - Once the **Prepare** stage completes successfully, proceed to the **Run** stage to deploy the application.

## CI/CD Pipeline
This project uses Codesphere’s CI/CD pipeline for automatic deployment and testing:
- **Prepare Stage**: Builds the app and installs all dependencies for both the Flutter frontend and Go backend.
- **Run Stage**: Deploys the app in Codesphere using Landscape, making it available at the specified URL.

## Usage
After deployment, open the application URL in a web browser to start using the chat app. Users can start real-time messaging.

### Development
For local development and testing:
1. Start the backend server:
   ```bash
   go run main.go
   ```
2. Run the Flutter app:
   ```bash
   flutter run -d web
   ```

---

Feel free to customize any details based on your specific setup or additional features.
