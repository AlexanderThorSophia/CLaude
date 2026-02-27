# Hollywood Colourblend — Instagram DM Booking System
## Complete Setup Guide

---

## What This Builds

An automated Instagram DM system where an AI assistant called **Holly** handles enquiries, qualifies leads, answers pricing questions using your real service menu, and guides clients to book via Slick — all without Catherine lifting a finger unless it's genuinely needed.

**Stack**: ManyChat → n8n → Claude AI → Supabase → ManyChat API → Instagram DM

---

## Architecture Overview

```
Instagram DM arrives
        │
        ▼
   ManyChat (receives DM, fires webhook)
        │
        ▼
   n8n Webhook (receives payload from ManyChat)
        │
        ├─── Respond 200 OK to ManyChat immediately
        │
        ├─── IF human_takeover = true → STOP (Catherine is handling this)
        │
        ▼
   Supabase (fetch conversation history for this contact)
        │
        ▼
   Build Claude API request (history + new message + system prompt)
        │
        ▼
   Claude AI (claude-sonnet-4-6) — generates Holly's response
        │
        ▼
   Process response (detect [HUMAN_NEEDED] flag, strip it)
        │
        ▼
   Supabase (save updated conversation history)
        │
        ├─── IF [HUMAN_NEEDED] detected:
        │         ├── Send escalation reply via ManyChat API
        │         ├── Set human_takeover = true in ManyChat
        │         └── Email Catherine
        │
        └─── ELSE: Send normal AI reply via ManyChat API
```

---

## File Reference

| File | Purpose |
|---|---|
| `n8n-workflow-main.json` | Import into n8n — the main DM handling workflow |
| `n8n-workflow-error.json` | Import into n8n — emails Catherine when the bot errors |
| `claude-system-prompt.txt` | Copy into `CLAUDE_SYSTEM_PROMPT` env var (fill in URLs first) |
| `manychat-setup.md` | Step-by-step ManyChat configuration guide |
| `environment-variables.md` | Every credential you need and where to find it |
| `supabase-setup.sql` | Run in Supabase SQL Editor to create the database |

---

## Setup Order

Follow this exact order to avoid configuration gaps:

```
1. Supabase     →  Create database table
2. Anthropic    →  Get Claude API key
3. ManyChat     →  Create custom field, get API token + field ID
4. n8n          →  Set environment variables
5. n8n          →  Import error workflow first (get its ID)
6. n8n          →  Import main workflow, set error workflow ID
7. n8n          →  Set up SMTP email credential
8. ManyChat     →  Create flows and point them at n8n webhook URL
9. Test         →  Follow the QA checklist below
10. Go live     →  Activate both n8n workflows
```

---

## PHASE 1: Supabase Setup

### 1.1 Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Name: `hollywood-colourblend`
3. Choose a strong database password (save it somewhere secure)
4. Region: **Europe West** (for UK performance)
5. Wait for the project to spin up (~2 minutes)

### 1.2 Run the Database Setup SQL

1. In your Supabase project, go to **SQL Editor → New Query**
2. Paste the entire contents of `supabase-setup.sql`
3. Click **Run**
4. You should see: `Success. No rows returned`

### 1.3 Get Your Supabase Credentials

From **Settings → API**:
- Copy **Project URL** → this becomes `SUPABASE_URL`
- Copy **service_role** key → this becomes `SUPABASE_SERVICE_KEY`

---

## PHASE 2: Get Your API Keys

