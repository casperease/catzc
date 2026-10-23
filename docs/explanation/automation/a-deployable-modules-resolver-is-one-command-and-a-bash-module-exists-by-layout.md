---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
      - ADR-AUTO-BASH-MODULESBYLAYOUT
---

# A deployable modules resolver is one command and a bash module exists by layout

This article is one rule:
[ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule) and
[ADR-AUTO-BASH-MODULESBYLAYOUT](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-modulesbylayout) merged into one. It
holds nothing beyond what those two rules say.

A module of a deployable track is resolved through the track that holds it, by one resolver, `Get-CatzcModule`, which returns for each
module its name, track, root, shape, files, languages and engines. Bash modules in the `bash` track are found by layout in the same way: a
folder under the Bash root, or a black-box `.bats` test under the track's test holder. A Bash module ships only what `files.yml` packages, a
test file never ships, and no function of the engine is written in Bash.
