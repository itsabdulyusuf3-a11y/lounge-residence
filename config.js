// ============================================
// THE LOUNGE RESIDENCE - SUPABASE CONFIG
// Shared configuration for both the public site and admin panel
// ============================================

const SUPABASE_CONFIG = {
  url: "https://bhsghtwqreniqjktyyji.supabase.co",
  anonKey: "sb_publishable_gA3wYlZBdvlwIs3VJN8fKg_Px7KD6y3",
  
  // WhatsApp number for booking notifications (international format, no +)
  whatsapp: "2348000000000",
  
  // Room rates (NGN per night)
  // Note: LR 07 is the premium 3-bedroom (300,000/night); all other
  // 3-bedroom residences use the category base rate of 250,000/night.
  rates: {
    three:    { label: "Three-Bedroom Residence", price: 250000 },
    three_premium:{ label: "Premium 3-Bedroom (LR 07)", price: 300000 },
    two:      { label: "Two-Bedroom Residence",     price: 200000 },
    one:      { label: "One-Bedroom Residence",     price: 180000 },
    studio:   { label: "Studio",                    price: 150000 },
    lounge:   { label: "The Lounge (Event Space)",  price: 250000 }
  }
};

// Currency formatter
const fmtNgn = n => new Intl.NumberFormat("en-NG", { style: "currency", currency: "NGN", maximumFractionDigits: 0 }).format(n);
