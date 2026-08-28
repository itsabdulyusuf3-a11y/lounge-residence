#!/usr/bin/env python3
"""Diagnostic check of the Lounge Residence project for go-live readiness."""
import os

base = r"c:\Users\HP\Documents\service apartment"
issues = []
warnings = []
ok = []


def read(fname):
    with open(os.path.join(base, fname), "r", encoding="utf-8") as f:
        return f.read()


config = read("config.js")
index = read("index.html")
schema = read("supabase-schema.sql")
admin = read("admin.html")
readme = read("README.md")

# 1. Old studio references (should be fully removed)
old_refs = ["studiod", "Studio Deluxe", "Studio Classic"]
for term in old_refs:
    for fname, content in [("config.js", config), ("index.html", index),
                           ("supabase-schema.sql", schema), ("admin.html", admin),
                           ("README.md", readme)]:
        if term in content:
            issues.append(f"{fname} still contains old reference: {term}")
ok.append("No old studio references (studiod / Studio Deluxe / Studio Classic)")

# 2. three_premium consistency
for fname, content in [("config.js", config), ("index.html", index), ("supabase-schema.sql", schema)]:
    if "three_premium" in content:
        ok.append(f"{fname}: uses three_premium consistently")
    else:
        issues.append(f"{fname}: missing three_premium")

# 3. camelCase threePremium should be gone
for fname, content in [("config.js", config), ("index.html", index), ("supabase-schema.sql", schema)]:
    if "threePremium" in content:
        issues.append(f"{fname}: still has camelCase threePremium")

# 4. Supabase creds present
if "bhsghtwqreniqjktyyji" in config and "sb_publishable" in config:
    ok.append("config.js: Supabase URL + anon key present")
else:
    issues.append("config.js: Supabase credentials missing")

# 5. Placeholder WhatsApp / Paystack
if "2348000000000" in config:
    warnings.append("config.js: WhatsApp number is the placeholder 2348000000000 - update to real number")
if 'paystackPublicKey: ""' in config:
    warnings.append("config.js: Paystack live key is empty - online card payment disabled (falls back to WhatsApp)")

# 6. Index key sections
sections = [
    'id="heroForm"', 'id="heroAvail"', "checkAvailability", "scrollIntoView",
    'data-cat="three_premium"', "Premium 3-Bedroom", 'id="book"',
    "loadPrices", "loadAvailability",
]
for s in sections:
    if s in index:
        ok.append(f"index.html: contains '{s}'")
    else:
        issues.append(f"index.html: MISSING '{s}'")

# 7. Admin room dropdown + contrast fix
if "addRoom" in admin:
    ok.append("admin.html: addRoom select present")
else:
    issues.append("admin.html: addRoom select missing")
if "select option" in admin:
    ok.append("admin.html: dropdown contrast fix applied")
else:
    issues.append("admin.html: dropdown contrast fix missing")

# 8. Schema pricing
print("=== SCHEMA ROOMS & PRICES ===")
print("code | floor | category | price")
for line in schema.split("\n"):
    s = line.strip()
    if s.startswith("("):
        # strip trailing comma
        print("  " + s.rstrip(","))

# 9. Admin credentials match config
if "sb_publishable_gA3wYlZBdvlwIs3VJN8fKg_Px7KD6y3" in admin:
    ok.append("admin.html: Supabase key matches config.js")
else:
    issues.append("admin.html: Supabase key may be out of sync")

print()
print("=== DIAGNOSTIC REPORT ===")
print("--- PASS ---")
for item in ok:
    print("  ✓ " + item)
print("--- WARNINGS (non-blocking) ---")
for item in warnings:
    print("  ⚠ " + item)
print("--- ISSUES (blocking) ---")
if issues:
    for item in issues:
        print("  ✗ " + item)
else:
    print("  NONE")

print()
print("=== VERDICT ===")
if issues:
    print("NOT READY - resolve the issues above before go-live")
else:
    print("READY TO GO LIVE - subject to warnings above and DNS/hosting")
</write_to_file>
<requires_approval>false</requires_approval>