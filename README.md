# homebrew-tap — private tap for okarin-sama's internal tooling

Formulae for tools whose source lives elsewhere. Currently: **worklog** (source:
[okarin-sama/worklog](https://github.com/okarin-sama/worklog)).

## Usage

Both this tap and the source repo are **private**, so brew needs your GitHub
credentials (the same `gh` session you use day to day):

```bash
gh auth login                      # once
export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)   # add to your shell profile
brew tap okarin-sama/tap
brew install worklog               # or: brew install --head worklog
brew info worklog                  # setup caveats: twg, OP_BASE_URL/OP_TOKEN, WORKLOG_ENTRIES
```

## Day-2 operations

```bash
brew update && brew upgrade worklog          # pull a new tagged release
brew test worklog                             # runs the formula's test block
brew unlink worklog                           # pause the tap version, keep the repo copy
```

## Adding/updating a formula (maintainer notes)

Release process is defined in the source repo's
[CONTRIBUTING.md](https://github.com/okarin-sama/worklog/blob/main/CONTRIBUTING.md#releases--the-homebrew-tap):

1. tag the source repo (`vX.Y.Z`) and push the tag;
2. hash the exact tarball URL the formula uses:
   ```bash
   curl -sL -H "Authorization: Bearer $(gh auth token)" \
     https://github.com/okarin-sama/worklog/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
   ```
3. update `Formula/worklog.rb` (url + sha256), `brew style Formula/worklog.rb`,
   commit, push;
4. `brew update && brew upgrade worklog && worklog-run --print-map` to verify.
