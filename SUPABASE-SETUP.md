# Supabase Setup for TravelCompanion

This guide provides step-by-step instructions for setting up Supabase with the TravelCompanion app.

## 1. Create a Supabase Project

1. Go to [app.supabase.com](https://app.supabase.com) and sign in or create an account
2. Click "New Project"
3. Enter project details:
   - Organization (create one if you don't have one)
   - Name: "TravelCompanion"
   - Database Password: Create a strong password
   - Region: Choose the closest to your users
4. Click "Create New Project" and wait for setup to complete (about 2 minutes)

## 2. Set Up Database Schema

1. From your Supabase dashboard, go to the "SQL Editor" section
2. Create a new SQL query
3. Copy and paste all the SQL from the `database-setup.sql` file in this project
4. Click "Run" to execute the SQL and create your database schema

## 3. Configure Storage Buckets

The SQL script should have created two storage buckets:
- `avatars` - For user profile images
- `trips` - For trip-related images

Verify they exist by going to the "Storage" section in the Supabase dashboard.

## 4. Update Supabase Credentials in the App

1. From your Supabase dashboard, go to "Settings" > "API"
2. Find your project URL and anon key
3. Open `Services/SupabaseService.swift` in your project
4. Replace the placeholder values with your actual Supabase credentials:

```swift
client = SupabaseClient(
    supabaseURL: URL(string: "YOUR_ACTUAL_SUPABASE_URL")!,
    supabaseKey: "YOUR_ACTUAL_ANON_KEY"
)
```

## 5. Configure Authentication Settings (Optional)

1. Go to "Authentication" > "Settings" in the Supabase dashboard
2. Under "Site URL", add your app's URL (for development, you can use `http://localhost`)
3. Under "Email Templates", customize the email templates for password resets, confirmations, etc.

## 6. Testing Your Integration

1. Run your app
2. Try to sign up a new user
3. If you receive any errors:
   - Check that API keys are correct
   - Verify that the database tables are created
   - Make sure your internet connection is working

## 7. Local Development (Optional)

If you want to develop locally without connecting to the remote Supabase instance:

1. Install [Supabase CLI](https://supabase.com/docs/guides/local-development)
2. Start a local Supabase instance by running `supabase start`
3. Run the setup SQL on your local instance
4. Update the Supabase URL and key to point to your local instance 