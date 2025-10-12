# PAN Number Validation using SQL

## 📌 Objective
Clean and validate a dataset containing Indian PAN (Permanent Account Number) values, and categorize them as **Valid** or **Invalid** based on official rules.

---

## ✅ Dataset
**Table:** `stg_pan_numbers_dataset`  
**Column:** `pan_number (text)`

---

## ✅ Conditions to Validate PAN Numbers

### 1️⃣ Data Quality Checks
- PAN should **not be NULL**
- PAN should **not be empty ('')**
- Remove **leading/trailing spaces**
- Convert all PANs to **UPPERCASE**
- Remove **duplicates**

---

### 2️⃣ Format Rules (Official PAN Format: `AAAAA9999A`)

| Position | Characters | Rule |
|----------|------------|-----|
| 1–5 | Letters | Must be A–Z |
| 6–9 | Digits | Must be 0–9 |
| 10 | Letter | Must be A–Z |
| Length | 10 | Exactly 10 characters |

✅ Implemented using **Regular Expression**:  
`^[A-Z]{5}[0-9]{4}[A-Z]$`

---

### 3️⃣ Business Rules

#### ✅ Alphabets (first 5 characters):
- ❌ Adjacent letters **cannot be the same** (e.g., **AABCD** is invalid)
- ❌ All five letters **cannot form a sequence** (e.g., **ABCDE**, **BCDEF** are invalid)

#### ✅ Digits (next 4 characters):
- ❌ Adjacent digits **cannot be the same** (e.g., **1123** is invalid)
- ❌ All four digits **cannot form a sequence** (e.g., **1234**, **2345** are invalid)

---

## ✅ How the Validation Was Implemented (Logic Summary)

1. **Clean the data**
   - Remove NULL and empty values  
   - Trim spaces  
   - Convert to uppercase  
   - De-duplicate  

2. **Apply format validation**
   - Ensure exact 10 characters  
   - Match pattern using regex  

3. **Apply business rules**
   - Custom logic to detect adjacent repeated characters  
   - Custom logic to detect sequential characters  

4. **Categorize each PAN**
   - If all rules are satisfied → ✅ Valid PAN  
   - Otherwise → ❌ Invalid PAN  

5. **Generate summary report**
   - Total processed PANs  
   - Total valid PANs  
   - Total invalid PANs  
   - Total missing/incomplete PANs  

---

✅ Final result provides **cleaned data**, **validation status**, and a **summary of data quality**.
