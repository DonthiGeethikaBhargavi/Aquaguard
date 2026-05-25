import React, { useState, useEffect, useRef, useCallback } from 'react';
import { useLang, langLocales } from '../LanguageContext';

// ─────────────────────────────────────────────────────────────
// CSS ANIMATIONS — individual fish body-part animations
// ─────────────────────────────────────────────────────────────
const STYLES = `
  /* ── BODY BOB ── */
  @keyframes bodyIdle     { 0%,100%{transform:translateY(0) rotate(-0.5deg)} 50%{transform:translateY(-10px) rotate(0.5deg)} }
  @keyframes bodySpeak    { 0%,100%{transform:translateY(-3px) rotate(-2deg)} 33%{transform:translateY(-13px) rotate(2.5deg)} 66%{transform:translateY(-7px) rotate(-1.5deg)} }
  @keyframes bodyListen   { 0%,100%{transform:translateY(-4px) rotate(11deg) translateX(4px)} 50%{transform:translateY(-9px) rotate(11deg) translateX(4px)} }
  @keyframes bodyThink    { 0%,100%{transform:translateY(0) rotate(-4deg)} 33%{transform:translateY(-7px) rotate(3deg)} 66%{transform:translateY(-3px) rotate(-5deg)} }

  /* ── TAIL WAG ── */
  @keyframes tailIdle   { 0%,100%{transform:rotate(-7deg)} 50%{transform:rotate(9deg)} }
  @keyframes tailSpeak  { 0%,100%{transform:rotate(-20deg)} 25%{transform:rotate(15deg)} 75%{transform:rotate(-12deg)} }
  @keyframes tailListen { 0%,100%{transform:rotate(-3deg)} 50%{transform:rotate(4deg)} }
  @keyframes tailThink  { 0%,100%{transform:rotate(-4deg)} 50%{transform:rotate(4deg)} }

  /* ── DORSAL FIN ── */
  @keyframes dorsalIdle  { 0%,100%{transform:rotate(-3deg) scaleY(1)}   50%{transform:rotate(4deg) scaleY(1.08)} }
  @keyframes dorsalSpeak { 0%,100%{transform:rotate(-9deg) scaleY(0.9)} 50%{transform:rotate(11deg) scaleY(1.15)} }

  /* ── PECTORAL FIN ── */
  @keyframes pectIdle  { 0%,100%{transform:rotate(-5deg)}  50%{transform:rotate(9deg)} }
  @keyframes pectSpeak { 0%,100%{transform:rotate(-12deg)} 50%{transform:rotate(14deg)} }

  /* ── EYE BLINK (eyelid drops) ── */
  @keyframes eyeBlink { 0%,82%,100%{transform:scaleY(0)} 88%,94%{transform:scaleY(1)} }
  @keyframes eyeWide  { 0%,100%{transform:scaleY(0)} }

  /* ── MOUTH OPEN/CLOSE ── */
  @keyframes mouthTalk { 0%,100%{transform:scaleY(1) translateY(0)} 50%{transform:scaleY(0.15) translateY(-4px)} }

  /* ── PUPIL LOOK-UP (thinking) ── */
  @keyframes pupilUp   { 0%,100%{transform:translateY(0)}  50%{transform:translateY(-4px)} }
  @keyframes pupilNorm { 0%,100%{transform:translateY(0)} }

  /* ── PANEL SLIDE IN ── */
  @keyframes panelIn { from{opacity:0;transform:translateY(16px) scale(0.95)} to{opacity:1;transform:none} }

  /* body states */
  .fish-idle     { animation: bodyIdle    3.2s ease-in-out infinite; }
  .fish-speaking { animation: bodySpeak   0.55s ease-in-out infinite; }
  .fish-listening{ animation: bodyListen  2.2s ease-in-out infinite; }
  .fish-thinking { animation: bodyThink   1.4s ease-in-out infinite; }

  /* tail states */
  .tail-idle     { animation: tailIdle    2s ease-in-out infinite; transform-box:fill-box; transform-origin:right center; }
  .tail-speaking { animation: tailSpeak   0.28s ease-in-out infinite; transform-box:fill-box; transform-origin:right center; }
  .tail-listening{ animation: tailListen  3s ease-in-out infinite; transform-box:fill-box; transform-origin:right center; }
  .tail-thinking { animation: tailThink   2.5s ease-in-out infinite; transform-box:fill-box; transform-origin:right center; }

  /* dorsal fin */
  .dorsal-idle    { animation: dorsalIdle    2.6s ease-in-out infinite; transform-box:fill-box; transform-origin:bottom center; }
  .dorsal-speaking{ animation: dorsalSpeak   0.35s ease-in-out infinite; transform-box:fill-box; transform-origin:bottom center; }

  /* pectoral fin */
  .pect-idle    { animation: pectIdle    2.2s ease-in-out infinite; transform-box:fill-box; transform-origin:top right; }
  .pect-speaking{ animation: pectSpeak   0.3s ease-in-out infinite; transform-box:fill-box; transform-origin:top right; }

  /* eyelid */
  .eyelid-blink { animation: eyeBlink 4s linear infinite; transform-box:fill-box; transform-origin:center top; }
  .eyelid-wide  { animation: eyeWide  0.1s linear forwards; transform-box:fill-box; transform-origin:center top; }

  /* mouth */
  .mouth-talking { animation: mouthTalk 0.28s ease-in-out infinite; transform-box:fill-box; transform-origin:center center; }

  /* pupil */
  .pupil-thinking{ animation: pupilUp   1.4s ease-in-out infinite; transform-box:fill-box; }
  .pupil-normal  { animation: pupilNorm 0.1s linear forwards; transform-box:fill-box; }

  /* panel */
  .panel-in { animation: panelIn 0.38s cubic-bezier(0.34,1.56,0.64,1) both; }
`;

