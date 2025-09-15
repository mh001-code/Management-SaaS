# 🚀 Management-SaaS
A simple SaaS system for managing clients and products, designed for small businesses that need fast and practical control. This project is built as an MVP (Minimum Viable Product), focused on being functional, scalable, and easy to use.

## 📌 Project Goals
Enable registration and management of users (login and authentication)

Create an admin dashboard with clients and products

Provide basic reports (inventory, registered clients, sales)

Be accessible via the web (no installation, just login)

## 🏗️ Technologies Used

### Backend
Node.js + Express → REST API
PostgreSQL → Relational database
Prisma (optional) → ORM to simplify queries
JWT (JSON Web Token) → Authentication

### Frontend
React (with Vite) → User interface
React Router → Page navigation
TailwindCSS → Fast and responsive styling
Recharts → Visual charts and reports

### Deployment
Vercel/Netlify → Frontend
Railway/Render → Backend and database

## 📂 Project Structure
/Management-SaaS
├── backend/ # Node.js API (Express)
 │ ├── src/
 │ │ ├── controllers/ # Route logic
 │ │ ├── models/ # Models (User, Product, Client)
 │ │ ├── routes/ # Route definitions
 │ │ └── index.js # Main file
 │ └── package.json
 │
 ├── frontend/ # React application
 │ ├── src/
 │ │ ├── components/ # Reusable components
 │ │ ├── pages/ # Pages (Login, Dashboard, Products)
 │ │ ├── services/ # API connection
 │ │ └── App.jsx # Root component
 │ └── package.json
 │
 └── README.md # Project documentation

## ⚙️ How to run the project locally

### 1. Clone the repository
```bash
git clone https://github.com/mh001-code/Management-SaaS.git
cd Management-SaaS
