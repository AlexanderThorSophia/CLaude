-- ═══════════════════════════════════════════════════════════════════════════
-- Hollywood Colourblend — Supabase Database Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ═══════════════════════════════════════════════════════════════════════════

-- Step 1: Create the conversations table
-- This stores the full message history for each Instagram contact
CREATE TABLE IF NOT EXISTS conversations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id      TEXT NOT NULL UNIQUE,   -- ManyChat subscriber ID (unique per contact)
    contact_name    TEXT,                   -- First name for reference
    messages        JSONB NOT NULL DEFAULT '[]'::jsonb,  -- Array of {role, content, timestamp}
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 2: Index on contact_id for fast lookups (n8n fetches by this field on every DM)
CREATE INDEX IF NOT EXISTS idx_conversations_contact_id ON conversations(contact_id);

-- Step 3: Index on updated_at for admin queries (e.g. "show recent conversations")
CREATE INDEX IF NOT EXISTS idx_conversations_updated_at ON conversations(updated_at DESC);

-- Step 4: Auto-update the updated_at timestamp on every row change
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_updated_at
    BEFORE UPDATE ON conversations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Step 5: Row Level Security — restrict access to the service role only
-- (The n8n workflow uses the service_role key, which bypasses RLS)
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

-- Block all public access (only service_role key can read/write)
CREATE POLICY "No public access" ON conversations
    FOR ALL
    TO public
    USING (false);

-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICATION QUERIES
-- Run these after setup to confirm everything is correct
-- ═══════════════════════════════════════════════════════════════════════════

-- Check the table was created:
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'conversations';

-- Check RLS is enabled:
-- SELECT tablename, rowsecurity FROM pg_tables WHERE tablename = 'conversations';

-- ═══════════════════════════════════════════════════════════════════════════
-- EXAMPLE DATA FORMAT
-- This shows what a conversation record looks like in the messages JSONB column
-- ═══════════════════════════════════════════════════════════════════════════

/*
Example row:
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "contact_id": "1234567890",
  "contact_name": "Sophie",
  "messages": [
    {
      "role": "user",
      "content": "Hi, how much is a balayage?",
      "timestamp": "2025-09-01T10:32:00.000Z"
    },
    {
      "role": "assistant",
      "content": "Hi! 👋 Our Hollywood Colour Blend services start from £225...",
      "timestamp": "2025-09-01T10:32:04.000Z"
    }
  ],
  "created_at": "2025-09-01T10:32:00.000Z",
  "updated_at": "2025-09-01T10:32:05.000Z"
}
*/

-- ═══════════════════════════════════════════════════════════════════════════
-- ADMIN QUERIES (useful for Catherine / operations)
-- ═══════════════════════════════════════════════════════════════════════════

-- View the 20 most recent conversations:
-- SELECT contact_id, contact_name, updated_at, jsonb_array_length(messages) AS message_count
-- FROM conversations
-- ORDER BY updated_at DESC
-- LIMIT 20;

-- View all messages for a specific contact:
-- SELECT messages FROM conversations WHERE contact_id = 'MANYCHAT_CONTACT_ID_HERE';

-- Delete old conversations (older than 90 days) — run periodically for GDPR compliance:
-- DELETE FROM conversations WHERE updated_at < NOW() - INTERVAL '90 days';

-- Count total unique contacts who have messaged:
-- SELECT COUNT(*) FROM conversations;
