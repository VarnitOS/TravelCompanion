# TravelCompanion

A modern iOS app for managing travel plans, tracking expenses, and getting AI-powered travel recommendations.

## Architecture

This project follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures representing the core objects in the app (Trip, Expense, etc.)
- **Views**: SwiftUI views that make up the user interface
- **ViewModels**: Classes that manage the business logic and provide data to the views
- **Services**: Classes that handle external communication (API, database, etc.)

## Technologies

- SwiftUI for the user interface
- Combine for reactive programming
- Supabase for backend services (authentication, database)
- Cohere API for AI assistant functionality

## Features

- User authentication
- Trip planning and management
- Accommodation bookings
- Expense tracking
- AI travel assistant
- Settings and preferences

## Getting Started

1. Clone the repository
2. Add your Supabase and Cohere API credentials in the Services directory
3. Build and run the app in Xcode

## License

This project is for educational purposes only. 