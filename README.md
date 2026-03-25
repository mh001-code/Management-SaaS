# Management SaaS

A full-stack SaaS management system for small businesses, covering clients, products, orders, suppliers, purchase orders, financial records, and reporting — all in one place.

Built as a production-ready application with a responsive UI, JWT authentication, role-based access control, and deployment-ready configuration for Vercel (frontend) and any Node.js host (backend).

## Features

### Dashboard
- KPI cards with animated count-up for orders, revenue, average ticket, and active clients
- Financial KPIs: paid revenue, paid expenses, balance, upcoming and overdue amounts
- Monthly revenue line chart (last 6 months)
- Top-selling products bar chart
- Orders by status donut chart
- Recent orders and top clients lists
- Low stock alert panel
- Date range filter applied to all metrics

### Clients
- Full CRUD with inline editing
- Search across name, email, phone, and address
- Paginated table with mobile card layout

### Products
- Full CRUD with stock quantity tracking
- Search and pagination
- Low stock visibility on the Dashboard

### Orders
- Full CRUD with multi-item order builder
- Status management: pending → paid → shipped → delivered → completed / cancelled / reversed
- Status history drawer with timeline visualization
- Filters by status, date range, and client/ID search
- KPI summary bar (total, revenue, pending, cancelled)

### Suppliers
- Full CRUD for supplier registration
- Fields: name, email, phone, document (CNPJ/CPF), contact name, notes

### Purchase Orders
- Create purchase orders linked to suppliers and products
- Status flow: pending → confirmed → received / cancelled
- Action buttons per allowed transition (no invalid state changes)
- Stock is automatically updated when a purchase order is received

### Financial
- Two tabs: Transactions and Cash Flow
- Income and expense entries with categories, due dates, paid dates, and notes
- Inline status select per transaction (pending → paid / overdue / cancelled)
- One-click "Mark as Paid" button
- Filters by type, status, category, and due date range
- Dynamic totals (revenue, expenses, balance) based on active filters
- Cash Flow tab with monthly bar chart and pending amounts

### Reports
- Export to Excel (.xlsx) and PDF for: Orders, Clients, Products, Financial
- Date range filters per report type
- PDF generated client-side using jsPDF + AutoTable

### Users
- Admin-only user management
- Role assignment: admin or user
- Password update support

### Auth
- JWT-based login with httpOnly cookie or Authorization header
- Protected routes on both frontend (React Router) and backend (middleware)
- Role-based access: admins see the Users page, regular users do not

### Notifications
- Real-time alert bell in the sidebar polling every 5 minutes
- Alerts for: low/zero stock, overdue financial entries, pending purchase orders
- Toast notifications (success, error, warning, info, loading) with progress bar and auto-dismiss

### UX & Responsive Design
- Dark theme by default with light theme toggle (persisted)
- Collapsible sidebar on desktop; hamburger overlay on mobile
- Fully responsive: all pages adapt to mobile viewports
- Mobile card layout for all data tables (no horizontal scroll on narrow screens)
- Smooth animations: fade-up entries, count-up KPIs, shimmer skeletons
- Space Grotesk + JetBrains Mono typography

---

## Tech Stack

### Frontend
| Tech | Version | Purpose |
|---|---|---|
| React | 18 | UI framework |
| Vite | 4 | Build tool |
| React Router DOM | 7 | Client-side routing |
| Tailwind CSS | 3 | Utility-first styling |
| Recharts | 3 | Charts (line, bar) |
| Axios | 1 | HTTP client |
| jsPDF + AutoTable | CDN | PDF export |
| SheetJS (xlsx) | CDN | Excel export |

### Backend
| Tech | Version | Purpose |
|---|---|---|
| Node.js + Express | 4 | REST API |
| PostgreSQL | — | Relational database |
| JWT (jsonwebtoken) | 9 | Authentication |
| bcryptjs | 3 | Password hashing |
| express-validator | 7 | Input validation |
| express-rate-limit | 7 | Rate limiting |
| morgan | 1 | HTTP request logging |
| Swagger (jsdoc + ui) | — | API documentation |

---

## Project Structure

