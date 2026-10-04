// ============================================
// THE LOUNGE RESIDENCE - SUPABASE CONFIG
// Shared configuration for both the public site and admin panel
// ============================================

const SUPABASE_CONFIG = {
  url: "https://bhsghtwqreniqjktyyji.supabase.co",
  anonKey: "sb_publishable_gA3wYlZBdvlwIs3VJN8fKg_Px7KD6y3",
  
  // WhatsApp number for booking notifications (international format, no +)
  whatsapp: "2347078646704",
  
  // Apartment rates (NGN per night)
  // Note: LR 07 is the 3 Bedroom Luxury Apartment (300,000/night); the other
  // 3-bedroom residences use the Executive rate of 250,000/night.
  rates: {
    three:        { label: "3 Bedroom Executive Apartment",        price: 250000 },
    three_premium:{ label: "3 Bedroom Luxury Apartment",           price: 300000 },
    two:          { label: "2 Bedroom Business Apartment",         price: 200000 },
    one:          { label: "1 Bedroom Luxury Apartment",           price: 180000 },
    studio:       { label: "1 Bedroom Exclusive Studio Apartment", price: 150000 }
  }
};

// Currency formatter
const fmtNgn = n => new Intl.NumberFormat("en-NG", { style: "currency", currency: "NGN", maximumFractionDigits: 0 }).format(n);
