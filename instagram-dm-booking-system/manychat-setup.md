# ManyChat Setup Guide
## Hollywood Colourblend — Instagram DM Booking System

---

## Prerequisites
- ManyChat Pro plan ✓ (confirmed)
- Instagram account connected to ManyChat
- Your n8n webhook URL ready (you get this after importing the n8n workflow)

---

## STEP 1: Connect Your Instagram Account

1. Log in to [ManyChat](https://manychat.com)
2. Go to **Settings → Channels → Instagram**
3. Click **Connect Instagram Account**
4. Authorise with the Hollywood Colourblend Instagram account
5. Make sure your Instagram is set to a **Professional/Business account** (required)

---

## STEP 2: Create the `human_takeover` Custom Field

This field is the on/off switch that controls whether the bot responds or stays silent.

1. Go to **Settings → Custom Fields**
2. Click **+ New Field**
3. Configure:
   - **Name**: `human_takeover`
   - **Type**: Boolean (True/False)
   - **Default value**: False
4. **Note down the Field ID** (shown next to the field name — you'll need it for the environment variables)

---

## STEP 3: Create Flow 1 — The DM Webhook Handler

This is the main flow. It fires every time someone sends a DM that isn't handled by another flow.

### 3a. Create the Flow

1. Go to **Flows → New Flow**
2. Name it: `AI Booking Assistant – DM Handler`
3. Set the trigger: **Default Reply** (this fires on any DM not matched by other flows)

### 3b. Add an External Request Action

Inside the flow, add an **Action → External Request (Webhook)**:

**Configuration:**
```
Method:  POST
URL:     https://hollywoodcolourblend.app.n8n.cloud/webhook/instagram-dm
         (replace with your actual n8n webhook URL after importing the workflow)

Headers:
  Content-Type: application/json

Body (Raw JSON):
{
  "contact_id":      "{{id}}",
  "first_name":      "{{first name}}",
  "last_name":       "{{last name}}",
  "message":         "{{last input text}}",
  "human_takeover":  "{{human_takeover}}"
}
```

**Response Timeout**: Set to 30 seconds

**On Success**: Continue flow (the AI response will arrive via the ManyChat API — no further steps needed in this flow)

**On Error**: Add a fallback message:
```
"Thanks for your message! We'll get back to you very shortly. 💫"
```

### 3c. After the External Request — No AI Reply Needed Here

Since n8n calls the ManyChat API directly to send the response, **this flow does not need to send any message after the webhook**. The fallback message above only shows if the webhook itself fails.

---

## STEP 4: Create Flow 2 — Comment Keyword Triggers

These flows detect comments on posts and open a DM conversation.

### Keyword: INFO

1. Go to **Flows → New Flow**
2. Name: `Comment Trigger – INFO`
3. Trigger: **Instagram → Comment Contains Keyword**
4. Keywords: `INFO`, `info`, `Info`
5. **Action 1 – Comment Reply**: Post a public reply to their comment:
   ```
   Hey! 👋 Just sent you a DM with all the info you need!
   ```
6. **Action 2 – Send DM**: Send them a direct message:
   ```
   Hi {{first name}}! 👋 Thanks for your interest in Hollywood Colourblend!

   I'm Holly, our booking assistant. I'd love to help you find the perfect service. What are you looking to have done? ✨
   ```
7. After this DM, **tag the contact** with a tag called `from_comment` (optional, useful for tracking)
8. **Trigger the AI flow**: After the opening message, set a **Send to Flow** action pointing to your `AI Booking Assistant – DM Handler` flow — OR simply let the Default Reply flow handle any follow-up messages naturally

### Keyword: BOOK

Repeat the same setup as INFO with trigger words: `BOOK`, `book`, `Book`, `BOOKING`, `booking`

Opening DM:
```
Hi {{first name}}! 💫 I saw you're interested in booking — brilliant taste!

I'm Holly, our booking assistant. Let's get you sorted. What service are you thinking about?
```

### Keyword: PRICE / PRICES

Repeat with trigger words: `PRICE`, `price`, `PRICES`, `prices`, `how much`, `HOW MUCH`

Opening DM:
```
Hi {{first name}}! Great question!

I'm Holly, Hollywood Colourblend's booking assistant. Our colour services start from £85, with our signature Hollywood Colour Blend services from £225.

Can I ask what you're thinking of having done? I can give you a much better starting-from figure once I know a bit more! ✨
```

---

## STEP 5: Create Flow 3 — Human Takeover (Catherine Takes Control)

### The Live Chat Takeover Button

ManyChat handles human takeover via its **Live Chat** feature natively. Here's how to set it up properly for Catherine:

#### 5a. Enable Live Chat

1. Go to **Settings → Live Chat**
2. Enable Instagram Live Chat
3. Add Catherine as an agent (and any team members who handle DMs)

#### 5b. Create a Pause Bot Button in Live Chat

When Catherine opens a conversation in ManyChat's Live Chat, she sees a button to **Pause Bot**. This is built into ManyChat Pro. Make sure she knows:

- The bot is automatically paused when she takes over in Live Chat
- BUT the `human_takeover` custom field needs to be set to `true` to prevent n8n from sending any AI replies

#### 5c. Create the "Set Takeover Field" Flow

Create a flow that runs when Catherine wants to manually flag a conversation:

1. **Flows → New Flow**
2. Name: `Admin – Set Human Takeover`
3. Trigger: **Keyword (from Catherine's device)** — e.g., someone types `TAKEOVER` or you use a button
4. **Action**: Set custom field `human_takeover` = **True**
5. **Message**: (Visible only in internal notes): Bot paused for this contact.

Alternatively, Catherine can set the custom field manually from the contact's profile in ManyChat.

#### 5d. How Catherine Reactivates the Bot

**After Catherine has finished handling a conversation:**

1. Open ManyChat Live Chat
2. Find the contact's conversation
3. Click the contact name to open their **Contact Profile**
4. Scroll to **Custom Fields**
5. Find `human_takeover` and set it to **False**
6. The bot will now respond to this person's next message

**Or — Create a Reactivation Flow:**

1. New Flow → Name: `Admin – Reactivate Bot`
2. Add Action: Set `human_takeover` = **False**
3. Add Message: "Bot reactivated for this contact ✅"
4. Trigger: Admin keyword like `REACTIVATE` or use a button in Live Chat

---

## STEP 6: ManyChat Flow JSON (Key Configuration Reference)

Below is the configuration structure for the main DM Handler flow. ManyChat's import format is version-specific, but this documents exactly what to configure:

```json
{
  "flow_name": "AI Booking Assistant – DM Handler",
  "trigger": {
    "type": "default_reply",
    "channel": "instagram"
  },
  "steps": [
    {
      "type": "external_request",
      "config": {
        "method": "POST",
        "url": "YOUR_N8N_WEBHOOK_URL/webhook/instagram-dm",
        "headers": {
          "Content-Type": "application/json"
        },
        "body": {
          "contact_id":     "{{id}}",
          "first_name":     "{{first name}}",
          "last_name":      "{{last name}}",
          "message":        "{{last input text}}",
          "human_takeover": "{{human_takeover}}"
        },
        "timeout_seconds": 30,
        "on_error": {
          "action": "send_message",
          "message": "Thanks for your message! We'll get back to you very shortly. 💫"
        }
      }
    }
  ]
}
```

```json
{
  "flow_name": "Comment Trigger – BOOK",
  "trigger": {
    "type": "instagram_comment_keyword",
    "keywords": ["BOOK", "book", "BOOKING", "booking"]
  },
  "steps": [
    {
      "type": "comment_reply",
      "message": "Hey! 👋 Just sent you a DM — let's get you booked in!"
    },
    {
      "type": "send_dm",
      "message": "Hi {{first name}}! 💫 I saw you're interested in booking — brilliant taste!\n\nI'm Holly, our booking assistant. What service are you thinking about?"
    }
  ]
}
```

---

## STEP 7: Finding Your n8n Webhook URL

After you import the n8n main workflow:

1. Open **n8n → Your Workflow → Instagram DM Webhook** node
2. Click the node to open it
3. You'll see a **Webhook URL** — it looks like:
   `https://hollywoodcolourblend.app.n8n.cloud/webhook/instagram-dm`
4. Copy this URL and paste it into your ManyChat External Request step

**Note**: The URL will only work after you **Activate** the workflow in n8n (toggle at the top right of the workflow editor).

---

## STEP 8: Testing the Connection

Before going live, test the webhook manually:

1. In n8n, open the **Instagram DM Webhook** node
2. Click **Listen For Test Event**
3. Go to ManyChat and manually trigger the DM Handler flow on a test contact
4. Check n8n — you should see the webhook fire with the test data
5. Verify the response comes back in ManyChat within ~10 seconds

---

## Quick Reference: ManyChat Variables

| Variable | What it contains |
|---|---|
| `{{id}}` | ManyChat subscriber ID (use as contact_id) |
| `{{first name}}` | Contact's first name |
| `{{last name}}` | Contact's last name |
| `{{last input text}}` | The message they just sent |
| `{{human_takeover}}` | Value of your custom boolean field |
| `{{messenger user id}}` | Instagram user ID (different from ManyChat ID) |
