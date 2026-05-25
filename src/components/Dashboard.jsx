import React, { useEffect, useState, useCallback } from 'react';
import { supabase } from '../supabaseClient';
import { useLang } from '../LanguageContext';

// ----------------------------------------------------------------------
// Constants & Details
// ----------------------------------------------------------------------
const sensorDetails = {
  "Temperature": {
    importance: "Regulates metabolism, feeding rates, and digestion speed. Critical for aquatic health.",
    target: "26°C - 30°C",
    risk: "High temperatures deplete oxygen; low temperatures halt feeding and growth.",
  },
  "Humidity": {
    importance: "Measures facility air saturation for gas exchange and evaporative cooling.",
    target: "50% - 70%",
    risk: "Extremely high humidity blocks thermal regulation and can promote fungal growth.",
  },
  "Water Level": {
    importance: "Maintains total volume and buffer capacity of the system.",
    target: "90% - 100%",
    risk: "Low volume concentrates waste and causes rapid chemical/thermal spikes.",
  },
  "Pump System": {
    importance: "Drives oxygenation, filtration, and water circulation.",
    target: "Active / On",
    risk: "Failure leads to oxygen depletion and stagnant toxic zones within minutes.",
  }
};

// ----------------------------------------------------------------------
// AquaBook Database (15 Varieties)
// ----------------------------------------------------------------------
const aquaBookData = {
  Fishes: [
    { name: "Nile Tilapia", scientific: "Oreochromis niloticus", image: "https://loremflickr.com/600/400/tilapia,fish", bio: "A fast-growing, highly resilient freshwater fish. Known as the 'aquatic chicken' due to its fast growth rate and hardiness.", origin: "Native to the northern half of Africa and the Middle East.", feeding: "Omnivorous but prefers herbivorous diets. Feed 2-3 times daily with commercial pellets ranging from 28-32% protein.", profit: "Moderate margin, high volume." },
    { name: "Atlantic Salmon", scientific: "Salmo salar", image: "https://loremflickr.com/600/400/salmon,fish", bio: "An anadromous species highly prized for its rich, fatty flesh. Requires cold, highly oxygenated water.", origin: "Northern Atlantic Ocean and inflowing rivers.", feeding: "Strict carnivores. High-protein, high-lipid pelagic fish meal equivalents required 1-2 times daily.", profit: "High margin, requires advanced cold-water infrastructure." },
    { name: "Channel Catfish", scientific: "Ictalurus punctatus", image: "https://loremflickr.com/600/400/catfish,fish", bio: "A bottom-dwelling species prominent in North American aquaculture. Extremely tolerable to murky waters.", origin: "North America (primarily the Mississippi River basin).", feeding: "Bottom-feeders. Usually fed floating pellets (30-32% protein) so farmers can monitor feeding intensity.", profit: "Reliable medium margins." },
    { name: "Rainbow Trout", scientific: "Oncorhynchus mykiss", image: "https://loremflickr.com/600/400/trout,fish", bio: "A salmonid species that thrives in continuous, fast-flowing freshwater streams or raceways.", origin: "Cold-water tributaries of the Pacific Ocean in Asia and North America.", feeding: "Carnivorous. Requires frequent, automated high-protein meals (40%+).", profit: "High margin, exceptional market demand." },
    { name: "Barramundi", scientific: "Lates calcarifer", image: "https://loremflickr.com/600/400/barramundi,fish", bio: "A catadromous fish highly adaptable to both fresh and saltwater (euryhaline). Known for rapid growth.", origin: "Indo-West Pacific region, extensively across Australia and Southeast Asia.", feeding: "Aggressive visual predators. Require high-protein diets and must be size-graded frequently to prevent cannibalism.", profit: "Premium pricing, fast harvest turnover." }
  ],
  Prawns: [
    { name: "Giant Tiger Prawn", scientific: "Penaeus monodon", image: "https://loremflickr.com/600/400/shrimp,prawn", bio: "A massive, fast-growing crustacean known for its distinct striping. It commands premium market prices globally.", origin: "Indo-Pacific oceans.", feeding: "High protein (40-45%) pellets administered 3 to 5 times daily. Strict feed monitoring required to prevent bottom pollution.", profit: "Very High Margin (50%+)." },
    { name: "Pacific White Shrimp", scientific: "Litopenaeus vannamei", image: "https://loremflickr.com/600/400/shrimp,water", bio: "The dominant species in modern shrimp farming due to its adaptability to ultra-high-density farming and lower protein requirements.", origin: "Eastern Pacific Ocean, from Sonora, Mexico to northern Peru.", feeding: "Omnivorous scavengers. Feeds efficiently on 30-35% protein diets 4-6 times daily via auto-feeders.", profit: "High volume, consistent margins." },
    { name: "Giant Freshwater Prawn", scientific: "Macrobrachium rosenbergii", image: "https://loremflickr.com/600/400/prawn,freshwater", bio: "A freshwater species easily identifiable by extremely long, blue claws in dominant males. Requires lower stocking densities.", origin: "Tropical and subtropical regions of the Indo-Pacific.", feeding: "Opportunistic omnivores. Feed 2 times daily; they will also forage on natural pond detritus.", profit: "Niche premium market." },
    { name: "Kuruma Prawn", scientific: "Marsupenaeus japonicus", image: "https://loremflickr.com/600/400/shrimp,sea", bio: "Extremely valuable in Asian markets (often sold alive). Highly sensitive to environmental changes.", origin: "Indo-West Pacific.", feeding: "Requires incredibly high protein (50%+) and pristine water quality. Fed primarily at night.", profit: "Extremely high margin (Luxury pricing)." },
    { name: "Banana Prawn", scientific: "Fenneropenaeus merguiensis", image: "https://loremflickr.com/600/400/prawn,ocean", bio: "A smaller, schooling prawn famous for its sweet flavor. Often farmed extensively in mixed mangrove systems.", origin: "Indo-West Pacific region.", feeding: "Relies heavily on natural productivity (plankton/benthos) supplemented with low-level protein feeds.", profit: "Low input cost, moderate margin." }
  ],
  Crabs: [
    { name: "Giant Mud Crab", scientific: "Scylla serrata", image: "https://loremflickr.com/600/400/crab,mud", bio: "An aggressively territorial, massive crab farmed heavily across coastal Asia. Often farmed individually to prevent cannibalism.", origin: "Estuaries and mangroves of the Indo-Pacific.", feeding: "Carnivorous. Diet consists of trash fish, molluscs, and specifically formulated crab pellets. Feed once late afternoon.", profit: "Massive margins at restaurants." },
    { name: "Chinese Mitten Crab", scientific: "Eriocheir sinensis", image: "https://loremflickr.com/600/400/crab,river", bio: "A medium-sized burrowing crab named for its furry claws. Highly prized autumnal delicacy in Eastern Asia.", origin: "Eastern Asia river systems.", feeding: "Omnivorous. Frequently fed aquatic plants, corn, and supplementary fish meal. Requires waterweed-rich ponds.", profit: "Seasonal, extreme premium pricing." },
    { name: "Soft-Shell Mangrove Crab", scientific: "Scylla olivacea (Post-Molt)", image: "https://loremflickr.com/600/400/crab,soft", bio: "Not a specific species, but a specialized farming method where crabs are harvested perfectly timed right after moulting their hard shell.", origin: "Mangrove systems, harvested globally.", feeding: "Standard carnivore diet right up until moulting cycle begins, at which point feeding ceases. Constant observation required.", profit: "High culinary value." },
    { name: "Blue Swimming Crab", scientific: "Portunus pelagicus", image: "https://loremflickr.com/600/400/crab,blue", bio: "A fully marine, beautiful blue crab often farm-fattened or ranched. Requires high salinity and sandy bottoms.", origin: "Indo-Pacific oceans.", feeding: "Scavengers. Prefer bivalves, small fish, and specialized pelagic feeds.", profit: "Medium-high commercial meat value." },
    { name: "Red King Crab", scientific: "Paralithodes camtschaticus", image: "https://loremflickr.com/600/400/crab,alaska", bio: "Traditionally wild-caught, but early-stage hatchery rearing (aquaculture) is heavily researched to replenish stocks. Requires near-freezing waters.", origin: "Bering Sea and North Pacific Ocean.", feeding: "In juveniles, fed enriched zooplankton, shifting to benthic invertebrates.", profit: "One of the most expensive seafoods globally." }
  ]
};

