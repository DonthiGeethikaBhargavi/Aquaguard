import React, { useState, useEffect } from 'react';
import Auth from './components/Auth';
import Dashboard from './components/Dashboard';
import { supabase } from './supabaseClient';
import { LanguageProvider } from './LanguageContext';

function App() {
  const [session, setSession] = useState(null);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });

    return () => subscription.unsubscribe();
  }, []);

  const handleLogout = async () => {
    await supabase.auth.signOut();
  };

  return (
    <LanguageProvider>
      <div className="relative min-h-screen text-white overflow-hidden font-sans bg-black">
        {/* Real Water Local Video Background */}
        <video
          autoPlay
          loop
          muted
          playsInline
          className="absolute z-0 w-auto min-w-full min-h-full max-w-none object-cover opacity-50"
          style={{ filter: "brightness(0.7) contrast(1.1)" }}
        >
          <source src="/water_clip.mp4" type="video/mp4" />
          <source src="https://assets.mixkit.co/videos/preview/mixkit-sea-surface-in-slow-motion-1185-large.mp4" type="video/mp4" />
        </video>
        <div className="absolute inset-0 bg-blue-900/30 z-0 pointer-events-none mix-blend-overlay" />

        <div className="relative z-10 w-full h-full min-h-screen flex flex-col">
          {!session ? (
            <Auth />
          ) : (
            <Dashboard 
              onLogout={handleLogout} 
              user={session.user}
            />
          )}
        </div>
      </div>
    </LanguageProvider>
  );
}

export default App;