// ─────────────────────────────────────────────────────────────
// Animated SVG Fish (Chitti)
// ─────────────────────────────────────────────────────────────
const ChittiFish = ({ state, talking }) => {
  const tailCls   = `tail-${state}`;
  const dorsalCls = state === 'speaking' ? 'dorsal-speaking' : 'dorsal-idle';
  const pectCls   = state === 'speaking' ? 'pect-speaking'   : 'pect-idle';
  const eyelidCls = state === 'listening' ? 'eyelid-wide' : 'eyelid-blink';
  const mouthCls  = talking ? 'mouth-talking' : '';
  const pupilCls  = state === 'thinking' ? 'pupil-thinking' : 'pupil-normal';

  return (
    <svg viewBox="0 0 220 185" xmlns="http://www.w3.org/2000/svg"
      style={{ width: '100%', height: '100%', overflow: 'visible' }}>

      {/* ── TAIL ── (left side, flaps around attachment point) */}
      <g className={tailCls}>
        {/* upper lobe */}
        <path d="M 58,88 L 12,44 L 48,76 Z" fill="#f97316"/>
        {/* lower lobe */}
        <path d="M 58,92 L 12,136 L 48,104 Z" fill="#f97316"/>
        {/* centre web */}
        <path d="M 58,90 L 16,78 L 16,102 Z" fill="#fdba74" opacity="0.7"/>
        {/* fin ray lines */}
        <line x1="58" y1="88" x2="14" y2="46" stroke="#ea580c" strokeWidth="1.5" opacity="0.6"/>
        <line x1="58" y1="92" x2="14" y2="134" stroke="#ea580c" strokeWidth="1.5" opacity="0.6"/>
      </g>

      {/* ── BODY ── */}
      {/* shadow under body */}
      <ellipse cx="120" cy="178" rx="62" ry="7" fill="rgba(0,0,0,0.18)"/>
      {/* main body */}
      <ellipse cx="122" cy="90" rx="80" ry="58" fill="#c2410c"/>
      {/* bright highlight layer */}
      <ellipse cx="116" cy="84" rx="64" ry="46" fill="#ea580c"/>
      {/* top sheen */}
      <ellipse cx="108" cy="72" rx="38" ry="24" fill="#f97316" opacity="0.55"/>

      {/* ── WHITE STRIPE ── */}
      <ellipse cx="110" cy="90" rx="21" ry="57" fill="#c2410c"/>
      <ellipse cx="110" cy="90" rx="17" ry="53" fill="white"/>

      {/* ── DORSAL FIN (top) ── */}
      <g className={dorsalCls}>
        <path d="M 98,36 Q 114,6 150,28 Q 144,54 110,58 Z" fill="#f97316"/>
        <path d="M 103,37 Q 116,14 144,30 Q 138,50 112,54 Z" fill="#fdba74" opacity="0.5"/>
        {/* fin rays */}
        <line x1="105" y1="40" x2="118" y2="16" stroke="#ea580c" strokeWidth="1.2" opacity="0.5"/>
        <line x1="118" y1="38" x2="132" y2="16" stroke="#ea580c" strokeWidth="1.2" opacity="0.5"/>
        <line x1="132" y1="37" x2="144" y2="24" stroke="#ea580c" strokeWidth="1.2" opacity="0.5"/>
      </g>

      {/* ── PECTORAL FIN (lower left) ── */}
      <g className={pectCls}>
        <path d="M 97,128 Q 70,162 86,170 Q 106,158 112,134 Z" fill="#f97316"/>
        <path d="M 99,130 Q 78,156 88,163 Q 104,154 108,134 Z" fill="#fdba74" opacity="0.45"/>
        <line x1="99" y1="130" x2="76" y2="158" stroke="#ea580c" strokeWidth="1.2" opacity="0.5"/>
      </g>

      {/* ── SMALL REAR FIN ── */}
      <path d="M 148,122 Q 170,138 165,148 Q 151,140 145,126 Z" fill="#f97316"/>

      {/* ── EYE ── */}
      {/* sclera */}
      <circle cx="170" cy="74" r="25" fill="white"/>
      {/* iris */}
      <circle cx="170" cy="74" r="18" fill="#92400e"/>
      {/* pupil */}
      <g className={pupilCls}>
        <circle cx="170" cy="74" r="11" fill="#0c0a09"/>
        {/* highlights */}
        <circle cx="175" cy="68" r="5"   fill="white"/>
        <circle cx="164" cy="80" r="2.5" fill="white" opacity="0.65"/>
      </g>
      {/* eyelid (blinks down) */}
      <ellipse cx="170" cy="50" rx="25" ry="24" fill="#ea580c" className={eyelidCls}/>

      {/* ── CHEEK BLUSH ── */}
      <circle cx="155" cy="94" r="11" fill="#fb7185" opacity="0.28"/>

      {/* ── MOUTH ── */}
      <g className={mouthCls}>
        {/* upper lip curve */}
        <path d="M 148,108 Q 163,101 178,108" stroke="#7c2d12" strokeWidth="3"
              fill="#c2410c" strokeLinecap="round"/>
        {/* teeth */}
        <path d="M 150,109 Q 163,116 176,109 L 175,114 Q 163,122 151,114 Z" fill="white"/>
        {/* lower lip */}
        <path d="M 149,114 Q 163,124 177,114" stroke="#7c2d12" strokeWidth="2.5"
              fill="none" strokeLinecap="round"/>
      </g>
    </svg>
  );
};

