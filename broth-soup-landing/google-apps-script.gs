/**
 * Fusion Broth Co. — Waitlist Form Handler
 * ─────────────────────────────────────────
 * Paste this entire file into Google Apps Script (script.google.com),
 * then deploy it as a Web App (see SETUP.md for full instructions).
 *
 * It writes each form submission as a new row in the active Google Sheet.
 */

// ─── Configuration ────────────────────────────────────────────────────────────

// Name of the sheet tab to write data into.
// If it doesn't exist it will be created automatically.
const SHEET_NAME = 'Waitlist';

// ─── Main handler ─────────────────────────────────────────────────────────────

/**
 * Handles both GET (health-check) and POST (form submission) requests.
 */
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    appendRow(data);
    return respond({ status: 'ok' });
  } catch (err) {
    return respond({ status: 'error', message: err.message }, 500);
  }
}

function doGet() {
  return respond({ status: 'ok', message: 'Fusion Broth Co. waitlist endpoint is live.' });
}

// ─── Sheet helpers ────────────────────────────────────────────────────────────

function appendRow(data) {
  const ss    = SpreadsheetApp.getActiveSpreadsheet();
  let   sheet = ss.getSheetByName(SHEET_NAME);

  // Create the sheet and add headers if it doesn't exist yet
  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME);
    sheet.appendRow(['Timestamp', 'Name', 'Email', 'Jars']);
    // Style the header row
    const header = sheet.getRange(1, 1, 1, 4);
    header.setFontWeight('bold');
    header.setBackground('#1a1a14');
    header.setFontColor('#C9A84C');
  }

  sheet.appendRow([
    data.timestamp || new Date().toISOString(),
    data.name      || '',
    data.email     || '',
    data.jars      || '',
  ]);
}

// ─── Response helper ──────────────────────────────────────────────────────────

function respond(payload, code) {
  const output = ContentService
    .createTextOutput(JSON.stringify(payload))
    .setMimeType(ContentService.MimeType.JSON);
  return output;
}
