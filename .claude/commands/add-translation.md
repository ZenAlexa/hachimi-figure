---
description: Add translation keys to all locales
argument-hint: [namespace] [key] [en-value]
---

Add a new translation key to all locale files (en, zh, ja):

1. Namespace/file: $1
2. Key: $2
3. English value: $3

Files to update:
- i18n/messages/en/$1.json
- i18n/messages/zh/$1.json
- i18n/messages/ja/$1.json

For Chinese and Japanese translations:
- Use Google Translate API if GOOGLE_TRANSLATE_API_KEY is configured
- Otherwise, mark with TODO for manual translation

Ensure proper JSON formatting and verify all files are valid JSON after modification.