// ─────────────────────────────────────────────────────────────
// Greetings per language
// ─────────────────────────────────────────────────────────────
const greetings = {
  en: "Hi! I'm Chitti 🐟 — your AquaGuard fish assistant! Ask me about sensors, species, or water quality. Tap the mic and speak!",
  te: "నమస్కారం! నేను చిట్టిని 🐟 — మీ AquaGuard చేప సహాయకురాలిని! సెన్సర్‌లు, చేపల జాతులు, నీటి నాణ్యత గురించి అడగండి. మైక్ నొక్కి మాట్లాడండి!",
  ta: "வணக்கம்! நான் சிட்டி 🐟 — உங்கள் AquaGuard மீன் உதவியாளர்! தயவுசெய்து கேளுங்கள்!",
  hi: "नमस्ते! मैं चिट्टी 🐟 — आपकी AquaGuard मछली सहायक! कुछ भी पूछें!",
};

const chittiName = { en: 'Chitti', te: 'చిట్టి', ta: 'சிட்டி', hi: 'चिट्टी' };

const stateLabel = {
  idle:      { en:'Ready',       te:'సిద్ధంగా ఉంది', ta:'தயார்',      hi:'तैयार' },
  speaking:  { en:'Speaking...', te:'మాట్లాడుతోంది', ta:'பேசுகிறது...', hi:'बोल रही है...' },
  listening: { en:'Listening...', te:'వింటోంది...',  ta:'கேட்கிறது...', hi:'सुन रही है...' },
  thinking:  { en:'Thinking...',  te:'ఆలోచిస్తోంది', ta:'யோசிக்கிறது...', hi:'सोच रही है...' },
};

const stateColor = { idle:'text-cyan-300', speaking:'text-amber-300', listening:'text-emerald-300', thinking:'text-purple-300' };

