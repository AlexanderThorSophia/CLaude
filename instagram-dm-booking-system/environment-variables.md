# Environment Variables Reference
## Hollywood Colourblend — Instagram DM Booking System

All variables are set in **n8n → Settings → Environment Variables**
(or use n8n Credentials for API keys where a native credential type exists)

---

## Required Variables

### CLAUDE_API_KEY
**What it is**: Your Anthropic API key to call Claude AI
**Where to get it**:
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Log in or create an account
3. Go to **API Keys → Create Key**
4. Copy the key (starts with `sk-ant-...`)
5. **Billing**: Make sure you have a payment method added and credits available

```
CLAUDE_API_KEY = sk-ant-api03-XXXXXXXXXXXX...
```

---

### CLAUDE_SYSTEM_PROMPT
**What it is**: The full text of the Claude system prompt (the personality and rules for Holly)
**Where to get it**: Copy the entire contents of `claude-system-prompt.txt`

**Important**: Before setting this variable:
1. Replace `[YOUR_SLICK_BOOKING_URL]` with your actual Slick booking page URL
2. Replace `[YOUR_SHOPIFY_STORE_URL]` with your Shopify store URL

```
CLAUDE_SYSTEM_PROMPT = You are the booking assistant for Hollywood Colourblend...
                       (paste full prompt text here)
```

**Tip**: In n8n, environment variable values can be multiline — paste the whole prompt.

---

### SUPABASE_URL
**What it is**: Your Supabase project's REST API URL
**Where to get it**:
1. Go to [supabase.com](https://supabase.com) → Your Project
2. Go to **Settings → API**
3. Copy the **Project URL** (looks like `https://xxxxxxxxxxx.supabase.co`)

```
SUPABASE_URL = https://abcdefghijklm.supabase.co
```

---

### SUPABASE_SERVICE_KEY
**What it is**: The service role API key for Supabase (bypasses Row Level Security — keep this secret)
**Where to get it**:
1. Supabase → **Settings → API**
2. Under **Project API keys**, copy the **service_role** key (NOT the anon key)

```
SUPABASE_SERVICE_KEY = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Security note**: Never expose this key publicly. It has full database access.

---

### MANYCHAT_API_TOKEN
**What it is**: Your ManyChat API token for sending messages and setting custom fields
**Where to get it**:
1. Log in to [ManyChat](https://manychat.com)
2. Go to **Settings → API**
3. Click **New Token** (or copy the existing one)
4. The token starts with a long alphanumeric string

```
MANYCHAT_API_TOKEN = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

### MANYCHAT_HUMAN_TAKEOVER_FIELD_ID
**What it is**: The numeric ID of the `human_takeover` custom field in ManyChat
**Where to get it**:
1. ManyChat → **Settings → Custom Fields**
2. Find `human_takeover` in the list
3. The Field ID is the number shown next to the field name (e.g., `12345`)
4. You can also get it from the ManyChat API: `GET https://api.manychat.com/fb/subscriber/getFields`

```
MANYCHAT_HUMAN_TAKEOVER_FIELD_ID = 12345
```

---

### CATHERINE_EMAIL
**What it is**: Catherine's email address for error alerts and escalation notifications

```
CATHERINE_EMAIL = catherine@hollywoodcolourblend.com
```

---

### ALERT_EMAIL_FROM
**What it is**: The "from" address used when n8n sends emails to Catherine
**Note**: This must match the email address authenticated with your SMTP provider in n8n

```
ALERT_EMAIL_FROM = noreply@hollywoodcolourblend.com
```

---

## n8n Email Credentials (SMTP)

In n8n, you also need to set up an email credential (not an env var, but a Credential):

1. n8n → **Credentials → New Credential**
2. Search for **SMTP** or **Gmail**
3. If using Gmail:
   - Enable 2FA on the Google account
   - Generate an **App Password** (Google Account → Security → App Passwords)
   - Use that as the SMTP password in n8n

**Gmail SMTP settings**:
```
Host:     smtp.gmail.com
Port:     587
Username: your-gmail@gmail.com
Password: xxxx xxxx xxxx xxxx  (App Password)
TLS:      Yes (STARTTLS)
```

---

## Summary Checklist

| Variable | Status |
|---|---|
| `CLAUDE_API_KEY` | ☐ Get from console.anthropic.com |
| `CLAUDE_SYSTEM_PROMPT` | ☐ Copy from claude-system-prompt.txt (fill in URLs first) |
| `SUPABASE_URL` | ☐ Get from Supabase → Settings → API |
| `SUPABASE_SERVICE_KEY` | ☐ Get from Supabase → Settings → API → service_role |
| `MANYCHAT_API_TOKEN` | ☐ Get from ManyChat → Settings → API |
| `MANYCHAT_HUMAN_TAKEOVER_FIELD_ID` | ☐ Get from ManyChat → Settings → Custom Fields |
| `CATHERINE_EMAIL` | ☐ Catherine's email address |
| `ALERT_EMAIL_FROM` | ☐ Sending email address |
| SMTP Credential in n8n | ☐ Configure in n8n Credentials |

## How to Set Variables in n8n

1. Log in to [hollywoodcolourblend.app.n8n.cloud](https://hollywoodcolourblend.app.n8n.cloud)
2. Go to **Settings** (bottom left)
3. Click **Variables** (in n8n Cloud, this may be under **Environment Variables** or **Variables**)
4. Click **Add Variable** for each one
5. Enter the **Key** (exact name above) and **Value**
6. Save

In n8n workflows, reference them as `{{ $env.VARIABLE_NAME }}`
