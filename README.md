# Recipe App

Monorepo for a recipe application.

## Stack

- Backend: Ruby on Rails API
- Database: PostgreSQL
- Frontend: Flutter, pending final decision
- Environment: Docker Compose

## Backend bootstrap

The backend is generated and run through Docker, so Rails does not need to be installed locally.

Generate the Rails API app inside `backend/`:

```powershell
docker compose run --rm backend rails new . --force --api --database=postgresql --skip-git --skip-docker
```

After Rails is generated, install dependencies and create the database:

```powershell
docker compose run --rm backend bundle install
docker compose run --rm backend rails db:create
```

Start the backend:

```powershell
docker compose up
```

Rails will be available at:

```text
http://localhost:3000
```

## Current API endpoints

```text
GET    /api/status
POST   /api/auth/register
POST   /api/auth/login
GET    /api/auth/me
DELETE /api/auth/logout
```

Authenticated requests must include:

```text
Authorization: Bearer <token>
```