// ----------------------------------------------------------------------
// MetricCard
// ----------------------------------------------------------------------
const MetricCard = ({ title, value, unit, icon, highlightColor, onClick, viewDetailsLabel, lastSync }) => (
  <button
    onClick={() => onClick(title)}
    className="relative group overflow-hidden backdrop-blur-md bg-white/5 border border-white/10 p-6 rounded-3xl shadow-[0_4px_30px_rgba(0,0,0,0.1)] hover:bg-white/10 hover:scale-[1.02] transition-all duration-300 active:scale-95 text-left w-full h-full block"
  >
    <div className={`absolute -inset-1 bg-gradient-to-r ${highlightColor} rounded-3xl blur opacity-25 group-hover:opacity-60 transition duration-500`} />
    <div className="relative pointer-events-none">
      <div className="flex justify-between items-center mb-4">
        <h3 className="uppercase tracking-wide text-xs font-bold text-cyan-100">{title}</h3>
        <div className="text-2xl drop-shadow-md">{icon}</div>
      </div>
      <div className="flex items-baseline gap-2">
        <span className="text-4xl font-extrabold text-white drop-shadow-sm">{value}</span>
        <span className="text-cyan-300 font-medium">{unit}</span>
      </div>
      <div className="mt-4 flex items-center justify-between">
        <span className="text-[0.65rem] uppercase font-bold text-cyan-200 bg-cyan-900/40 px-2 py-1 rounded">
          {viewDetailsLabel || 'View Details'}
        </span>
        {lastSync && (
          <div className="flex items-center gap-1.5 opacity-60">
            <div className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse shadow-[0_0_8px_rgba(52,211,153,0.8)]" />
            <span className="text-[10px] font-bold text-emerald-300 uppercase tracking-tighter">Live</span>
          </div>
        )}
      </div>
    </div>
  </button>
);

