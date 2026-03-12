import React, { useState } from "react";
import { useAuth } from "../contexts/AuthContext";

const Login = () => {
  const { login } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await login(email, password);
    } catch (err) {
      setError("Email ou senha inválidos.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap');

        .login-root {
          min-height: 100vh;
          width: 100%;
          display: flex;
          font-family: 'DM Sans', sans-serif;
          background: #0a0a0f;
          overflow: hidden;
          position: relative;
        }

        /* Left decorative panel */
        .login-panel {
          flex: 1;
          display: none;
          flex-direction: column;
          justify-content: space-between;
          padding: 48px;
          position: relative;
          overflow: hidden;
          background: linear-gradient(135deg, #0f0f1a 0%, #12122a 100%);
        }
        @media (min-width: 900px) { .login-panel { display: flex; } }

        .panel-orb {
          position: absolute;
          border-radius: 50%;
          filter: blur(80px);
          opacity: 0.25;
          pointer-events: none;
        }
        .orb1 { width: 420px; height: 420px; background: #4f6ef7; top: -80px; left: -80px; }
        .orb2 { width: 300px; height: 300px; background: #7c3aed; bottom: 60px; right: -60px; }
        .orb3 { width: 200px; height: 200px; background: #06b6d4; top: 40%; left: 30%; }

        .panel-logo {
          font-family: 'Syne', sans-serif;
          font-size: 22px;
          font-weight: 800;
          color: #fff;
          letter-spacing: -0.5px;
          display: flex;
          align-items: center;
          gap: 10px;
          z-index: 1;
        }
        .panel-logo-dot {
          width: 8px; height: 8px;
          background: #4f6ef7;
          border-radius: 50%;
        }

        .panel-headline {
          z-index: 1;
        }
        .panel-headline h2 {
          font-family: 'Syne', sans-serif;
          font-size: clamp(32px, 3.5vw, 48px);
          font-weight: 800;
          color: #fff;
          line-height: 1.15;
          margin: 0 0 16px;
        }
        .panel-headline p {
          color: rgba(255,255,255,0.45);
          font-size: 15px;
          line-height: 1.7;
          max-width: 320px;
        }

        .panel-stats {
          display: flex;
          gap: 32px;
          z-index: 1;
        }
        .stat-item { }
        .stat-value {
          font-family: 'Syne', sans-serif;
          font-size: 28px;
          font-weight: 700;
          color: #fff;
        }
        .stat-label {
          font-size: 12px;
          color: rgba(255,255,255,0.4);
          margin-top: 2px;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }

        /* Right form panel */
        .login-form-side {
          width: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 32px 20px;
          background: #0a0a0f;
          position: relative;
        }
        @media (min-width: 900px) {
          .login-form-side {
            width: 420px;
            min-width: 420px;
            flex-shrink: 0;
          }
        }

        .form-card {
          width: 100%;
          max-width: 360px;
          animation: slideUp 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
        }
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(24px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .form-eyebrow {
          font-size: 11px;
          text-transform: uppercase;
          letter-spacing: 2px;
          color: #4f6ef7;
          font-weight: 600;
          margin-bottom: 12px;
        }

        .form-title {
          font-family: 'Syne', sans-serif;
          font-size: 32px;
          font-weight: 800;
          color: #fff;
          margin: 0 0 8px;
          line-height: 1.1;
        }

        .form-subtitle {
          font-size: 14px;
          color: rgba(255,255,255,0.35);
          margin-bottom: 36px;
        }

        .field-group {
          margin-bottom: 20px;
        }

        .field-label {
          display: block;
          font-size: 12px;
          font-weight: 500;
          color: rgba(255,255,255,0.5);
          text-transform: uppercase;
          letter-spacing: 0.8px;
          margin-bottom: 8px;
        }

        .field-input {
          width: 100%;
          padding: 14px 16px;
          background: rgba(255,255,255,0.04);
          border: 1px solid rgba(255,255,255,0.08);
          border-radius: 10px;
          color: #fff;
          font-size: 15px;
          font-family: 'DM Sans', sans-serif;
          outline: none;
          transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
          box-sizing: border-box;
        }
        .field-input::placeholder { color: rgba(255,255,255,0.2); }
        .field-input:focus {
          border-color: #4f6ef7;
          background: rgba(79,110,247,0.06);
          box-shadow: 0 0 0 3px rgba(79,110,247,0.12);
        }

        .error-msg {
          background: rgba(239,68,68,0.1);
          border: 1px solid rgba(239,68,68,0.2);
          border-radius: 8px;
          padding: 10px 14px;
          color: #f87171;
          font-size: 13px;
          text-align: center;
          margin-bottom: 20px;
        }

        .submit-btn {
          width: 100%;
          padding: 15px;
          background: #4f6ef7;
          color: #fff;
          border: none;
          border-radius: 10px;
          font-size: 15px;
          font-family: 'Syne', sans-serif;
          font-weight: 700;
          cursor: pointer;
          transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
          letter-spacing: 0.3px;
          box-shadow: 0 4px 24px rgba(79,110,247,0.35);
          margin-top: 4px;
        }
        .submit-btn:hover:not(:disabled) {
          background: #3d5ce8;
          transform: translateY(-1px);
          box-shadow: 0 8px 32px rgba(79,110,247,0.45);
        }
        .submit-btn:active:not(:disabled) { transform: translateY(0); }
        .submit-btn:disabled { opacity: 0.6; cursor: not-allowed; }

        .spinner {
          display: inline-block;
          width: 14px; height: 14px;
          border: 2px solid rgba(255,255,255,0.3);
          border-top-color: #fff;
          border-radius: 50%;
          animation: spin 0.7s linear infinite;
          margin-right: 8px;
          vertical-align: middle;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .divider {
          display: flex;
          align-items: center;
          gap: 12px;
          margin: 28px 0;
          color: rgba(255,255,255,0.15);
          font-size: 12px;
        }
        .divider-line { flex: 1; height: 1px; background: rgba(255,255,255,0.06); }
      `}</style>

      <div className="login-root">
        {/* Decorative left panel */}
        <div className="login-panel">
          <div className="panel-orb orb1" />
          <div className="panel-orb orb2" />
          <div className="panel-orb orb3" />

          <div className="panel-logo">
            <div className="panel-logo-dot" />
            ManageSaaS
          </div>

          <div className="panel-headline">
            <h2>Gestão simples.<br />Resultados reais.</h2>
            <p>Controle clientes, produtos e pedidos em um só lugar — rápido, seguro e acessível de qualquer dispositivo.</p>
          </div>

          <div className="panel-stats">
            <div className="stat-item">
              <div className="stat-value">100%</div>
              <div className="stat-label">Web-based</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">JWT</div>
              <div className="stat-label">Segurança</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">MVP</div>
              <div className="stat-label">Pronto para usar</div>
            </div>
          </div>
        </div>

        {/* Form side */}
        <div className="login-form-side">
          <div className="form-card">
            <div className="form-eyebrow">Bem-vindo de volta</div>
            <h1 className="form-title">Entrar na conta</h1>
            <p className="form-subtitle">Digite suas credenciais para continuar</p>

            {error && <div className="error-msg">{error}</div>}

            <form onSubmit={handleSubmit}>
              <div className="field-group">
                <label className="field-label">Email</label>
                <input
                  type="email"
                  className="field-input"
                  placeholder="seu@email.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>

              <div className="field-group">
                <label className="field-label">Senha</label>
                <input
                  type="password"
                  className="field-input"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>

              <button type="submit" className="submit-btn" disabled={loading}>
                {loading && <span className="spinner" />}
                {loading ? "Entrando..." : "Entrar"}
              </button>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default Login;
