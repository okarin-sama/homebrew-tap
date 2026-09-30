class Worklog < Formula
  desc "One-file worklog driver: Jira time logging + OpenProject sync"
  homepage "https://github.com/okarin-sama/worklog"
  url "https://github.com/okarin-sama/worklog/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fb2672ddc2c3a155d96814db1741bf659da476fd3d54a9ef274cb171880cdefd"
  license "MIT"

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
      Jira reads and writes go through Atlassian's TWG CLI, which is public but
      not a Homebrew package:
        curl -fsSL --retry 2 https://teamwork-graph.atlassian.com/cli/install | bash
        twg login && twg setup && twg doctor
      See https://developer.atlassian.com/cloud/twg-cli/getting-started/installation/

      Keep ONE maintained entries file, anywhere, e.g.:
        mkdir -p ~/.config/worklog
        cp #{pkgshare}/entries.example ~/.config/worklog/entries   # start from the sample
        export WORKLOG_ENTRIES=~/.config/worklog/entries           # optional; default search:
                                                                   # $WORKLOG_ENTRIES > ./entries > ~/.config/worklog/entries
        export OP_BASE_URL=https://your-openproject-instance.example
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
