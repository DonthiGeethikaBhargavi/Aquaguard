import React, { useState } from 'react';
import { supabase } from '../supabaseClient';
import { useLang, languageOptions } from '../LanguageContext';
import Chatbot from './Chatbot'; // ✅ ADD

const Auth = () => {
  const { lang, setLang, t } = useLang();
  const [mode, setMode] = useState('LOGIN');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phone, setPhone] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState(null);

  // ✅ chatbot states
  const [sensorData, setSensorData] = useState(null);
  const [chatPrefill, setChatPrefill] = useState(null);

  const handleAuth = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage(null);

    try {
      if (!email || !password) {
        setMessage({ text: 'Enter email and password', type: 'error' });
        setLoading(false);
        return;
      }

      if (mode === 'SIGNUP') {
        const { error } = await supabase.auth.signUp({
          email,
          password,
          options: { 
            data: { phone: phone },
            emailRedirectTo: window.location.origin
          }
        });
        if (error) throw error;

        setMessage({ text: 'Check your email for the confirmation link!', type: 'success' });

      } else if (mode === 'LOGIN') {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;

        setMessage({ text: 'Login successful!', type: 'success' });

        await new Promise(res => setTimeout(res, 600));
      }

    } catch (error) {
      setMessage({ text: error.message, type: 'error' });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen relative z-10 p-4">
      <div className="w-full max-w-lg flex flex-col items-center">

        {/* Language Picker */}
        <div className="flex items-center gap-2 mb-8 bg-black/30 backdrop-blur-md px-4 py-2 rounded-full border border-white/15 shadow-lg">
          <span className="text-[10px] uppercase font-bold text-white/50 tracking-widest mr-1">
            {t('langLabel')}:
          </span>

          {languageOptions.map(opt => (
            <button
              key={opt.code}
              onClick={() => setLang(opt.code)}
              className={`px-3 py-1.5 rounded-full text-xs font-bold transition-all ${
                lang === opt.code
                  ? 'bg-cyan-500 text-white shadow-[0_0_12px_rgba(34,211,238,0.5)]'
                  : 'text-white/60 hover:text-white hover:bg-white/10'
              }`}
            >
              {opt.label}
            </button>
          ))}
        </div>

        {/* Brand */}
        <div className="text-center mb-12">
          <h1 className="text-7xl md:text-8xl font-black tracking-tighter text-transparent bg-clip-text bg-gradient-to-br from-white via-cyan-200 to-blue-400 drop-shadow-[0_5px_15px_rgba(0,0,0,0.5)] mb-4">
            AquaGuard
          </h1>
          <p className="text-cyan-100 font-light tracking-widest text-sm md:text-base uppercase drop-shadow-md">
            {t('appTagline')}
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleAuth} className="space-y-6 w-full px-6">

          {message && (
            <div className={`p-4 rounded-xl text-sm ${
              message.type === 'error'
                ? 'bg-red-500/20 text-red-100'
                : 'bg-emerald-500/20 text-emerald-100'
            }`}>
              {message.text}
            </div>
          )}

          <input
            type="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            className="w-full px-6 py-4 rounded-full bg-white/10 border border-white/20 text-white text-center"
            placeholder={t('emailPlaceholder')}
            required
          />

          {mode === 'SIGNUP' && (
            <input
              type="tel"
              value={phone}
              onChange={e => setPhone(e.target.value)}
              className="w-full px-6 py-4 rounded-full bg-white/10 border border-white/20 text-white text-center"
              placeholder="Phone Number"
              required
            />
          )}

          {mode !== 'RESET' && (
            <input
              type="password"
              value={password}
              onChange={e => setPassword(e.target.value)}
              className="w-full px-6 py-4 rounded-full bg-white/10 border border-white/20 text-white text-center"
              placeholder={t('passwordPlaceholder')}
              required
            />
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full py-4 bg-cyan-500 text-white rounded-full font-bold disabled:opacity-50"
          >
            {loading
              ? 'Processing...'
              : mode === 'LOGIN'
              ? 'Sign In'
              : 'Signup'}
          </button>
        </form>

        {/* Bottom Text */}
        <div className="mt-10 text-white/70">
          {mode === 'LOGIN' ? (
            <p>
              New User?{' '}
              <button
                onClick={() => setMode('SIGNUP')}
                className="text-cyan-300 ml-2"
              >
                Signup
              </button>
            </p>
          ) : (
            <p>
              Already user?{' '}
              <button
                onClick={() => setMode('LOGIN')}
                className="text-cyan-300 ml-2"
              >
                Sign In
              </button>
            </p>
          )}
        </div>

      </div>

      {/* ✅ FLOATING CHATBOT */}
      <div className="fixed bottom-6 right-6 z-50">
        <Chatbot sensorData={sensorData} prefillSpecies={chatPrefill} />
      </div>

    </div>
  );
};

export default Auth;