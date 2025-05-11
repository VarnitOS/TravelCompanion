-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users profile table (extends built-in auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  email TEXT,
  profile_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Trips table
CREATE TABLE IF NOT EXISTS trips (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  destination TEXT NOT NULL,
  start_date TIMESTAMP WITH TIME ZONE NOT NULL,
  end_date TIMESTAMP WITH TIME ZONE NOT NULL,
  description TEXT,
  is_favorite BOOLEAN DEFAULT FALSE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  image_url TEXT,
  budget FLOAT,
  currency TEXT DEFAULT 'USD',
  travel_method TEXT,
  status TEXT DEFAULT 'planned',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Accommodations table
CREATE TABLE IF NOT EXISTS accommodations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  check_in_date TIMESTAMP WITH TIME ZONE NOT NULL,
  check_out_date TIMESTAMP WITH TIME ZONE NOT NULL,
  price FLOAT,
  booking_reference TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Expenses table
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE NOT NULL,
  amount FLOAT NOT NULL,
  currency TEXT NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  category TEXT NOT NULL,
  description TEXT NOT NULL,
  payment_method TEXT DEFAULT 'cash',
  location TEXT,
  image_url TEXT,
  is_reimbursable BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW())
);

-- Set up Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE accommodations ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- Create policies for secure access
-- Profiles policies
CREATE POLICY "Users can view their own profile" 
ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "New users can insert their profile"
ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Trips policies
CREATE POLICY "Users can view their own trips" 
ON trips FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own trips" 
ON trips FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own trips" 
ON trips FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own trips" 
ON trips FOR DELETE USING (auth.uid() = user_id);

-- Accommodations policies
CREATE POLICY "Users can view their trip accommodations" 
ON accommodations FOR SELECT USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = accommodations.trip_id)
);

CREATE POLICY "Users can insert their trip accommodations" 
ON accommodations FOR INSERT WITH CHECK (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = accommodations.trip_id)
);

CREATE POLICY "Users can update their trip accommodations" 
ON accommodations FOR UPDATE USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = accommodations.trip_id)
);

CREATE POLICY "Users can delete their trip accommodations" 
ON accommodations FOR DELETE USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = accommodations.trip_id)
);

-- Expenses policies
CREATE POLICY "Users can view their trip expenses" 
ON expenses FOR SELECT USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = expenses.trip_id)
);

CREATE POLICY "Users can insert their trip expenses" 
ON expenses FOR INSERT WITH CHECK (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = expenses.trip_id)
);

CREATE POLICY "Users can update their trip expenses" 
ON expenses FOR UPDATE USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = expenses.trip_id)
);

CREATE POLICY "Users can delete their trip expenses" 
ON expenses FOR DELETE USING (
  auth.uid() IN (SELECT user_id FROM trips WHERE id = expenses.trip_id)
);

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'User profile images', true);
INSERT INTO storage.buckets (id, name, public) VALUES ('trips', 'Trip images and photos', true);

-- Set up storage policies
CREATE POLICY "Anyone can view avatars" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their avatar" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.uid() IS NOT NULL);

CREATE POLICY "Users can update their own avatar" ON storage.objects
  FOR UPDATE USING (bucket_id = 'avatars' AND owner = auth.uid());

CREATE POLICY "Users can delete their own avatar" ON storage.objects
  FOR DELETE USING (bucket_id = 'avatars' AND owner = auth.uid());

CREATE POLICY "Anyone can view trip images" ON storage.objects
  FOR SELECT USING (bucket_id = 'trips');

CREATE POLICY "Users can upload trip images" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'trips' AND auth.uid() IS NOT NULL);

CREATE POLICY "Users can update their own trip images" ON storage.objects
  FOR UPDATE USING (bucket_id = 'trips' AND owner = auth.uid());

CREATE POLICY "Users can delete their own trip images" ON storage.objects
  FOR DELETE USING (bucket_id = 'trips' AND owner = auth.uid());

-- Create trigger to create profile entry when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, email)
  VALUES (new.id, coalesce(new.raw_user_meta_data->>'display_name', new.email), new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger the function every time a user is created
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user(); 