# homebrew-tap — public tap for okarin-sama tooling

Formulae for tools whose source lives elsewhere. Currently: **worklog** (source:
[okarin-sama/worklog](https://github.com/okarin-sama/worklog), MIT).

## Usage

No authentication needed — tap and source are both public, and the formula
installs from the source repo's tagged release archive:

```bash
brew tap okarin-sama/tap
brew trust okarin-sama/tap          # one-time approval (brew >= 6 trust gate)
brew install worklog
brew info worklog                   # setup caveats: twg, OP_BASE_URL/OP_TOKEN, WORKLOG_ENTRIES
```

`worklog` shells out to Atlassian's public
[TWG CLI](https://developer.atlassian.com/cloud/twg-cli/getting-started/installation/)
for every Jira read/write. Install and authenticate it separately
(`twg login && twg setup`); OpenProject sync additionally needs your own
`OP_BASE_URL` / `OP_TOKEN`. See `brew info worklog` after installing.

## Day-2 operations

```bash
brew update && brew upgrade worklog   # pull the newest upstream release
brew test worklog                     # runs the formula's test block (--help x3)
brew unlink worklog                   # pause the tap version, keep a repo checkout
```

## Adding/updating a formula (maintainer notes)

Full release process lives in the source repo's
[CONTRIBUTING.md](https://github.com/okarin-sama/worklog/blob/main/CONTRIBUTING.md#releases--the-homebrew-tap).
Short version per release `vX.Y.Z`:

1. tag the source repo and push the tag;
2. hash the public archive GitHub generates for that tag:
   ```bash
   curl -sL https://github.com/okarin-sama/worklog/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```
3. update `Formula/worklog.rb` (`url` tag + `sha256`) — no `version` line,
   Homebrew derives it from the URL and an explicit one fails `brew audit
   --strict`; then `brew style Formula/worklog.rb`, commit, push;
4. verify: `brew update && brew upgrade worklog && brew test worklog && worklog-run --print-map`.

Nothing is vendored in this repo; `brew audit --strict` must stay clean.
