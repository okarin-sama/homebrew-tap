# homebrew-tap — private tap for okarin-sama's internal tooling

Formulae for tools whose source lives elsewhere. Currently: **worklog** (source:
[okarin-sama/worklog](https://github.com/okarin-sama/worklog)).

## Usage

Both this tap and the source repo are **private**. No extra tokens needed:
brew clones the tap with your regular git credentials (set up once with
`gh auth setup-git`), and each formula's source tarball is **vendored right in
this tap under `dist/`** — Homebrew deliberately refuses to authenticate
formula *downloads* from private repos, so vendoring is the supported pattern
for private internal tooling.

```bash
brew tap okarin-sama/tap
brew trust okarin-sama/tap          # one-time approval (brew >= 6 trust gate)
brew install worklog
brew info worklog                   # setup caveats: twg, OP_BASE_URL/OP_TOKEN, WORKLOG_ENTRIES
```

## Day-2 operations

```bash
brew update && brew upgrade worklog   # pull the newest vendored release
brew test worklog                     # runs the formula's test block (--help x3)
brew unlink worklog                   # pause the tap version, keep a repo checkout
```

## Adding/updating a formula (maintainer notes)

Release process lives in the source repo's
[CONTRIBUTING.md](https://github.com/okarin-sama/worklog/blob/main/CONTRIBUTING.md#releases--the-homebrew-tap).
Short version per release `vX.Y.Z`:

1. tag the source repo and push the tag;
2. download the exact archive:
   ```bash
   curl -sL -H "Authorization: Bearer $(gh auth token)" \
     -o dist/worklog-X.Y.Z.tar.gz \
     https://github.com/okarin-sama/worklog/archive/refs/tags/vX.Y.Z.tar.gz
   shasum -a 256 dist/worklog-X.Y.Z.tar.gz
   ```
3. commit it under `dist/`, update `Formula/worklog.rb` (`url` filename,
   `version`, `sha256`), run `brew style Formula/worklog.rb`, push;
4. verify: `brew update && brew upgrade worklog && worklog-run --print-map`.
