// ============================================
// THE LOUNGE RESIDENCE - SUPABASE CONFIG
// Shared configuration for both the public site and admin panel
// ============================================

const SUPABASE_CONFIG = {
  url: "https://bhsghtwqreniqjktyyji.supabase.co",
  anonKey: "sb_publishable_gA3wYlZBdvlwIs3VJN8fKg_Px7KD6y3",
  
  // WhatsApp number for booking notifications (international format, no +)
  whatsapp: "2348000000000",
  
  // Paystack public key (leave empty until you have a live key)
  paystackPublicKey: "",

  // Room rates (NGN per night)
  rates: {
    three:    { label: "Three-Bedroom Residence", price: 250000 },
    two:      { label: "Two-Bedroom Residence",     price: 200000 },
    one:      { label: "One-Bedroom Residence",     price: 180000 },
    studiod:  { label: "Studio Deluxe (SD1-SD2)",   price: 150000 },
    studio:   { label: "Studio Classic (S1-S3)",    price: 120000 },
    lounge:   { label: "The Lounge (Event Space)",  price: 250000 }
  }
};

// Currency formatter
const fmtNgn = n => new Intl.NumberFormat("en-NG", { style: "currency", currency: "NGN", maximumFractionDigits: 0 }).format(n);