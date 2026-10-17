# hoshinosoftware.com

GitHub Pages from `docs/`; a push to main is live within a minute or two.

## App page conventions

Each app lives at `docs/<app>/`, with one folder per language (`en/`, `tr/`, `ja/`, …) and an
`index.html` that redirects.

- **Language strip labels:** two-letter capital codes for Latin-script languages (`EN`, `TR`,
  `DE`, `FR`, `ES`, `IT`, `PT`), native names for other scripts (`日本語`, `한국어`, `简体中文`,
  `繁體中文`, `العربية`). Codes in a foreign script read as noise to those readers. Turkish was
  `Türkçe` on 6 apps and `TR` on 2 until 2026-10-17; all `TR` now.
- **Default language** (the redirect in `docs/<app>/index.html`): the app's main market.
  Turkish-first apps (Müşahit Sayacı, Plaka) always open `tr/`; the rest open `en/`, except Fold
  Angle, which follows the browser language. English is one tap away in the strip.
- **Keep `#section` links working:** redirect with a script that forwards the hash
  (`#support`, `#legal`, …), not `<meta http-equiv="refresh">`, which drops it. Bubble Level and
  Photo Triager still use the meta refresh.
- **App Store links point at a language folder** (`/plaka/en/#legal`), never at the redirect,
  so a listing never lands in the wrong language when a default changes.