// ─────────────────────────────────────────────────────────────
// Knowledge engine (same as before)
// ─────────────────────────────────────────────────────────────
const kw = {
  greeting:  ['hello','hi','hey','namaste','vanakkam','namaskaram','నమస్కారం','హలో','నమస్తే','வணக்கம்'],
  help:      ['help','what can','capabilities','options'],
  ph:        ['ph','acidity','alkalin'],
  do:        ['oxygen','dissolved','ఆక్సిజన్'],
  temp:      ['temp','heat','cold','warm','వేడి','చలి','ఉష్ణ'],
  ammonia:   ['ammonia','అమోనియా'],
  tds:       ['tds','solids','mineral'],
  turb:      ['turbidity','clarity','murky','ntu'],
  level:     ['water level','tank level','depth'],
  humidity:  ['humidity','ambient'],
  status:    ['status','current','reading','sensor','check','now','చెప్పు','చూపు','ఇప్పుడు','ఎంత','ఏమిటి'],
  tilapia:   ['tilapia','తిలాపియా'],
  salmon:    ['salmon'],
  barramundi:['barramundi'],
  prawn:     ['prawn','shrimp','రొయ్య','రొయ్యలు'],
  crab:      ['crab','పీత'],
  feeding:   ['feed','food','diet','eat','protein','తినడం','ఆహారం'],
  profit:    ['profit','margin','revenue','money','లాభం'],
};
const has = (msg, keys) => keys.some(k => msg.includes(k));

