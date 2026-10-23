---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PATH-WORKSPACEANCHOR
      - ADR-AUTO-TEST-RUNSNEVERWAIT
---

# A workspace anchor names the sibling folder and a busy run uses a verified snapshot (ADR-AUTO-PATH-WORKSPACEANCHOR + ADR-AUTO-TEST-RUNSNEVERWAIT)

This article is one rule: [ADR-AUTO-PATH-WORKSPACEANCHOR](../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)
and [ADR-AUTO-TEST-RUNSNEVERWAIT](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait) merged into one. It holds
nothing beyond what those two rules say.

`{workspace}` is a reserved first path segment for the folder beside the repository, where sibling checkouts live; config never holds an
absolute path or a `..` segment. A test run never waits for another: the first run owns the working folder, and a run that starts while
another holds it runs in a verified snapshot, HEAD plus every uncommitted change plus the untracked files git does not ignore,
byte-identical and checked by `git status` equality before anything runs.
