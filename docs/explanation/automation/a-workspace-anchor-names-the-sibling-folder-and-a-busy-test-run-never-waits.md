---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PATH-WORKSPACEANCHOR
      - ADR-AUTO-TEST-RUNSNEVERWAIT
---

# A workspace anchor names the sibling folder and a busy test run never waits (ADR-AUTO-PATH-WORKSPACEANCHOR + ADR-AUTO-TEST-RUNSNEVERWAIT)

This article is one rule: [ADR-AUTO-PATH-WORKSPACEANCHOR](../../drs/automation/path-representation.md#rule-adr-auto-path-workspaceanchor)
and [ADR-AUTO-TEST-RUNSNEVERWAIT](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait) merged into one. It holds
nothing beyond what those two rules say.

Two rules keep work from colliding with its surroundings. `{workspace}` is a reserved first path segment for the folder beside the
repository, where sibling checkouts live; config never holds an absolute path or a `..` segment, and the anchor resolves only at the point
of use, reading `C:\projects\catzc` under pwsh and `/c/projects/catzc` under Git Bash as the same place. Likewise a test run never waits for
another: the first run owns the working folder, and a run that starts while another holds it runs in a verified snapshot of that folder,
with the busy folder announced together with the run that holds it.
