class Worklog < Formula
  desc "One-file worklog driver: batch-logs time to Jira and syncs mapped items to OpenProject"
  homepage "https://github.com/okarin-sama/worklog"
  url "https://github.com/okarin-sama/worklog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ef0bbd40278a44ca0ad67000cbe8f0ebee46cdcb5c3bbbe29ad7e6542371ba75"
  # Private repo: brew needs a GitHub token for the tarball download —
  #   export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
  # or install from head, which clones over the git credentials you already have:
  #   brew install --head worklog
  head "https://github.com/okarin-sama/worklog.git", branch: "main"
  # internal tooling: no SPDX license (see LICENSE = all-rights-reserved)

  depends_on "jq"   # curl is part of macOS; the scripts run on stock bash 3.2+

  def install
    # GitHub archive tarballs extract into worklog-<version>/; Homebrew cds into
    # the single top-level directory automatically.
    %w[worklog-run worklog-add worklog-summary op-sync].each do |cmd|
      bin.install "#{cmd}.sh" => cmd
    end
    # Ship the entry grammar as a sample only — never a user's real timesheet.
    pkgshare.install "entries.example"
  end

  def caveats
    <<~EOS
      Requires the internal `twg` CLI on PATH (or ~/.local/bin/twg). It is not a
      public package — install it the way your team distributes it.

      Keep ONE maintained entries file, anywhere, e.g.:
        mkdir -p ~/.config/worklog
        cp #{pkgshare}/entries.example ~/.config/worklog/entries   # start from the sample
        export WORKLOG_ENTRIES=~/.config/worklog/entries           # optional; default search:
                                                                   # $WORKLOG_ENTRIES > ./entries > ~/.config/worklog/entries
        export OP_BASE_URL=https://op.example.com
        export OP_TOKEN=...            # OP personal token, scope: Time & costs

      Then from any directory:
        worklog-run --dry-run          # preview both phases, write nothing
        worklog-run --yes              # log untracked lines to Jira + mirror op:-tagged keys to OpenProject
        worklog-run --print-map        # show the generated Jira -> OpenProject mapping table
    EOS
  end

  test do
    system bin/"worklog-run", "--help"
    system bin/"worklog-add", "--help"
    system bin/"op-sync", "--help"
  end
end