function answer(input, sensorData, lang) {
  const msg = input.toLowerCase();
  if (has(msg, kw.greeting)) return greetings[lang] || greetings.en;
  if (has(msg, kw.help)) {
    return lang==='te'
      ? 'నేను సెన్సర్ రీడింగ్‌లు, జాతుల సమాచారం, ఆహార సలహాలు మరియు నీటి నాణ్యత గురించి సహాయం చేయగలను!'
      : 'I can help with sensor readings, species info, feeding tips, and water quality. Just ask!';
  }

  if (has(msg, kw.status)) {
    if (!sensorData) return lang==='te' ? 'సెన్సర్ డేటా అందుబాటులో లేదు.' : 'Sensor data not available.';
    if (has(msg, kw.ph))
      return lang==='te'
        ? `ప్రస్తుతం pH విలువ ${sensorData.ph}. సరైన పరిమితి 7.5–8.5. ${parseFloat(sensorData.ph)<7.5?'⚠️ కాస్త తక్కువగా ఉంది. pH బఫర్ వాడండి.':'✅ pH సురక్షితంగా ఉంది!'}`
        : `Current pH is ${sensorData.ph}. Target 7.5–8.5. ${parseFloat(sensorData.ph)<7.5?'⚠️ Slightly low! Add pH buffer.':'✅ pH looks safe!'}`;
    if (has(msg, kw.do))
      return lang==='te'
        ? `కరిగిన ఆక్సిజన్ ${sensorData.dissolved_oxygen} mg/L. 5.0 పైన ఉండాలి. ${parseFloat(sensorData.dissolved_oxygen)<5?'🚨 ప్రమాదం! వెంటనే ఏరేటర్లు ఆన్ చేయండి.':'✅ ఆక్సిజన్ సురక్షితం.'}`
        : `DO is ${sensorData.dissolved_oxygen} mg/L. Must be above 5.0. ${parseFloat(sensorData.dissolved_oxygen)<5?'🚨 Critical! Activate aerators!':'✅ Oxygen is safe.'}`;
    if (has(msg, kw.temp))
      return lang==='te'
        ? `ఉష్ణోగ్రత ${sensorData.temperature}°C. 26–30°C మధ్య ఉండాలి. ${parseFloat(sensorData.temperature)>30?'⚠️ వేడిగా ఉంది! చిల్లర్ వాడండి.':'✅ సురక్షితంగా ఉంది.'}`
        : `Temperature is ${sensorData.temperature}°C. Ideal 26–30°C. ${parseFloat(sensorData.temperature)>30?'⚠️ Too hot! Activate chiller.':'✅ Temperature is fine.'}`;
    if (has(msg, kw.ammonia))
      return lang==='te'
        ? `అమోనియా ${sensorData.ammonia} mg/L. 0.1 కంటే తక్కువగా ఉండాలి. ${parseFloat(sensorData.ammonia)>0.1?'🚨 హెచ్చరిక! వెంటనే నీటి మార్పిడి చేయండి.':'✅ సురక్షితం.'}`
        : `Ammonia is ${sensorData.ammonia} mg/L. Must be below 0.1. ${parseFloat(sensorData.ammonia)>0.1?'🚨 Toxic! Reduce feeding & exchange water.':'✅ Ammonia is safe.'}`;
    // General overview
    return lang==='te'
      ? `ప్రస్తుత స్థితి:\n• pH: ${sensorData.ph}\n• ఆక్సిజన్: ${sensorData.dissolved_oxygen} mg/L\n• ఉష్ణోగ్రత: ${sensorData.temperature}°C\n• అమోనియా: ${sensorData.ammonia} mg/L\n• TDS: ${sensorData.tds} ppm\n• నీటి స్థాయి: ${sensorData.water_level}%`
      : `Current status:\n• pH: ${sensorData.ph}\n• O₂: ${sensorData.dissolved_oxygen} mg/L\n• Temp: ${sensorData.temperature}°C\n• Ammonia: ${sensorData.ammonia} mg/L\n• TDS: ${sensorData.tds} ppm\n• Water Level: ${sensorData.water_level}%`;
  }

  if (has(msg, kw.ph))
    return lang==='te'
      ? 'pH నీటి ఆమ్లత్వాన్ని కొలుస్తుంది. రొయ్యలు మరియు చేపలకు 7.5–8.5 మధ్య ఉండాలి.'
      : 'pH measures water acidity. Ideal 7.5–8.5 for fish and prawns. Below 7.0 stunts growth; above 9.0 can kill.';
  if (has(msg, kw.do))
    return lang==='te'
      ? 'కరిగిన ఆక్సిజన్ అన్ని జలజీవులకు అత్యంత ముఖ్యమైనది. ఎల్లప్పుడూ 5.0 mg/L పైన ఉండాలి.'
      : 'Dissolved oxygen is critical for aquatic life. Always maintain above 5.0 mg/L. Use aerators if low.';
  if (has(msg, kw.temp))
    return lang==='te'
      ? 'నీటి ఉష్ణోగ్రత 26–30°C మధ్య ఉండాలి. వేడి నీరు ఆక్సిజన్ తగ్గిస్తుంది; చల్లని నీరు తినడం ఆపుతుంది.'
      : 'Temperature should be 26–30°C. Hot water reduces oxygen; cold halts feeding completely.';
  if (has(msg, kw.ammonia))
    return lang==='te'
      ? 'అమోనియా తినని ఆహారం మరియు వ్యర్థాల వల్ల ఏర్పడుతుంది. 0.1 mg/L కంటే తక్కువగా ఉండాలి.'
      : 'Ammonia comes from uneaten feed and waste. Keep below 0.1 mg/L — it burns gills and suppresses immunity.';
  if (has(msg, kw.tilapia))
    return lang==='te'
      ? 'నైలు తిలాపియా — "జలచర కోడి" అని పిలుస్తారు! చాలా వేగంగా పెరుగుతుంది. రోజుకు 2–3 సార్లు 28–32% ప్రోటీన్ పెల్లెట్లు ఇవ్వండి.'
      : 'Nile Tilapia — the "aquatic chicken"! Fast-growing, hardy omnivore. Feed 2–3× daily with 28–32% protein pellets.';
  if (has(msg, kw.prawn))
    return lang==='te'
      ? 'రొయ్యల సాగు చాలా లాభదాయకం! వన్నమేయ్ రొయ్య (Pacific White Shrimp) అత్యంత ప్రజాదరణ పొందినది. రోజుకు 4–6 సార్లు తినిపించండి.'
      : 'Prawn farming is highly profitable! Pacific White Shrimp (Vannamei) is the most popular. Feed 4–6× daily.';
  if (has(msg, kw.crab))
    return lang==='te'
      ? 'పీత సాగు చాలా లాభదాయకం, ముఖ్యంగా రెస్టారెంట్లలో! పెద్ద మట్టి పీత (Scylla serrata) ఒంటరిగా పెంచాలి.'
      : 'Crab farming is very profitable! Giant Mud Crab (Scylla serrata) must be farmed individually to prevent cannibalism.';
  if (has(msg, kw.feeding))
    return lang==='te'
      ? 'ఆహారం వ్యూహం జాతిపై ఆధారపడి ఉంటుంది. అధికంగా తినిపించకండి — అమోనియా పెరుగుతుంది! ఏ జాతి గురించి తెలుసుకోవాలి?'
      : 'Feeding depends on species. Avoid overfeeding — it spikes ammonia! Which species do you want advice on?';
  if (has(msg, kw.profit))
    return lang==='te'
      ? 'అత్యధిక లాభదాయక జాతులు: కురుమా రొయ్య, రెడ్ కింగ్ క్రాబ్, అట్లాంటిక్ సాల్మన్. అధిక పరిమాణం: వన్నమేయ్, తిలాపియా.'
      : 'Most profitable: Kuruma Prawn, Red King Crab, Atlantic Salmon. High volume: Vannamei Shrimp, Tilapia.';

  return lang==='te'
    ? 'సరిగ్గా అర్థం కాలేదు 😊 pH, ఆక్సిజన్, ఉష్ణోగ్రత లేదా చేపల జాతుల గురించి అడగండి!'
    : "I didn't quite catch that 😊 Try asking about pH, oxygen, temperature, or a specific species!";
}

