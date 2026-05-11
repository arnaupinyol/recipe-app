# Frontend Flutter

Flutter frontend for the recipe app.

## Structure

The app is organized in four main areas inside `lib/`:

- `app/`: global app setup such as router and theme
- `core/`: shared technical infrastructure such as API, storage, and env config
- `features/`: feature-first code grouped by flows like `auth`, `recipes`, and `profile`
- `shared/`: reusable UI widgets and future design-system pieces

Each feature can grow with these subfolders:

- `application/`: controllers and state
- `data/`: DTOs, repositories, and API services
- `presentation/`: screens and widgets

## Local development

From `frontend/`:

```powershell
C:\Users\aarnn\flutter\bin\flutter.bat pub get
C:\Users\aarnn\flutter\bin\flutter.bat analyze
C:\Users\aarnn\flutter\bin\flutter.bat test
```

Run the app manually:

- Windows:
  `C:\Users\aarnn\flutter\bin\flutter.bat run -d windows --dart-define=API_BASE_URL=http://localhost:3000/api`
- Chrome:
  `C:\Users\aarnn\flutter\bin\flutter.bat run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api`

The backend and database can still run with Docker from the repo root:

```powershell
docker compose up
```

Expected backend URL:

- Backend API: `http://localhost:3000`

The Flutter app should run locally outside Docker because the main target is a native app workflow.
