<<<<<<< HEAD
# aquaguard

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# AquaGuard - Aquatic Life Monitoring System

AquaGuard is a full-stack IoT dashboard designed to monitor and automate real-time aquatic environments.

## Architecture Revamp

- **Frontend**: React 18, Tailwind CSS, Supabase Authentication
- **Backend API**: Python, Flask, Flask-SQLAlchemy, SQLite
- **Database**:
  - **Supabase** handles external User Profiles and Sessions (Sign/Sign Up/Forgot Password).
  - **SQLite** backend manages raw IoT hardware Sensor Data.

## Setup Instructions

### 1. Supabase Initialization

1. Create a Project at [Supabase](https://supabase.com).
2. Go to **Project Settings -> API** to retrieve your `Project URL`, `anon / public API key`, and `JWT Secret`.
3. In `frontend/src/supabaseClient.js`, insert your URL and Anon Key.
4. In `backend/app.py`, update the `SUPABASE_JWT_SECRET` config variable.
5. In your Supabase Auth settings, disable "Confirm email" if you want instant test logins without needing to setup SMTP email services.

### 2. Custom Video Implementation

The interface uses a truly realistic water background by embedding an HTML5 Video behind a glassmorphism dashboard.

- Place your custom video clip inside `frontend/public/` and name it `water_clip.mp4`.
- The dashboard will automatically detect and load your clip!

### 3. Run the React Frontend

Open your terminal:

```bash
cd scratch/aquaguard/frontend
npm install
npm start
```

### 4. Run the Flask Backend API

_(Note: Requires Python to be correctly installed and globally available in your environment)._
Open a separate terminal:

```bash
cd scratch/aquaguard/backend
python -m venv venv
# Windows: .\venv\Scripts\activate  |  Mac/Linux: source venv/bin/activate
pip install -r requirements.txt
python seed_db.py  # Wait, seed_db.py needs updating to remove users. I recommend just running:
python app.py
```

_The Flask application will automatically create the required sensor tables on the very first run._

## Post-Setup Features

- Your hardware will automatically post to `/api/kit/data` which natively links incoming stats to your specific kit's MAC address.
- During Sign Up, a user inserts their Kit Address. It becomes linked to them inside Supabase forever.
- Secure, lightning-fast dashboard metrics leveraging Tailwind grids and component abstraction.
>>>>>>> origin/main
