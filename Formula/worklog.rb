class Worklog < Formula
  desc "One-file worklog driver: Jira time logging + OpenProject sync"
  homepage "https://github.com/okarin-sama/worklog"
  # The source repo is PRIVATE and Homebrew refuses to use your git/API
  # credentials for formula downloads — so the release tarball is vendored in
  # this tap under dist/ (brew already authenticates the tap clone with your
  # gh/git setup). On every release: rebuild the tarball, drop it in dist/,
  # update url/sha256 below. See CONTRIBUTING.md in the source repo.
  url "file://#{File.expand_path("../dist/worklog-1.0.1.tar.gz", __dir__)}"
  version "1.0.1"
  sha256 "8f9cb818068d9ebb5485bed0de14f1fa28205be45e0d094388e8f7647d0a0fde"
  # internal tooling: no SPDX license (see LICENSE = all-rights-reserved)

  depends_on "jq" # curl is part of macOS; the scripts run on stock bash 3.2+

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
