# Fusion Broth Co. — Launch Checklist

Everything you need to go live, in order.

---

## Step 1 — Add your product images

Place your jar photos in the `images/` folder, then edit `index.html`.

Find the four `product-img-placeholder` divs and replace each one with an `<img>` tag:

```html
<!-- BEFORE (placeholder) -->
<div class="product-img-placeholder">...</div>

<!-- AFTER (real image) -->
<img class="product-img" src="images/leek-potato.jpg" alt="Leek & Potato" />
```

Recommended image specs: **portrait crop, at least 600 × 800 px, JPG or WebP**.

---

## Step 2 — Set up Google Sheets + Apps Script

This gives you a live spreadsheet that fills up every time someone joins the waitlist.

### 2a. Create the Google Sheet

1. Go to [sheets.google.com](https://sheets.google.com) and create a new spreadsheet.
2. Name it something like **Fusion Broth Waitlist**.
3. Keep this tab open — you'll come back to it.

### 2b. Open Apps Script

1. In your new sheet, click **Extensions → Apps Script**.
2. Delete all the default code in the editor.
3. Open `google-apps-script.gs` from this folder and paste the entire contents in.
4. Click **Save** (the floppy-disk icon or Ctrl+S).

### 2c. Deploy as a Web App

1. Click **Deploy → New deployment**.
2. Click the gear icon next to **Type** and select **Web app**.
3. Set the fields:
   - **Description**: Fusion Broth Waitlist
   - **Execute as**: Me
   - **Who has access**: Anyone
4. Click **Deploy**.
5. Google will ask you to **authorise** the script — click through and allow it.
6. Copy the **Web app URL** that appears (it looks like `https://script.google.com/macros/s/XXXX.../exec`).

### 2d. Paste the URL into `index.html`

Open `index.html` and find this line near the bottom:

```js
const GOOGLE_SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE';
```

Replace `YOUR_GOOGLE_APPS_SCRIPT_URL_HERE` with the URL you just copied.

---

## Step 3 — Host the website (free, no domain needed)

Choose one of the options below. Both are completely free and give you a shareable link straight away.

---

### Option A — Netlify Drop (recommended, takes 30 seconds)

1. Go to [app.netlify.com/drop](https://app.netlify.com/drop).
2. Drag your entire `broth-soup-landing` folder onto the page.
3. Netlify instantly gives you a URL like `https://fuzzy-name-123.netlify.app`.
4. You can rename it to something like `fusion-broth-co.netlify.app` in **Site settings → Change site name**.

**To update the site later:** just drag the folder again to the same page.

---

### Option B — GitHub Pages (slightly more steps, free forever)

1. Create a free account at [github.com](https://github.com) if you don't have one.
2. Create a new public repository called `fusion-broth-co`.
3. Upload all the files from this folder.
4. Go to **Settings → Pages → Source → Deploy from branch → main / root**.
5. Your site will be live at `https://yourusername.github.io/fusion-broth-co`.

---

## Step 4 — Test the full flow

1. Open your live URL.
2. Fill in the form and submit.
3. Check your Google Sheet — a new row should appear within a few seconds.

---

## Optional: connect a real domain later

Both Netlify and GitHub Pages let you add a custom domain (e.g. `fusionbrothco.com`) in their settings for free — just point your domain's DNS records as instructed. You can do this at any time without changing anything in the code.

---

## File structure

```
broth-soup-landing/
├── index.html              ← The full one-page website
├── google-apps-script.gs   ← Paste into Google Apps Script
├── SETUP.md                ← This file
└── images/                 ← Drop your product photos here
    ├── leek-potato.jpg
    ├── moroccan-tagine.jpg
    ├── caribbean-chicken.jpg
    └── thai-beef.jpg
```