```
Management-SaaS/
├── backend/
│   └── src/
│       ├── config/          # Database connection (db.js)
│       ├── controllers/     # Route handlers
│       ├── middlewares/     # Auth, roles, validation, error handling, logging
│       ├── models/          # DB query functions per entity
│       ├── routes/          # Express routers (one per resource)
│       ├── services/        # Business logic (notifications, etc.)
│       ├── utils/           # Shared helpers
│       ├── docs.js          # Swagger setup
│       ├── app.js           # Express app configuration
│       └── index.js         # Server entry point
│
├── frontend/
│   └── src/
│       ├── components/      # Reusable UI components
│       │   └── ui/          # Primitives: Button, Input, Card, Badge, Alert
│       ├── contexts/        # AuthContext, ThemeContext
│       ├── hooks/           # useFetch, useForm, usePagination, useSearch,
│       │                    # useModal, useValidation, useNotifications
│       ├── pages/           # Dashboard, Clients, Products, Orders,
│       │                    # Suppliers, PurchaseOrders, Financial,
│       │                    # Reports, Users, Login
│       ├── services/        # api.js (Axios instance), notificationService,
│       │                    # errorService
│       ├── theme/           # theme.css (CSS variables, dark/light tokens)
│       ├── utils/           # formatCurrency, etc.
│       └── App.jsx          # Router + lazy-loaded pages
│
└── README.md
```

---

## API Routes

| Method | Route | Description |
|---|---|---|
| POST | `/auth/login` | Login, returns JWT |
| GET | `/clients` | List clients |
| POST | `/clients` | Create client |
| PUT | `/clients/:id` | Update client |
| DELETE | `/clients/:id` | Delete client |
| GET | `/products` | List products |
| POST | `/products` | Create product |
| PUT | `/products/:id` | Update product |
| DELETE | `/products/:id` | Delete product |
| GET | `/orders` | List orders |
| POST | `/orders` | Create order |
| PUT | `/orders/:id` | Update order |
| DELETE | `/orders/:id` | Delete order |
| GET | `/suppliers` | List suppliers |
| POST | `/suppliers` | Create supplier |
| PUT | `/suppliers/:id` | Update supplier |
| DELETE | `/suppliers/:id` | Delete supplier |
| GET | `/purchase-orders` | List purchase orders |
| POST | `/purchase-orders` | Create purchase order |
| PUT | `/purchase-orders/:id/status` | Advance status |
| GET | `/financial` | List transactions (with filters) |
| POST | `/financial` | Create transaction |
| PUT | `/financial/:id` | Update transaction |
| DELETE | `/financial/:id` | Delete transaction |
| GET | `/financial/cash-flow` | Cash flow by month |
| GET | `/users` | List users (admin only) |
| POST | `/users` | Create user (admin only) |
| PUT | `/users/:id` | Update user (admin only) |
| DELETE | `/users/:id` | Delete user (admin only) |
| GET | `/summary` | Dashboard aggregate data |
| GET | `/reports/orders` | Orders report data |
| GET | `/reports/clients` | Clients report data |
| GET | `/reports/products` | Products report data |
| GET | `/reports/financial` | Financial report data |
| GET | `/notifications/alerts` | Notification alerts |

Full Swagger docs available at `/api-docs` when the backend is running.

---

## Running Locally

### Prerequisites
- Node.js 18+
- PostgreSQL 14+

### 1. Clone the repository

```bash
git clone https://github.com/mh001-code/Management-SaaS.git
cd Management-SaaS
```

### 2. Backend

```bash
cd backend
npm install
```

Create a `.env` file in `backend/`:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/management_saas
JWT_SECRET=your_secret_key
PORT=5000
```

Run migrations and (optionally) seed demo data:

```bash
npm run migrate
npm run seed-demo   # optional: populates demo clients, products, orders, etc.
```

Start the server:

```bash
npm run dev    # development (nodemon)
npm start      # production
```

### 3. Frontend

```bash
cd frontend
npm install
npm run dev
```

The app will be available at `http://localhost:5173`.

To create the first admin user:

```bash
cd backend
npm run create-admin
```

---

## Deployment

### Frontend — Vercel

The `frontend/` directory contains a `vercel.json` pre-configured for Vite:

```json
{
  "buildCommand": "node ./node_modules/vite/bin/vite.js build",
  "outputDirectory": "dist",
  "framework": "vite",
  "installCommand": "npm install"
}
```

Set the Vercel root directory to `frontend/` and add the environment variable:

```
VITE_API_URL=https://your-backend-url.com
```

### Backend — Any Node.js host (Railway, Render, Fly.io, etc.)

Set the following environment variables on your host:

```
DATABASE_URL=postgresql://...
JWT_SECRET=...
PORT=5000
```

Run with `npm start` (entry: `src/index.js`).

---

## License

MIT