// ----------------------------------------------------------------------
// Dashboard
// ----------------------------------------------------------------------
const Dashboard = ({ onLogout, user }) => {
  const { t } = useLang();

  // -- Device State --
  const [devices, setDevices] = useState(() => {
    const meta = user?.user_metadata;
    if (meta?.device_list) return meta.device_list;
    if (meta?.kit_id) return [{ name: 'Default Kit', mac: meta.kit_id }];
    return [];
  });
  const [activeMac, setActiveMac] = useState(null);

  // -- Telemetry State --
  const [sensorData, setSensorData] = useState(null);
  const [lastSync, setLastSync] = useState(null);
  const [selectedSensor, setSelectedSensor] = useState(null);
  const [isInitialLoading, setIsInitialLoading] = useState(false);
  const [connError, setConnError] = useState(null);

  // -- UI State --
  const [activeTab, setActiveTab] = useState('live');
  const [abCategory, setAbCategory] = useState(null);
  const [abSpecies, setAbSpecies] = useState(null);
  const [chatPrefill, setChatPrefill] = useState(null);
  const [isManaging, setIsManaging] = useState(false);

  // -- Add Device Wizard State --
  const [newMac, setNewMac] = useState('');
  const [newName, setNewName] = useState('');
  const [wizardStep, setWizardStep] = useState(1); // 1: MAC, 2: Name

  // Sync with Supabase Metadata
  const syncDevices = async (newList) => {
    const { error } = await supabase.auth.updateUser({
      data: { device_list: newList }
    });
    if (error) console.error('Error syncing devices:', error);
  };

  const handleAddDevice = () => {
    if (!newMac || !newName) return;
    const newList = [...devices, { name: newName, mac: newMac.toUpperCase() }];
    setDevices(newList);
    syncDevices(newList);
    setNewMac('');
    setNewName('');
    setWizardStep(1);
    // Auto-select the newly added device to show debugging info
    setActiveMac(newMac.toUpperCase());
    setIsManaging(false);
  };

  const handleDeleteDevice = (mac) => {
    const newList = devices.filter(d => d.mac !== mac);
    setDevices(newList);
    syncDevices(newList);
    if (activeMac === mac) {
      setActiveMac(null);
      setSensorData(null);
    }
  };

  const handleUpdateNickname = (mac, newNick) => {
    const newList = devices.map(d => d.mac === mac ? { ...d, name: newNick } : d);
    setDevices(newList);
    syncDevices(newList);
  };

  const fetchSensorData = useCallback(async () => {
    if (!activeMac) return;
    setIsInitialLoading(true);
    setConnError(null);
    try {
      const { data, error } = await supabase
        .from('sensor_readings')
        .select('*')
        .ilike('mac_address', activeMac)
        .order('id', { ascending: false })
        .limit(1);

      if (error) {
        setConnError(error.message);
        throw error;
      }
      if (data?.length > 0) {
        setSensorData(data[0]);
        setLastSync(new Date());
      }
    } catch (err) {
      console.error('Error fetching sensor data:', err);
    } finally {
      setIsInitialLoading(false);
    }
  }, [activeMac]);

  useEffect(() => {
    if (!activeMac) {
      setSensorData(null);
      return;
    }

    fetchSensorData();
    const interval = setInterval(fetchSensorData, 10000);

    const channel = supabase
      .channel(`sensor_realtime_all`)
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'sensor_readings',
        // Broadening the listener: remove server-side filter to avoid metadata mismatch
      }, (payload) => {
        // Filter in frontend to ensure 100% reliable matching regardless of DB replication setup
        const recordMac = payload.new?.mac_address || payload.old?.mac_address;
        if (recordMac && recordMac.toUpperCase() === activeMac.toUpperCase()) {
          if (payload.eventType === 'DELETE') {
            fetchSensorData();
          } else {
            setSensorData(payload.new);
            setLastSync(new Date());
            setConnError(null);
          }
        }
      })
      .subscribe();

    return () => {
      clearInterval(interval);
      supabase.removeChannel(channel);
    };
  }, [fetchSensorData, activeMac]);

  const openCategory = (cat) => { setAbCategory(cat); setAbSpecies(null); };
  const openSpecies = (sp) => setAbSpecies(sp);
  const goBackToCategories = () => { setAbCategory(null); setAbSpecies(null); };
  const goBackToVarieties = () => setAbSpecies(null);

  const handleAskAquabot = (speciesName) => {
    setChatPrefill(null);
    setTimeout(() => setChatPrefill(speciesName), 50);
  };

  return (
    <div className="p-4 md:p-8 max-w-[90rem] mx-auto min-h-screen flex flex-col relative z-10 pt-6">

      {/* ── Header ── */}
      <header className="flex flex-col xl:flex-row justify-between items-start xl:items-center mb-8 pb-4 border-b border-white/10 backdrop-blur-md sticky top-0 z-20 gap-4">
        <div className="flex items-center gap-4">
          <div className="w-12 h-12 bg-gradient-to-br from-cyan-400 to-blue-600 rounded-full flex items-center justify-center shadow-[0_0_20px_rgba(34,211,238,0.5)] border border-white/20">
            <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
          <div>
            <h1 className="text-3xl font-black bg-clip-text text-transparent bg-gradient-to-r from-white to-cyan-300 drop-shadow-sm tracking-tight">
              {t('dashTitle')}
            </h1>
            <button
              onClick={() => setIsManaging(true)}
              className="text-xs text-cyan-200/80 font-bold tracking-widest uppercase mt-1 flex items-center gap-2 hover:text-cyan-100 transition-colors"
            >
              <span className={`w-2 h-2 rounded-full ${activeMac ? 'bg-emerald-400 animate-pulse' : 'bg-white/20'}`} />
              {activeMac ? devices.find(d => d.mac === activeMac)?.name : "NO DEVICE SELECTED"}
              <span className="ml-1 text-[10px] opacity-40">[MANAGE]</span>
            </button>
          </div>
        </div>

        <div className="flex items-center gap-4 w-full xl:w-auto">
          <div className="flex bg-black/40 rounded-full p-1 backdrop-blur-md border border-white/10 shadow-inner flex-1 xl:flex-none">
            <button
              onClick={() => setActiveTab('live')}
              className={`flex-1 xl:flex-none px-6 py-2 rounded-full text-sm font-bold transition-all ${activeTab === 'live' ? 'bg-cyan-500 text-white shadow-lg' : 'text-white/60 hover:text-white'}`}
            >
              {t('liveTab')}
            </button>
            <button
              onClick={() => { setActiveTab('aquabook'); setAbCategory(null); setAbSpecies(null); }}
              className={`flex-1 xl:flex-none px-6 py-2 rounded-full text-sm font-bold transition-all ${activeTab === 'aquabook' ? 'bg-blue-600 text-white shadow-lg' : 'text-white/60 hover:text-white'}`}
            >
              {t('aquabookTab')}
            </button>
          </div>
          <button
            onClick={onLogout}
            className="p-2 xl:px-5 xl:py-2.5 rounded-full border border-red-500/30 hover:bg-red-500/20 hover:border-red-500/80 transition-all focus:ring active:scale-95 text-sm font-bold flex items-center gap-2 text-red-200"
          >
            <span className="hidden xl:inline">{t('logOut')}</span>
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </button>
        </div>
      </header>

      {/* ── Main Content ── */}
      <div className="flex-grow flex flex-col relative w-full">

        {/* LIVE ANALYTICS TAB */}
        {activeTab === 'live' && (
          <div className="animate-in fade-in duration-700 w-full space-y-6">
            {!activeMac ? (
              <div className="flex flex-col items-center justify-center py-20 text-center space-y-6 bg-white/5 border border-white/10 rounded-[3rem] backdrop-blur-md">
                <div className="w-20 h-20 bg-white/5 rounded-full flex items-center justify-center text-4xl shadow-inner">🛰️</div>
                <div>
                  <h2 className="text-2xl font-bold text-white mb-2">System on Standby</h2>
                  <p className="text-white/50 max-w-sm mx-auto">Please select a registered device or link a new hardware kit to begin real-time monitoring.</p>
                </div>
                <div className="flex gap-4">
                  <button
                    onClick={() => setIsManaging(true)}
                    className="px-8 py-3 bg-cyan-500 text-white font-bold rounded-full shadow-lg hover:bg-cyan-400 transition-all"
                  >
                    Select Device
                  </button>
                  <button
                    onClick={() => { setIsManaging(true); setWizardStep(1); }}
                    className="px-8 py-3 bg-white/10 border border-white/20 text-white font-bold rounded-full hover:bg-white/20 transition-all"
                  >
                    Add New Kit
                  </button>
                </div>
              </div>
            ) : sensorData ? (
              <>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 xl:gap-8 z-10 w-full max-w-6xl mx-auto">
                  <MetricCard title="Temperature" value={sensorData.temperature} unit="°C" icon="🌡️" highlightColor="from-orange-400 to-red-500" onClick={setSelectedSensor} lastSync={lastSync} />
                  <MetricCard title="Humidity" value={sensorData.humidity} unit="%" icon="☁️" highlightColor="from-sky-300 to-indigo-300" onClick={setSelectedSensor} lastSync={lastSync} />
                  <MetricCard title="Water Level" value={sensorData.water_level} unit="%" icon="📏" highlightColor="from-cyan-300 to-blue-400" onClick={setSelectedSensor} lastSync={lastSync} />
                </div>

                <div className="backdrop-blur-xl bg-black/40 p-6 rounded-[2rem] border border-white/10 z-10 shadow-2xl flex flex-col xl:flex-row items-center gap-6">
                  <div className="flex-1">
                    <h2 className="text-xl font-bold text-white mb-1">{t('automatedTitle')}</h2>
                    <p className="text-xs text-white/50 tracking-wide uppercase font-semibold">{t('automatedSub')}</p>
                  </div>
                  <div className="flex flex-wrap gap-3">
                    <button className="px-5 py-3 rounded-2xl bg-orange-500/20 border border-orange-500/50 hover:bg-orange-500/40 text-orange-50 transition-all font-semibold text-sm shadow-lg flex items-center gap-2">
                      🧪 {t('dosePh')}
                    </button>
                    <button className="px-5 py-3 rounded-2xl bg-blue-500/20 border border-blue-500/50 hover:bg-blue-500/40 text-blue-50 transition-all font-semibold text-sm shadow-lg flex items-center gap-2">
                      🚰 {t('circulate')}
                    </button>
                    <button className="px-5 py-3 rounded-2xl bg-emerald-500/20 border border-emerald-500/50 hover:bg-emerald-500/40 text-emerald-50 transition-all font-semibold text-sm shadow-lg flex items-center gap-2">
                      ❄️ {t('chiller')}
                    </button>
                  </div>
                </div>
              </>
            ) : (
              <div className="flex-1 flex flex-col items-center justify-center py-20 bg-white/5 rounded-[3rem] border border-white/10 gap-6 backdrop-blur-sm text-center">
                <div className="relative">
                  <div className={`animate-spin rounded-full h-16 w-16 border-t-2 border-b-2 ${connError ? 'border-red-400' : 'border-cyan-400'}`} />
                  <div className="absolute inset-0 flex items-center justify-center">
                    <button
                      onClick={fetchSensorData}
                      disabled={isInitialLoading}
                      className="text-xl hover:scale-125 transition-transform active:rotate-180 duration-500"
                    >
                      {isInitialLoading ? '⌛' : '🔄'}
                    </button>
                  </div>
                </div>

                <div className="space-y-2">
                  <p className={`font-bold tracking-widest text-xs uppercase ${connError ? 'text-red-300' : 'text-cyan-200'}`}>
                    {connError ? 'Connection Blocked' : `Syncing with ${devices.find(d => d.mac === activeMac)?.name || 'Device'}`}
                  </p>
                  <p className="text-[10px] font-mono text-white/30 tracking-widest uppercase">
                    Channel: <span className="text-white/60">sensor_readings</span> | MAC: <span className="text-white/60">{activeMac}</span>
                  </p>
                </div>

                {connError ? (
                  <div className="bg-red-500/20 p-5 rounded-2xl border border-red-500/30 max-w-sm animate-pulse">
                    <p className="text-[10px] text-red-200 uppercase font-black mb-1">Database Error:</p>
                    <p className="text-xs text-red-100 italic">{connError}</p>
                    <p className="text-[9px] text-red-300/60 mt-3 uppercase font-bold leading-tight">Usually caused by RLS (Row Level Security). Run: <br /><code className="bg-black/40 px-1">ALTER TABLE sensor_readings DISABLE ROW LEVEL SECURITY;</code></p>
                  </div>
                ) : (
                  <div className="bg-black/20 p-4 rounded-2xl border border-white/5 max-w-sm">
                    <p className="text-[9px] text-white/40 uppercase leading-relaxed font-bold">
                      <span className="text-cyan-400">💡 Hint:</span> Click the circle to retry. Ensure your hardware is pushing to this MAC address.
                    </p>
                  </div>
                )}
              </div>
            )}
          </div>
        )}

        {/* AQUABOOK TAB */}
        {activeTab === 'aquabook' && (
          <div className="animate-fade-in w-full text-white">
            {/* ... keeping existing AquaBook logic ... */}
            {!abCategory && (
              <div className="space-y-8">
                <div className="mb-6 text-center">
                  <h2 className="text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-blue-200 via-cyan-300 to-blue-500 drop-shadow-md tracking-tighter">
                    {t('aquabookTitle')}
                  </h2>
                  <p className="text-cyan-100/70 text-base mt-3 font-light tracking-wide max-w-2xl mx-auto">
                    {t('aquabookSubtitle')}
                  </p>
                </div>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
                  <button onClick={() => openCategory('Fishes')} className="group backdrop-blur-md bg-white/5 border border-white/10 rounded-[2rem] p-10 hover:bg-white/10 transition-all hover:-translate-y-2 relative overflow-hidden text-center shadow-xl">
                    <div className="absolute inset-0 bg-blue-500/20 blur-3xl opacity-0 group-hover:opacity-100 transition-opacity" />
                    <div className="text-7xl mb-4 relative z-10 drop-shadow-lg group-hover:scale-110 transition-transform">🐟</div>
                    <h3 className="text-2xl font-bold uppercase tracking-widest text-blue-100 relative z-10">{t('fishesLabel')}</h3>
                    <p className="text-blue-200/50 text-sm mt-2 relative z-10 font-bold uppercase">{t('varietiesLogged')}</p>
                  </button>
                  <button onClick={() => openCategory('Prawns')} className="group backdrop-blur-md bg-white/5 border border-white/10 rounded-[2rem] p-10 hover:bg-white/10 transition-all hover:-translate-y-2 relative overflow-hidden text-center shadow-xl">
                    <div className="absolute inset-0 bg-orange-500/20 blur-3xl opacity-0 group-hover:opacity-100 transition-opacity" />
                    <div className="text-7xl mb-4 relative z-10 drop-shadow-lg group-hover:scale-110 transition-transform">🦐</div>
                    <h3 className="text-2xl font-bold uppercase tracking-widest text-orange-100 relative z-10">{t('prawnLabel')}</h3>
                    <p className="text-orange-200/50 text-sm mt-2 relative z-10 font-bold uppercase">{t('varietiesLogged')}</p>
                  </button>
                  <button onClick={() => openCategory('Crabs')} className="group backdrop-blur-md bg-white/5 border border-white/10 rounded-[2rem] p-10 hover:bg-white/10 transition-all hover:-translate-y-2 relative overflow-hidden text-center shadow-xl">
                    <div className="absolute inset-0 bg-red-500/20 blur-3xl opacity-0 group-hover:opacity-100 transition-opacity" />
                    <div className="text-7xl mb-4 relative z-10 drop-shadow-lg group-hover:scale-110 transition-transform">🦀</div>
                    <h3 className="text-2xl font-bold uppercase tracking-widest text-red-100 relative z-10">{t('crabsLabel')}</h3>
                    <p className="text-red-200/50 text-sm mt-2 relative z-10 font-bold uppercase">{t('varietiesLogged')}</p>
                  </button>
                </div>
              </div>
            )}
            {/* The rest of AquaBook is unchanged */}
            {abCategory && !abSpecies && (
              <div className="animate-slide-up">
                <button onClick={goBackToCategories} className="mb-8 flex items-center gap-2 text-cyan-400 hover:text-cyan-300 font-bold tracking-wider uppercase text-sm bg-black/30 backdrop-blur-md px-4 py-2 rounded-full border border-white/10">
                  {t('returnToDirectory')}
                </button>
                <h2 className="text-4xl font-black mb-8 text-white">
                  {t('knownVariants')} <span className="text-cyan-400">{abCategory}</span> {t('variants')}
                </h2>
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                  {aquaBookData[abCategory].map((species, idx) => (
                    <div
                      key={idx}
                      onClick={() => openSpecies(species)}
                      className="backdrop-blur-xl bg-black/40 border border-white/10 rounded-[2rem] p-6 shadow-2xl hover:bg-white/10 transition-all cursor-pointer group flex items-center gap-6"
                    >
                      <div
                        className="w-20 h-20 bg-cover bg-center rounded-2xl border border-white/20 shadow-lg group-hover:scale-105 transition-transform"
                        style={{ backgroundImage: `url(${species.image})` }}
                      />
                      <div>
                        <h3 className="text-xl font-bold text-white group-hover:text-cyan-300 transition-colors">{species.name}</h3>
                        <p className="text-xs text-white/50 italic mb-2">{species.scientific}</p>
                        <span className="text-[10px] bg-cyan-900/50 text-cyan-200 px-3 py-1 rounded-full uppercase tracking-widest font-bold">
                          {t('inspectProfile')}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
            {abCategory && abSpecies && (
              <div className="animate-slide-up max-w-5xl mx-auto">
                <button onClick={goBackToVarieties} className="mb-6 flex items-center gap-2 text-cyan-400 hover:text-cyan-300 font-bold tracking-wider uppercase text-sm bg-black/30 backdrop-blur-md px-4 py-2 rounded-full border border-white/10">
                  {t('backTo')} {abCategory}
                </button>
                <div className="backdrop-blur-xl bg-black/60 border border-white/10 rounded-[3rem] overflow-hidden shadow-2xl">
                  <div className="w-full h-72 md:h-96 relative">
                    <div className="absolute inset-0 bg-cover bg-center" style={{ backgroundImage: `url(${abSpecies.image})` }} />
                    <div className="absolute inset-0 bg-gradient-to-t from-black via-black/50 to-transparent" />
                    <div className="absolute bottom-0 left-0 p-8 md:p-12 w-full">
                      <h2 className="text-5xl md:text-6xl font-black text-white drop-shadow-lg mb-2">{abSpecies.name}</h2>
                      <p className="text-xl text-cyan-300 italic font-light drop-shadow-md">{abSpecies.scientific}</p>
                    </div>
                  </div>
                  <div className="p-8 md:p-12 grid grid-cols-1 md:grid-cols-2 gap-10">
                    <div className="space-y-8">
                      <div>
                        <h4 className="text-xs uppercase font-bold text-cyan-400 mb-3 tracking-widest flex items-center gap-2">{t('bioHistory')}</h4>
                        <p className="text-base text-white/90 leading-relaxed font-light">{abSpecies.bio}</p>
                      </div>
                      <div>
                        <h4 className="text-xs uppercase font-bold text-orange-400 mb-3 tracking-widest flex items-center gap-2">{t('geoOrigin')}</h4>
                        <p className="text-base text-white/90 leading-relaxed font-light">{abSpecies.origin}</p>
                      </div>
                    </div>
                    <div className="space-y-8">
                      <div>
                        <h4 className="text-xs uppercase font-bold text-emerald-400 mb-3 tracking-widest flex items-center gap-2">{t('feedingDetails')}</h4>
                        <div className="bg-white/5 border border-white/10 p-5 rounded-2xl">
                          <p className="text-base text-white/90 leading-relaxed font-light">{abSpecies.feeding}</p>
                        </div>
                      </div>
                      <div>
                        <h4 className="text-xs uppercase font-bold text-purple-400 mb-3 tracking-widest flex items-center gap-2">{t('commercialProfit')}</h4>
                        <div className="bg-black/40 border border-purple-500/30 p-5 rounded-2xl">
                          <p className="text-base text-purple-100 leading-relaxed font-bold">{abSpecies.profit}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div className="border-t border-white/10 p-8 bg-white/5 flex justify-center">
                    <button onClick={() => handleAskAquabot(abSpecies.name)} className="px-8 py-4 bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-400 hover:to-blue-500 text-white font-black rounded-full shadow-[0_0_30px_rgba(34,211,238,0.4)] transition-all hover:scale-105 flex items-center gap-3 border border-white/20">
                      <span className="text-xl">🤖</span>
                      {t('askAquabot')}
                    </button>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}
      </div>

      {/* ── Device Management Modal ── */}
      {isManaging && (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/90 backdrop-blur-md" onClick={() => setIsManaging(false)} />
          <div className="relative bg-gradient-to-br from-[#0f172a] to-[#020617] border border-white/10 p-8 md:p-10 rounded-[3rem] shadow-[0_30px_60px_-12px_rgba(0,0,0,0.5)] max-w-2xl w-full animate-in zoom-in-95 duration-200">
            <button onClick={() => setIsManaging(false)} className="absolute top-6 right-6 text-white/40 hover:text-white transition-colors bg-white/5 rounded-full p-2">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>

            <h3 className="text-3xl font-black text-white mb-8 tracking-tight">Manage Devices</h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {/* List Section */}
              <div className="space-y-4 max-h-[16rem] overflow-y-auto pr-2 custom-scrollbar">
                <label className="text-[10px] font-black tracking-widest text-white/30 uppercase">Registered Kits</label>
                {devices.length === 0 ? (
                  <p className="text-sm text-white/20 italic p-4 border border-dashed border-white/10 rounded-2xl text-center">No devices linked.</p>
                ) : devices.map((d) => (
                  <div key={d.mac} className="group relative bg-white/5 border border-white/5 transition-all p-4 rounded-2xl hover:bg-white/10 flex items-center justify-between">
                    <button
                      onClick={() => { setActiveMac(d.mac); setIsManaging(false); }}
                      className="flex-1 text-left"
                    >
                      <h4 className={`text-sm font-bold ${activeMac === d.mac ? 'text-cyan-400' : 'text-white'}`}>{d.name}</h4>
                      <p className="text-[10px] text-white/30 font-mono mt-1">{d.mac}</p>
                    </button>
                    <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                      <button
                        onClick={() => {
                          const newNick = prompt("Enter new nickname:", d.name);
                          if (newNick) handleUpdateNickname(d.mac, newNick);
                        }}
                        className="p-2 hover:text-cyan-400 text-white/30"
                      >
                        ✏️
                      </button>
                      <button
                        onClick={() => { if (window.confirm("Unlink this device?")) handleDeleteDevice(d.mac); }}
                        className="p-2 hover:text-red-500 text-white/30"
                      >
                        🗑️
                      </button>
                    </div>
                  </div>
                ))}
              </div>

              {/* Add Section (Wizard) */}
              <div className="bg-white/[0.03] p-6 rounded-3xl border border-white/5">
                <h4 className="text-[10px] font-black tracking-widest text-cyan-400 uppercase mb-4">Link New Hardware</h4>

                {wizardStep === 1 ? (
                  <div className="space-y-4 animate-in slide-in-from-right-4 duration-300">
                    <input
                      type="text"
                      placeholder="Enter MAC Address..."
                      value={newMac}
                      onChange={(e) => setNewMac(e.target.value)}
                      className="w-full bg-black/40 border border-white/10 p-4 rounded-xl text-white placeholder-white/20 focus:ring-1 focus:ring-cyan-500 font-mono text-center"
                    />
                    <button
                      onClick={() => { if (newMac.length > 5) setWizardStep(2); }}
                      className="w-full py-4 bg-white text-black font-black uppercase text-xs tracking-widest rounded-xl hover:bg-cyan-400 transition-colors"
                    >
                      Next: Name Device
                    </button>
                  </div>
                ) : (
                  <div className="space-y-4 animate-in slide-in-from-right-4 duration-300">
                    <input
                      type="text"
                      placeholder="e.g. Nursery Tank..."
                      value={newName}
                      onChange={(e) => setNewName(e.target.value)}
                      className="w-full bg-black/40 border border-white/10 p-4 rounded-xl text-white placeholder-white/20 focus:ring-1 focus:ring-cyan-500 text-center"
                    />
                    <button
                      onClick={handleAddDevice}
                      className="w-full py-4 bg-cyan-500 text-white font-black uppercase text-xs tracking-widest rounded-xl hover:bg-cyan-400 shadow-lg shadow-cyan-500/20 transition-all"
                    >
                      Finalize Link
                    </button>
                    <button
                      onClick={() => setWizardStep(1)}
                      className="w-full text-[10px] font-bold text-white/20 uppercase hover:text-white"
                    >
                      Back
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Sensor Detail Modal (keeping) */}
      {selectedSensor && activeTab === 'live' && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/80 backdrop-blur-sm" onClick={() => setSelectedSensor(null)} />
          <div className="relative bg-gradient-to-br from-[#0f172a] to-[#1e293b] border border-cyan-500/30 p-8 rounded-[2rem] shadow-[0_0_50px_rgba(8,145,178,0.3)] max-w-md w-full animate-fade-in transform scale-100">
            <button onClick={() => setSelectedSensor(null)} className="absolute top-5 right-5 text-white/40 hover:text-white transition-colors bg-white/5 rounded-full p-2">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
            <h3 className="text-2xl font-black text-white mb-1 uppercase tracking-tight">{selectedSensor}</h3>
            {/* ... rest of modal is same ... */}
            <div className="w-12 h-1 bg-cyan-500 rounded-full mb-6 mt-2" />
            <div className="space-y-4">
              <div className="bg-white/5 p-4 rounded-2xl border border-white/5">
                <h4 className="text-[10px] uppercase tracking-widest text-cyan-400 font-bold mb-1">{t('biologicalImportance')}</h4>
                <p className="text-sm text-white/90 leading-relaxed">{sensorDetails[selectedSensor]?.importance || "Crucial metric for monitoring system stability and health."}</p>
              </div>
              <div className="flex gap-4">
                <div className="bg-emerald-500/10 p-4 rounded-2xl border border-emerald-500/20 flex-1">
                  <h4 className="text-[10px] uppercase tracking-widest text-emerald-400 font-bold mb-1">{t('optimalTarget')}</h4>
                  <p className="text-lg font-bold text-emerald-100">{sensorDetails[selectedSensor]?.target || "Varies by species"}</p>
                </div>
              </div>
              <div className="bg-red-500/10 p-4 rounded-2xl border border-red-500/20 border-l-4 border-l-red-500">
                <h4 className="text-[10px] uppercase tracking-widest text-red-400 font-bold mb-1">{t('deviationRisk')}</h4>
                <p className="text-sm text-red-100/90 leading-relaxed">{sensorDetails[selectedSensor]?.risk || "May cause severe stock stress or mortality."}</p>
              </div>
            </div>
            <button onClick={() => setSelectedSensor(null)} className="mt-8 w-full py-3 bg-white/10 hover:bg-white/20 text-white rounded-xl font-bold transition-colors border border-white/10">
              {t('closePanel')}
            </button>
          </div>
        </div>
      )}

      

      <style dangerouslySetInnerHTML={{
        __html: `
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: rgba(255,255,255,0.05); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(34,211,238,0.5); }
      `}} />
    </div>
  );
};

export default Dashboard;