// ─────────────────────────────────────────────────────────────
// Main Chatbot Component
// ─────────────────────────────────────────────────────────────
const Chatbot = ({ sensorData, prefillSpecies }) => {
  const { lang, t } = useLang();
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');
  const [bodyState, setBodyState] = useState('idle');
  const [mouthTalking, setMouthTalking] = useState(false);

  const synthRef       = useRef(window.speechSynthesis);
  const voicesRef      = useRef([]);
  const recognitionRef = useRef(null);
  const mouthTimerRef  = useRef(null);
  const endRef         = useRef(null);
  const initialized    = useRef(false);
  const styleInjected  = useRef(false);

  // Inject CSS once
  useEffect(() => {
    if (styleInjected.current) return;
    styleInjected.current = true;
    const el = document.createElement('style');
    el.textContent = STYLES;
    document.head.appendChild(el);
  }, []);

  // ── VOICE LOADING (critical fix for Telugu) ──
  useEffect(() => {
    const load = () => { voicesRef.current = window.speechSynthesis?.getVoices() || []; };
    load();
    window.speechSynthesis?.addEventListener('voiceschanged', load);
    return () => window.speechSynthesis?.removeEventListener('voiceschanged', load);
  }, []);

  // Scroll to bottom
  useEffect(() => { endRef.current?.scrollIntoView({ behavior: 'smooth' }); }, [messages, bodyState]);

  // Greet when first opened
  useEffect(() => {
    if (open && !initialized.current) {
      initialized.current = true;
      const g = greetings[lang] || greetings.en;
      setMessages([{ from: 'bot', text: g }]);
      setTimeout(() => speakText(g), 500);
    }
  }, [open]); // eslint-disable-line

  // AquaBook species pre-fill
  useEffect(() => {
    if (prefillSpecies) {
      setOpen(true);
      setTimeout(() => handleSend(`Tell me about ${prefillSpecies}`), 350);
    }
  }, [prefillSpecies]); // eslint-disable-line

  // ── TTS SPEAK ──
  const speakText = useCallback((text) => {
    const synth = synthRef.current;
    if (!synth) return;
    synth.cancel();

    const utt = new SpeechSynthesisUtterance(text);
utt.lang = lang;
    utt.pitch  = 1.4;   // feminine
    utt.rate   = 0.9;
    utt.volume = 1;

    // ── Best voice selection ──
    const voices = voicesRef.current;
const pick =
  voices.find(v => v.lang === lang && /female|woman|girl/i.test(v.name)) ||
  voices.find(v => v.lang === lang) ||
  voices.find(v => v.lang.startsWith(lang)) ||
      // 4) Any female voice
      voices.find(v => /zira|siri|samantha|ava|karen|victoria|female/i.test(v.name)) ||
      null;
    if (pick) utt.voice = pick;

    utt.onstart = () => {
      setBodyState('speaking');
      setMouthTalking(true);
    };
    utt.onend = () => {
      setBodyState('idle');
      setMouthTalking(false);
    };
    utt.onerror = () => {
      setBodyState('idle');
      setMouthTalking(false);
    };
    synth.speak(utt);
  }, [lang]);

  const addMsg = (from, text) => setMessages(p => [...p, { from, text }]);

  const handleSend = useCallback((override) => {
    const q = typeof override === 'string' ? override : input.trim();
    if (!q) return;
    addMsg('user', q);
    setInput('');
    setBodyState('thinking');
    setMouthTalking(false);

    setTimeout(() => {
      const resp = answer(q, sensorData, lang);
      addMsg('bot', resp);
      speakText(resp);
    }, 650);
  }, [input, sensorData, lang, speakText]);

  const startListening = () => {
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SR) { addMsg('bot', lang==='te' ? 'ఈ బ్రౌజర్‌లో వాయిస్ మద్దతు లేదు. Chrome వాడండి.' : 'Voice not supported. Use Chrome.'); return; }
    if (recognitionRef.current) recognitionRef.current.stop();
    const rec = new SR();
    recognitionRef.current = rec;
    rec.lang = lang;
    rec.interimResults = false;
    rec.onstart  = () => setBodyState('listening');
    rec.onend    = () => { if (bodyState === 'listening') setBodyState('idle'); };
    rec.onerror  = () => setBodyState('idle');
    rec.onresult = e => { setBodyState('idle'); handleSend(e.results[0][0].transcript); };
    rec.start();
  };

  const stopSpeaking = () => {
    synthRef.current?.cancel();
    setBodyState('idle');
    setMouthTalking(false);
  };

  const fishBodyCls = `fish-${bodyState}`;

  return (
    <>
      {/* ── FAB ── */}
      <button
        onClick={() => setOpen(o => !o)}
        className="fixed bottom-6 right-6 z-50 w-20 h-20 rounded-full flex items-center justify-center transition-all hover:scale-110 active:scale-95 select-none"
        style={{
          background: 'radial-gradient(circle at 38% 32%, #fdba74, #f97316, #c2410c)',
          boxShadow: open
            ? '0 0 0 4px rgba(251,191,36,0.3),0 0 34px rgba(251,191,36,0.55)'
            : '0 0 0 3px rgba(255,255,255,0.15),0 8px 32px rgba(0,0,0,0.45)',
          border: '2.5px solid rgba(255,255,255,0.28)',
        }}
        title="Chat with Chitti"
      >
        {open
          ? <span className="text-white font-black text-xl">✕</span>
          : <img src="/chitti.png" alt="Chitti" className="w-14 h-14 object-contain drop-shadow-lg"/>
        }
        {!open && (
          <span className="absolute top-0.5 right-0.5 w-5 h-5 bg-emerald-400 rounded-full border-2 border-[#0f172a] animate-pulse"/>
        )}
      </button>

      {/* ── PANEL ── */}
      {open && (
        <div
          className="fixed bottom-28 right-6 z-50 flex flex-col rounded-[2rem] overflow-hidden panel-in"
          style={{
            width: 'min(400px, calc(100vw - 48px))',
            maxHeight: '82vh',
            background: 'linear-gradient(160deg,rgba(10,18,38,0.97),rgba(20,32,58,0.97))',
            border: '1.5px solid rgba(251,191,36,0.22)',
            boxShadow: '0 0 70px rgba(249,115,22,0.18),0 24px 64px rgba(0,0,0,0.65)',
          }}
        >
          {/* ── HEADER / FISH AVATAR ── */}
          <div className="flex flex-col items-center pt-5 pb-2 px-4 relative"
               style={{ background:'linear-gradient(180deg,rgba(234,88,12,0.2) 0%,transparent 100%)' }}>

            {/* Glow backdrop */}
            <div className="absolute inset-0 pointer-events-none overflow-hidden rounded-t-[2rem]">
              <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-48 h-48 rounded-full"
                   style={{ background:'radial-gradient(circle,rgba(251,191,36,0.12),transparent 70%)' }}/>
            </div>

            {/* Animated SVG fish */}
            <div className={`relative w-36 h-28 ${fishBodyCls}`} style={{ filter:'drop-shadow(0 6px 18px rgba(0,0,0,0.5))' }}>
              <ChittiFish state={bodyState} talking={mouthTalking}/>

              {/* Listening pulse ring */}
              {bodyState === 'listening' && (
                <div className="absolute inset-0 rounded-full border-4 border-emerald-400/60 animate-ping pointer-events-none" style={{ borderRadius:'50%' }}/>
              )}
            </div>

            {/* Name + status */}
            <div className="text-center mt-1 relative z-10">
              <p className="font-black text-white text-base tracking-wide">{chittiName[lang]}</p>
              <p className={`text-[11px] font-bold mt-0.5 transition-colors duration-300 ${stateColor[bodyState]}`}>
                {stateLabel[bodyState]?.[lang] || stateLabel[bodyState]?.en}
              </p>
            </div>

            {/* Stop speech button */}
            {bodyState === 'speaking' && (
              <button onClick={stopSpeaking}
                className="absolute top-3 right-4 w-8 h-8 rounded-full bg-amber-500/25 border border-amber-400/50 text-amber-200 text-sm flex items-center justify-center hover:bg-amber-500/50 transition-all"
                title="Stop speaking">🔇</button>
            )}
          </div>

          {/* Divider */}
          <div className="h-px mx-4" style={{ background:'linear-gradient(90deg,transparent,rgba(251,191,36,0.28),transparent)' }}/>

          {/* ── MESSAGES ── */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3" style={{ minHeight:160, maxHeight:'40vh' }}>
            {messages.map((m, i) => (
              <div key={i} className={`flex items-end gap-2 ${m.from==='user'?'justify-end':'justify-start'}`}>
                {m.from==='bot' && (
                  <div className="w-6 h-6 flex-shrink-0 mb-0.5">
                    <svg viewBox="0 0 220 185" style={{ width:'100%', height:'100%' }}>
                      <ellipse cx="122" cy="90" rx="80" ry="58" fill="#ea580c"/>
                      <ellipse cx="110" cy="90" rx="17" ry="53" fill="white"/>
                      <circle cx="170" cy="74" r="20" fill="white"/>
                      <circle cx="170" cy="74" r="11" fill="#0c0a09"/>
                      <circle cx="174" cy="69" r="4" fill="white"/>
                    </svg>
                  </div>
                )}
                <div className={`max-w-[82%] px-4 py-2.5 text-sm leading-relaxed whitespace-pre-wrap rounded-2xl ${
                  m.from==='user'
                    ? 'bg-gradient-to-br from-cyan-600/80 to-blue-700/80 text-white rounded-br-sm border border-cyan-400/20'
                    : 'text-white/90 rounded-bl-sm border border-white/10'
                }`} style={{ background: m.from==='bot' ? 'rgba(255,255,255,0.06)' : undefined }}>
                  {m.text}
                </div>
              </div>
            ))}
            {bodyState === 'thinking' && (
              <div className="flex items-end gap-2">
                <div className="w-6 h-6 flex-shrink-0 mb-0.5 opacity-70">
                  <svg viewBox="0 0 220 185"><ellipse cx="122" cy="90" rx="80" ry="58" fill="#ea580c"/><circle cx="170" cy="74" r="20" fill="white"/><circle cx="170" cy="74" r="11" fill="#0c0a09"/></svg>
                </div>
                <div className="bg-white/6 border border-white/10 px-4 py-3 rounded-2xl rounded-bl-sm flex gap-1.5">
                  {[0,150,300].map(d => (
                    <span key={d} className="w-2 h-2 bg-amber-400 rounded-full animate-bounce" style={{ animationDelay:`${d}ms` }}/>
                  ))}
                </div>
              </div>
            )}
            <div ref={endRef}/>
          </div>

          {/* ── INPUT BAR ── */}
          <div className="p-3 flex items-center gap-2"
               style={{ borderTop:'1px solid rgba(255,255,255,0.07)', background:'rgba(0,0,0,0.28)' }}>
            {/* Mic */}
            <button onClick={startListening}
              disabled={bodyState==='listening'||bodyState==='speaking'}
              className={`w-11 h-11 rounded-full flex-shrink-0 flex items-center justify-center transition-all border ${
                bodyState==='listening'
                  ? 'bg-red-500 border-red-400 shadow-[0_0_18px_rgba(239,68,68,0.8)] animate-pulse'
                  : 'bg-white/10 border-white/20 hover:bg-orange-500/30 hover:border-orange-400/60'
              }`}
              title={bodyState==='listening' ? '...' : 'Speak to Chitti'}
            >
              <span className="text-base">{bodyState==='listening'?'🔴':'🎤'}</span>
            </button>

            {/* Text input */}
            <input
              type="text"
              value={input}
              onChange={e => setInput(e.target.value)}
              onKeyDown={e => e.key==='Enter' && handleSend()}
              placeholder={
                bodyState==='listening'
                  ? (lang==='te'?'వింటోంది...':'Listening...')
                  : (lang==='te'?'చిట్టిని అడగండి...'
                  : lang==='ta'?'சிட்டியிடம் கேளுங்கள்...'
                  : lang==='hi'?'चिट्टी से पूछें...'
                  : 'Ask Chitti anything...')
              }
              disabled={bodyState==='listening'}
              className="flex-1 rounded-full px-4 py-2.5 text-sm text-white placeholder-white/35 focus:outline-none focus:ring-2 focus:ring-orange-400/40 min-w-0"
              style={{ background:'rgba(255,255,255,0.08)', border:'1px solid rgba(255,255,255,0.12)' }}
            />

            {/* Send */}
            <button onClick={() => handleSend()}
              disabled={!input.trim()||bodyState==='thinking'||bodyState==='listening'}
              className="w-11 h-11 rounded-full flex-shrink-0 flex items-center justify-center transition-all disabled:opacity-30 hover:scale-110 active:scale-95 shadow-lg"
              style={{ background:'linear-gradient(135deg,#f97316,#f59e0b)' }}
            >
              <svg className="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"/>
              </svg>
            </button>
          </div>
        </div>
      )}
    </>
  );
};

export default Chatbot;