### 2.1 Anthropic (Claude)
1. [console.anthropic.com](https://console.anthropic.com) → API Keys → Create Key
2. Add billing/credits (pay-as-you-go; expect ~£0.003–£0.01 per conversation turn)
3. This becomes `CLAUDE_API_KEY`

### 2.2 ManyChat
1. ManyChat → Settings → API → Copy token
2. This becomes `MANYCHAT_API_TOKEN`
3. Also note the Field ID for `human_takeover` (Settings → Custom Fields)

---

## PHASE 3: n8n Configuration

### 3.1 Set Environment Variables

In [hollywoodcolourblend.app.n8n.cloud](https://hollywoodcolourblend.app.n8n.cloud):
1. Go to **Settings → Variables** (left sidebar)
2. Add each variable from `environment-variables.md`

**Critical**: For `CLAUDE_SYSTEM_PROMPT`, paste the full content of `claude-system-prompt.txt` — but first:
- Replace `[YOUR_SLICK_BOOKING_URL]` with your Slick booking page URL
- Replace `[YOUR_SHOPIFY_STORE_URL]` with your Shopify store URL

### 3.2 Set Up Email Credential

1. n8n → **Credentials → New**
2. Search **SMTP** or **Gmail**
3. Configure with your sending email (see `environment-variables.md` for Gmail settings)
4. Test the credential

### 3.3 Import the Error Workflow

1. n8n → **Workflows → Import from File**
2. Select `n8n-workflow-error.json`
3. After import, open the workflow and **note its ID** (visible in the URL: `...workflow/12345`)
4. Set up the SMTP credential on the email node inside this workflow
5. **Activate** this workflow (toggle ON)

### 3.4 Import the Main Workflow

1. n8n → **Workflows → Import from File**
2. Select `n8n-workflow-main.json`
3. Open the workflow
4. Go to **workflow settings** (gear icon, top right) → **Error Workflow**
5. Select the error workflow you just imported
6. Set up credentials on the email node (Alert Catherine – Human Needed)
7. **Do not activate yet** — configure ManyChat first

### 3.5 Get Your Webhook URL

1. Open the main workflow
2. Click the **Instagram DM Webhook** node
3. The webhook URL is shown — copy it
4. It will look like: `https://hollywoodcolourblend.app.n8n.cloud/webhook/instagram-dm`

---

## PHASE 4: ManyChat Setup

Follow `manychat-setup.md` in full. Key steps:

1. Connect Instagram account
2. Create `human_takeover` custom Boolean field
3. Create the **AI Booking Assistant – DM Handler** flow (Default Reply trigger → External Request to your n8n webhook URL)
4. Create keyword flows for BOOK, INFO, PRICE
5. Verify Catherine knows how to use Live Chat and reset `human_takeover`

---

## PHASE 5: QA Testing Checklist

Complete all tests **before** activating the main n8n workflow for real users.

### Test 1: Webhook Connection
- [ ] n8n webhook node is in "Listen for test event" mode
- [ ] Send a test DM from a test Instagram account (or manually trigger via ManyChat)
- [ ] n8n receives the payload and shows green ✓ on all nodes
- [ ] A reply arrives back in Instagram DM within 15 seconds

### Test 2: Conversation Memory
- [ ] Send 3 follow-up messages in the same DM thread
- [ ] Verify Claude remembers context from earlier messages (e.g. ask "what service did I say?" and it should know)
- [ ] Open Supabase → Table Editor → conversations: confirm a row exists with growing messages array

### Test 3: Pricing Questions
- [ ] Ask "how much is a balayage?" → Holly should say "from £225" (not "I don't know" or a made-up price)
- [ ] Ask "how much exactly?" → Holly should stay in "starting from" territory and not commit to a price
- [ ] Ask about Cut & Blowdry → Should say "from £100"
- [ ] Ask about extensions → Should say "price on consultation" and suggest a free consultation

### Test 4: Booking Flow
- [ ] Express interest in booking → Holly should ask qualifying questions naturally
- [ ] After qualifying, Holly should offer the Slick booking link
- [ ] Verify the Slick URL in the response is correct and clickable

### Test 5: Escalation — Human Needed
- [ ] Send "I want to speak to Catherine" → Holly responds warmly, Catherine gets an email
- [ ] In ManyChat, verify `human_takeover` is now set to `true` for that contact
- [ ] Send another message from that contact → n8n should detect `human_takeover = true` and send NOTHING
- [ ] Catherine resets `human_takeover` to `false` → send another message → bot should respond again

### Test 6: Complaint Escalation
- [ ] Send "I had a terrible experience last time" → Holly should respond empathetically and trigger escalation
- [ ] Catherine receives the email alert
- [ ] `human_takeover` set to true ✓

### Test 7: Comment → DM Flow (Flow 2)
- [ ] Comment "BOOK" on a test post
- [ ] ManyChat sends an automated DM response ✓
- [ ] Follow-up messages hand off to the AI correctly

### Test 8: Error Handling
- [ ] Temporarily set an invalid `CLAUDE_API_KEY` in n8n
- [ ] Trigger a test DM
- [ ] Catherine receives an error email with details ✓
- [ ] Restore the correct API key

### Test 9: Edge Cases
- [ ] Send an emoji-only message (🌸) → Holly should handle gracefully
- [ ] Send a very long message (200+ words) → should not crash
- [ ] Send a message in another language → Holly responds in English (or matches the language — check the prompt handles this)

---

## PHASE 6: Go Live

1. n8n → Main workflow → **Activate** (toggle ON)
2. ManyChat → AI Booking Assistant flow → **Publish**
3. Test one final end-to-end real DM
4. Monitor n8n executions for the first 24 hours (n8n → Executions)

---

## Daily Operations for Catherine

### When you receive an escalation email:
1. Open **ManyChat → Live Chat**
2. Find the contact and respond personally
3. When finished, open the contact profile → set `human_takeover` to **False**
4. The bot will resume handling their next message automatically

### Monitoring the bot:
- n8n → **Executions** tab shows every conversation handled (green = success, red = error)
- Supabase → **conversations** table shows all message history
- ManyChat → **Analytics** shows DM open rates and engagement

### Updating Holly's personality or prices:
- Edit the `CLAUDE_SYSTEM_PROMPT` environment variable in n8n
- Changes take effect on the next message (no restart needed)

### Turning off the bot entirely:
- n8n → Main workflow → Toggle **OFF**
- The bot will stop responding; ManyChat's default replies will handle any incoming DMs

---

## Cost Estimates

| Service | Expected cost |
|---|---|
| Claude API (claude-sonnet-4-6) | ~£0.003–£0.01 per message exchange |
| At 100 DM conversations/month (avg 5 turns each) | ~£1.50–£5.00/month |
| Supabase | Free tier (up to 500MB database, 2GB bandwidth) |
| n8n Cloud | Already running (your existing subscription) |
| ManyChat Pro | Already subscribed |

**Total new cost to run: approximately £5–15/month** depending on DM volume.

---

## Troubleshooting

### Bot not responding to DMs
1. Check n8n main workflow is **Active** (green toggle)
2. Check ManyChat flow is **Published**
3. Check n8n Executions — is the webhook being received?
4. Check environment variables are all set correctly

### Bot responds but then stops mid-conversation
1. Check `human_takeover` field isn't accidentally set to `true`
2. Check Supabase is reachable (n8n → test the Supabase HTTP request manually)

### Holly gives wrong prices
1. Check `CLAUDE_SYSTEM_PROMPT` env var contains the full prompt with the price list
2. Test by triggering a manual execution in n8n and viewing the Claude API request

### Error emails keep coming
1. n8n → Executions → click the failed one to see exactly which node failed and why
2. Most common causes: expired API key, Supabase credentials changed, ManyChat API token rotated

### ManyChat sends duplicate responses
1. Check you don't have multiple flows all triggering on the same DM
2. Only the **Default Reply** flow should trigger the n8n webhook
3. Keyword flows should only fire on comment keywords, not every DM
