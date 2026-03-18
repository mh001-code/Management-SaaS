import React, { useState, useCallback } from "react";
import { useAuth } from "../contexts/AuthContext";
import { useValidation } from "../hooks/useValidation";

const RULES = {
  email:    { required: true, email: true },
  password: { required: true, min: 6 },
};

const Login = () => {
  const { login } = useAuth();
  const [values, setValues]   = useState({ email: "", password: "" });
  const [loading, setLoading] = useState(false);
  const [serverError, setServerError] = useState("");
  const [showPwd, setShowPwd] = useState(false);

  const { errors, touched, touch, touchAll } = useValidation(RULES);

  const handleChange = useCallback((field, value) => {
    setValues((prev) => ({ ...prev, [field]: value }));
    if (touched[field]) touch(field, { ...values, [field]: value });
    if (serverError) setServerError("");
  }, [values, touched, touch, serverError]);

  const handleBlur = useCallback((field) => {
    touch(field, values);
  }, [touch, values]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const valid = touchAll(values);
    if (!valid) return;

    setLoading(true);
    setServerError("");
    try {
      await login(values.email, values.password);
    } catch {
      setServerError("E-mail ou senha incorretos. Verifique suas credenciais.");
    } finally {
      setLoading(false);
    }
  };

  const emailError   = touched.email    ? errors.email    : undefined;
  const passwordError= touched.password ? errors.password : undefined;

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@500&display=swap');

        .lg-root {
          min-height: 100vh; width: 100%;
          display: flex; background: #0D0D12;
          font-family: 'Space Grotesk', sans-serif;
          overflow: hidden;
        }

        /* Painel esquerdo decorativo */
        .lg-panel {
          flex: 1; display: none; flex-direction: column;
          justify-content: space-between; padding: 48px;
          background: #0F0F1A; position: relative; overflow: hidden;
        }
        @media (min-width: 900px) { .lg-panel { display: flex; } }

        .lg-orb {
          position: absolute; border-radius: 50%;
          filter: blur(90px); opacity: 0.18; pointer-events: none;
        }
        .orb1 { width:460px; height:460px; background:#7C6AF7; top:-100px; left:-80px; }
        .orb2 { width:320px; height:320px; background:#00D4AA; bottom:40px; right:-60px; }
        .orb3 { width:200px; height:200px; background:#F7916A; top:42%; left:35%; }

        .lg-logo {
          font-size: 18px; font-weight: 700; color: #F0F0F8;
          letter-spacing: -0.5px; display: flex; align-items: center; gap: 8px;
          z-index: 1;
        }
        .lg-logo-dot {
          width: 8px; height: 8px; border-radius: 50%; background: #7C6AF7;
        }

        .lg-headline { z-index: 1; }
        .lg-headline h2 {
          font-size: clamp(30px, 3.2vw, 44px); font-weight: 700;
          color: #F0F0F8; line-height: 1.15; margin: 0 0 14px;
          letter-spacing: -1px;
        }
        .lg-headline p {
          color: rgba(240,240,248,0.4); font-size: 14px; line-height: 1.7;
          max-width: 300px;
        }

        .lg-stats { display: flex; gap: 32px; z-index: 1; }
        .lg-stat-val {
          font-family: 'JetBrains Mono', monospace;
          font-size: 26px; font-weight: 500; color: #F0F0F8;
        }
        .lg-stat-label {
          font-size: 11px; color: rgba(240,240,248,0.35);
          text-transform: uppercase; letter-spacing: 0.8px; margin-top: 3px;
        }

        /* Painel direito — formulário */
        .lg-form-side {
          width: 100%; display: flex; align-items: center;
          justify-content: center; padding: 32px 24px;
          background: #0D0D12;
        }
        @media (min-width: 900px) { .lg-form-side { width: 420px; min-width: 420px; flex-shrink: 0; } }

        .lg-card {
          width: 100%; max-width: 360px;
          animation: slideUp .5s cubic-bezier(0.22,1,0.36,1) both;
        }
        @keyframes slideUp {
          from { opacity:0; transform:translateY(24px); }
          to   { opacity:1; transform:translateY(0); }
        }

        .lg-eyebrow {
          font-size: 11px; text-transform: uppercase; letter-spacing: 2px;
          color: #7C6AF7; font-weight: 600; margin-bottom: 10px;
        }
        .lg-title {
          font-size: 30px; font-weight: 700; color: #F0F0F8;
          margin: 0 0 6px; letter-spacing: -0.8px;
        }
        .lg-sub {
          font-size: 13px; color: rgba(240,240,248,0.35); margin-bottom: 32px;
        }

        /* Campo */
        .lg-field { margin-bottom: 18px; }
        .lg-label {
          display: block; font-size: 11px; font-weight: 600;
          color: rgba(240,240,248,0.5); text-transform: uppercase;
          letter-spacing: 0.8px; margin-bottom: 7px;
          transition: color 150ms;
        }
        .lg-label.has-error { color: #F76464; }

        .lg-input-wrap { position: relative; }
        .lg-input {
          width: 100%; padding: 13px 42px 13px 14px;
          background: rgba(255,255,255,0.04);
          border: 1px solid rgba(255,255,255,0.08);
          border-radius: 10px; color: #F0F0F8;
          font-size: 14px; font-family: 'Space Grotesk', sans-serif;
          outline: none;
          transition: border-color 200ms, box-shadow 200ms;
          box-sizing: border-box;
        }
        .lg-input::placeholder { color: rgba(240,240,248,0.2); }
        .lg-input:focus {
          border-color: #7C6AF7;
          box-shadow: 0 0 0 3px rgba(124,106,247,0.14);
        }
        .lg-input.has-error {
          border-color: #F76464;
          box-shadow: 0 0 0 3px rgba(247,100,100,0.12);
          animation: shake .35s ease;
        }
        .lg-input.has-success { border-color: #00D4AA; }

        @keyframes shake {
          0%,100%{ transform:translateX(0) }
          20%    { transform:translateX(-4px) }
          40%    { transform:translateX(4px) }
          60%    { transform:translateX(-3px) }
          80%    { transform:translateX(3px) }
        }

        .lg-input-icon {
          position: absolute; right: 13px; top: 50%;
          transform: translateY(-50%);
          display: flex; align-items: center;
          color: rgba(240,240,248,0.3); pointer-events: none;
        }
        .lg-input-icon.clickable {
          pointer-events: auto; cursor: pointer;
          transition: color 150ms;
        }
        .lg-input-icon.clickable:hover { color: rgba(240,240,248,0.7); }

        .lg-field-error {
          display: flex; align-items: center; gap: 5px;
          font-size: 11px; color: #F76464; margin-top: 6px;
          animation: fadeMsg .2s ease;
        }
        @keyframes fadeMsg {
          from { opacity:0; transform:translateY(-3px); }
          to   { opacity:1; transform:translateY(0); }
        }

        /* Erro do servidor */
        .lg-server-error {
          display: flex; align-items: flex-start; gap: 10px;
          padding: 11px 14px; margin-bottom: 20px;
          background: rgba(247,100,100,0.08);
          border: 1px solid rgba(247,100,100,0.2);
          border-radius: 10px;
          color: #F76464; font-size: 13px; line-height: 1.4;
          animation: fadeMsg .2s ease;
        }

        /* Botão */
        .lg-submit {
          width: 100%; padding: 14px;
          background: #7C6AF7; color: #fff;
          border: none; border-radius: 10px;
          font-size: 14px; font-weight: 700;
          font-family: 'Space Grotesk', sans-serif;
          cursor: pointer; letter-spacing: 0.2px;
          transition: opacity 150ms, transform 150ms;
          display: flex; align-items: center; justify-content: center; gap: 8px;
          margin-top: 4px;
        }
        .lg-submit:hover:not(:disabled) { opacity: .88; transform: translateY(-1px); }
        .lg-submit:active:not(:disabled) { transform: translateY(0); }
        .lg-submit:disabled { opacity: .55; cursor: not-allowed; }

        @keyframes spin { to { transform: rotate(360deg); } }
        .lg-spinner {
          width: 15px; height: 15px;
          border: 2px solid rgba(255,255,255,.25);
          border-top-color: #fff;
          border-radius: 50%; animation: spin .7s linear infinite;
          flex-shrink: 0;
        }
      `}</style>

      <div className="lg-root">
        {/* Painel decorativo */}
        <div className="lg-panel">
          <div className="lg-orb orb1" />
          <div className="lg-orb orb2" />
          <div className="lg-orb orb3" />
          <div className="lg-logo"><div className="lg-logo-dot" />ManageSaaS</div>
          <div className="lg-headline">
            <h2>Gestão simples.<br />Resultados reais.</h2>
            <p>Controle clientes, produtos e pedidos em um só lugar — rápido, seguro e acessível de qualquer dispositivo.</p>
          </div>
          <div className="lg-stats">
            <div><div className="lg-stat-val">JWT</div><div className="lg-stat-label">Seguro</div></div>
            <div><div className="lg-stat-val">100%</div><div className="lg-stat-label">Web-based</div></div>
            <div><div className="lg-stat-val">MVP</div><div className="lg-stat-label">Pronto</div></div>
          </div>
        </div>

        {/* Formulário */}
        <div className="lg-form-side">
          <div className="lg-card">
            <div className="lg-eyebrow">Bem-vindo de volta</div>
            <h1 className="lg-title">Entrar na conta</h1>
            <p className="lg-sub">Digite suas credenciais para continuar</p>

            {serverError && (
              <div className="lg-server-error">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" style={{ flexShrink: 0, marginTop: 1 }}>
                  <circle cx="8" cy="8" r="7" stroke="currentColor" strokeWidth="1.5"/>
                  <path d="M8 5v3.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                  <circle cx="8" cy="11" r=".75" fill="currentColor"/>
                </svg>
                {serverError}
              </div>
            )}

            <form onSubmit={handleSubmit} noValidate>
              {/* Email */}
              <div className="lg-field">
                <label className={`lg-label ${emailError ? "has-error" : ""}`}>E-mail</label>
                <div className="lg-input-wrap">
                  <input
                    type="email"
                    className={`lg-input ${emailError ? "has-error" : touched.email && !emailError ? "has-success" : ""}`}
                    placeholder="seu@email.com"
                    value={values.email}
                    onChange={(e) => handleChange("email", e.target.value)}
                    onBlur={() => handleBlur("email")}
                    autoComplete="email"
                    required
                  />
                  <div className="lg-input-icon">
                    {emailError ? (
                      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                        <circle cx="8" cy="8" r="7" stroke="#F76464" strokeWidth="1.5"/>
                        <path d="M8 5v3.5" stroke="#F76464" strokeWidth="1.5" strokeLinecap="round"/>
                        <circle cx="8" cy="11" r=".75" fill="#F76464"/>
                      </svg>
                    ) : touched.email && !emailError ? (
                      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                        <circle cx="8" cy="8" r="7" stroke="#00D4AA" strokeWidth="1.5"/>
                        <path d="M5 8l2 2 4-4" stroke="#00D4AA" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    ) : (
                      <svg width="15" height="15" viewBox="0 0 16 16" fill="none">
                        <path d="M2 4h12v8H2z" stroke="currentColor" strokeWidth="1.2" strokeLinejoin="round"/>
                        <path d="M2 4l6 5 6-5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                      </svg>
                    )}
                  </div>
                </div>
                {emailError && (
                  <div className="lg-field-error">
                    <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                      <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1.2"/>
                      <path d="M6 4v2.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                      <circle cx="6" cy="8.5" r=".5" fill="currentColor"/>
                    </svg>
                    {emailError}
                  </div>
                )}
              </div>

              {/* Senha */}
              <div className="lg-field">
                <label className={`lg-label ${passwordError ? "has-error" : ""}`}>Senha</label>
                <div className="lg-input-wrap">
                  <input
                    type={showPwd ? "text" : "password"}
                    className={`lg-input ${passwordError ? "has-error" : touched.password && !passwordError ? "has-success" : ""}`}
                    placeholder="••••••••"
                    value={values.password}
                    onChange={(e) => handleChange("password", e.target.value)}
                    onBlur={() => handleBlur("password")}
                    autoComplete="current-password"
                    required
                  />
                  <div
                    className="lg-input-icon clickable"
                    onClick={() => setShowPwd((p) => !p)}
                    title={showPwd ? "Ocultar senha" : "Mostrar senha"}
                  >
                    {showPwd ? (
                      <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                        <path d="M2 8s2.5-4 6-4 6 4 6 4-2.5 4-6 4-6-4-6-4z" stroke="currentColor" strokeWidth="1.3"/>
                        <circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/>
                        <path d="M2 2l12 12" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
                      </svg>
                    ) : (
                      <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                        <path d="M2 8s2.5-4 6-4 6 4 6 4-2.5 4-6 4-6-4-6-4z" stroke="currentColor" strokeWidth="1.3"/>
                        <circle cx="8" cy="8" r="2" stroke="currentColor" strokeWidth="1.3"/>
                      </svg>
                    )}
                  </div>
                </div>
                {passwordError && (
                  <div className="lg-field-error">
                    <svg width="11" height="11" viewBox="0 0 12 12" fill="none">
                      <circle cx="6" cy="6" r="5" stroke="currentColor" strokeWidth="1.2"/>
                      <path d="M6 4v2.5" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                      <circle cx="6" cy="8.5" r=".5" fill="currentColor"/>
                    </svg>
                    {passwordError}
                  </div>
                )}
              </div>

              <button type="submit" className="lg-submit" disabled={loading}>
                {loading ? (
                  <><div className="lg-spinner" /> Entrando...</>
                ) : "Entrar"}
              </button>
            </form>
          </div>
        </div>
      </div>
    </>
  );
};

export default Login;
