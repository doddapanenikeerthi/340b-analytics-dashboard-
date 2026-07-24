import csv
import random
from datetime import datetime, timedelta

random.seed(42)

# --- Covered Entities ---
entity_types = ["Hospital - DSH", "Hospital - CAH", "FQHC", "Ryan White Clinic", "Hospital - PED"]
entities = []
for i in range(1, 13):
    entities.append({
        "entity_id": f"CE{i:03d}",
        "entity_name": f"{'Metro' if i%3==0 else 'St. Vincent' if i%3==1 else 'Lakeside'} Health {'Hospital' if i%2==0 else 'Clinic'} {i}",
        "entity_type": random.choice(entity_types),
        "state": random.choice(["OH","WI","IL","MI","IN"])
    })
with open("data/covered_entities.csv","w",newline="") as f:
    w = csv.DictWriter(f, fieldnames=entities[0].keys())
    w.writeheader()
    w.writerows(entities)

# --- Drugs / NDC reference ---
drugs = [
    {"ndc": "00069-0150-01", "drug_name": "Atorvastatin 20mg", "wac_price": 145.00, "price_340b": 58.00},
    {"ndc": "00093-7146-01", "drug_name": "Lisinopril 10mg", "wac_price": 32.00, "price_340b": 12.50},
    {"ndc": "50242-0079-01", "drug_name": "Trastuzumab (Herceptin)", "wac_price": 3200.00, "price_340b": 1900.00},
    {"ndc": "00003-0894-11", "drug_name": "Apixaban (Eliquis) 5mg", "wac_price": 520.00, "price_340b": 310.00},
    {"ndc": "00074-3799-13", "drug_name": "Adalimumab (Humira)", "wac_price": 6800.00, "price_340b": 4100.00},
    {"ndc": "00006-0749-31", "drug_name": "Sitagliptin (Januvia) 100mg", "wac_price": 610.00, "price_340b": 380.00},
    {"ndc": "00078-0648-15", "drug_name": "Fingolimod (Gilenya)", "wac_price": 8200.00, "price_340b": 5300.00},
    {"ndc": "00002-1433-80", "drug_name": "Insulin Glargine (Lantus)", "wac_price": 290.00, "price_340b": 140.00},
]
with open("data/drug_reference.csv","w",newline="") as f:
    w = csv.DictWriter(f, fieldnames=drugs[0].keys())
    w.writeheader()
    w.writerows(drugs)

# --- Claims ---
tpa_names = ["Verity Solutions", "Sentry Data Systems", "Macro Helix", "Kalderos"]
encounter_types = ["Outpatient", "Emergency", "Clinic Visit", "Infusion"]

claims = []
start_date = datetime(2025,1,1)
for i in range(1, 2001):
    entity = random.choice(entities)
    drug = random.choice(drugs)
    fill_date = start_date + timedelta(days=random.randint(0,545))
    # 88% eligible, 12% ineligible (for compliance-risk analysis)
    eligible = random.random() < 0.88
    claims.append({
        "claim_id": f"CLM{i:06d}",
        "entity_id": entity["entity_id"],
        "ndc": drug["ndc"],
        "fill_date": fill_date.strftime("%Y-%m-%d"),
        "encounter_type": random.choice(encounter_types),
        "eligible_340b": "Y" if eligible else "N",
        "billed_price": drug["price_340b"] if eligible else drug["wac_price"],
        "qty": random.choice([30,60,90,1])
    })
with open("data/claims.csv","w",newline="") as f:
    w = csv.DictWriter(f, fieldnames=claims[0].keys())
    w.writeheader()
    w.writerows(claims)

# --- Replenishment Orders ---
orders = []
for i in range(1, 601):
    drug = random.choice(drugs)
    entity = random.choice(entities)
    order_date = start_date + timedelta(days=random.randint(0,545))
    # replenishment usually lags claim fill by a few days to a couple weeks
    lag_days = random.choice([1,2,3,5,7,10,14,21,30])
    orders.append({
        "order_id": f"ORD{i:05d}",
        "entity_id": entity["entity_id"],
        "ndc": drug["ndc"],
        "order_date": order_date.strftime("%Y-%m-%d"),
        "qty_ordered": random.choice([30,60,90,120]),
        "unit_price_340b": drug["price_340b"],
        "lag_days_from_trigger_claim": lag_days
    })
with open("data/replenishment_orders.csv","w",newline="") as f:
    w = csv.DictWriter(f, fieldnames=orders[0].keys())
    w.writeheader()
    w.writerows(orders)

# --- Split Billing / TPA match flags ---
split_flags = []
for c in claims:
    if random.random() < 0.35:  # only a subset routed through split-billing TPA
        match_status = random.choices(
            ["Matched","Unmatched - Review","Duplicate Discount Risk"],
            weights=[0.85,0.10,0.05]
        )[0]
        split_flags.append({
            "claim_id": c["claim_id"],
            "tpa_name": random.choice(tpa_names),
            "match_status": match_status
        })
with open("data/split_billing_flags.csv","w",newline="") as f:
    w = csv.DictWriter(f, fieldnames=["claim_id","tpa_name","match_status"])
    w.writeheader()
    w.writerows(split_flags)

print(f"Entities: {len(entities)}")
print(f"Drugs: {len(drugs)}")
print(f"Claims: {len(claims)}")
print(f"Orders: {len(orders)}")
print(f"Split billing flags: {len(split_flags)}")
