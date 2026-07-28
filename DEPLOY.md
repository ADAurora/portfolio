# Deploy — GitHub Pages

## ⚠️ Safety rules for every future repo (read once, apply forever)

One repo per project, and the repo folder contains ONLY what the public should
see. **Never run `git init` in `~/Projects` root or any other project folder** —
this repo is `~/Projects/portfolio` and nothing else. `.gitignore` goes in the
very first commit, before anything is added. Run `sh check-secrets.sh` before
**every** push (first and forever); if it prints anything but "clean", stop.
Never push from any folder that contains a `.env`, `.telegram-env`,
`.discord-env`, or any credential file — your tokens live elsewhere on this
machine and must stay there.

**This repo contains exactly 4 files:** `index.html`, `DEPLOY.md`,
`.gitignore`, `check-secrets.sh`. If anything else appears here, investigate
before committing.

## Launch (Case A: existing account — you have one)

**With `gh` CLI (check: `gh --version`; if missing: `brew install gh`):**

```bash
cd ~/Projects/portfolio
sh check-secrets.sh || { echo "STOP"; exit 1; }   # must print: ✓ clean
gh auth login                                      # one-time, opens browser
git init && git add .gitignore index.html DEPLOY.md check-secrets.sh
git commit -m "launch v1"
gh repo create portfolio --public --source=. --push
gh api -X POST "repos/{owner}/portfolio/pages" -f "source[branch]=main" -f "source[path]=/"
```

**Without `gh` CLI (web + git):**

1. Create empty public repo named `portfolio` at github.com/new
2. ```bash
   cd ~/Projects/portfolio
   sh check-secrets.sh || { echo "STOP"; exit 1; }   # must print: ✓ clean
   git init && git add .gitignore index.html DEPLOY.md check-secrets.sh
   git commit -m "launch v1"
   git branch -M main
   git remote add origin https://github.com/ADAurora/portfolio.git
   git push -u origin main
   ```
3. Repo → Settings → Pages → Source: `main` branch, `/ (root)` → Save

Live at `https://ADAurora.github.io/portfolio/` in ~1 min.

## Every future update — scan is part of the flow, always

```bash
cd ~/Projects/portfolio && sh check-secrets.sh && git add -A && git commit -m "update" && git push
```

The `&&` chain means the push cannot happen unless the scan passes.
Optional upgrade later: `brew install gitleaks`, then `gitleaks dir .` for a
deeper scan — check-secrets.sh remains the minimum bar.

## Custom domain (optional, v2)

~$10/yr via Cloudflare Registrar; attach in repo Settings → Pages. Don't block
launch on it.

## Status

Launched 2026-07-27 via the GitHub web UI (repo: ADAurora/portfolio).
Footer contact = X DMs + GitHub; a branded email can slot in later (commented
block is ready in index.html). The CLI flow above is for future updates once
`gh`/token auth is sorted — web upload works fine for a small site meanwhile.
