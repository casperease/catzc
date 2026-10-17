---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/design/index.md
    folder: docs/explanation/design
    name: index
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/design/commit-lifecycle.md
      - docs/adr/design/module-aspects.md
      - docs/adr/design/run-modes.md
      - docs/adr/design/server-remote-integration.md
      - docs/adr/design/thin-platforms.md
      - docs/adr/design/tracks.md
      - docs/adr/index.md#design
      - docs/explanation/design/a-push-fires-only-touched-pipelines.md
      - docs/explanation/design/bind-to-one-cli-delegate-the-rest.md
      - docs/explanation/design/clients-bridge-to-one-server.md
      - docs/explanation/design/code-wires-only-the-first-rungs.md
      - docs/explanation/design/deploy-and-integrate-share-only-the-topic.md
      - docs/explanation/design/deploy-bicep-delegates-to-az.md
      - docs/explanation/design/deploying-is-not-integrating.md
      - docs/explanation/design/drop-a-file-the-import-exports-it.md
      - docs/explanation/design/each-pipeline-shape-runs-a-stretch-of-the-ladder.md
      - docs/explanation/design/engineer-merges-pipelines-do-the-rest.md
      - docs/explanation/design/every-deploy-stage-is-main-only.md
      - docs/explanation/design/every-file-in-exactly-one-aspect.md
      - docs/explanation/design/every-vendor-call-leaves-through-az.md
      - docs/explanation/design/four-domains-promote-one-artifact.md
      - docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md
      - docs/explanation/design/guard-and-policies-by-command.md
      - docs/explanation/design/ingress-gated-the-rest-by-review.md
      - docs/explanation/design/integrators-depend-on-an-occupant.md
      - docs/explanation/design/local-guard-and-server-policies.md
      - docs/explanation/design/manifest-and-aspects-from-one-folder.md
      - docs/explanation/design/merging-to-main-is-what-deploys.md
      - docs/explanation/design/one-door-in-one-stable-point-out.md
      - docs/explanation/design/one-entry-script-per-mode.md
      - docs/explanation/design/one-folder-two-independent-readers.md
      - docs/explanation/design/one-unit-one-pipeline.md
      - docs/explanation/design/one-way-climb-three-endings.md
      - docs/explanation/design/out-of-band-deploy-is-adr-only.md
      - docs/explanation/design/partition-integrity-runs-only-in-unit-tests.md
      - docs/explanation/design/same-deploy-bicep-on-both-sides.md
      - docs/explanation/design/shims-set-roots-mode-read-back.md
      - docs/explanation/design/sync-from-the-last-certified-commit.md
      - docs/explanation/design/sync-point-rules-are-adr-only.md
      - docs/explanation/design/ten-commits-trace-the-whole-lifecycle.md
      - docs/explanation/design/two-roots-one-importer-same-modules.md
      - docs/explanation/design/unit-to-pipeline-rule-is-review-only.md
      - docs/explanation/design/units-not-tracks-own-the-pipelines.md
      - docs/explanation/design/what-keeps-the-platform-thin.md
      - docs/explanation/design/where-code-loads-from-decides-the-mode.md
      - docs/explanation/design/which-run-mode-rules-have-a-gate.md
      - docs/explanation/design/which-rung-gates-exist-in-code.md
      - docs/explanation/index.md
---

# Design explanations

```text
How the platform is shaped.

Commit lifecycle states     a commit only climbs, then ends in one of three ways
Out-of-band topic deploy    deploying a topic commit is not integrating it
The sync point              sync from the last certified commit, not from the tip of main
Run modes                   where the code loads from decides the run mode
Module folder layout        every module file is in exactly one aspect
Tracks, units, pipelines    a track ships through a deployable-unit, one pipeline each
The thin platform           consumers bind to one CLI; the rest is delegated to the vendor
Server remote integration   one door in, one stable point out
```

These articles explain decisions from the [design ADR domain](../../adr/index.md#design). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## Commit lifecycle states

A commit only climbs, then ends in one of three ways ([commit-lifecycle](../../adr/design/commit-lifecycle.md)).

| Lens           | Article                                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------------------- |
| meta           | [A commit only climbs, then ends in one of three ways](one-way-climb-three-endings.md)                           |
| architecture   | [Four pipeline kinds promote one artifact that CI built once](four-domains-promote-one-artifact.md)              |
| implementation | [The pipelines wire only topic, landed and BVT; past BVT there is no ladder](code-wires-only-the-first-rungs.md) |
| operations     | [An engineer runs the tests and merges; pipelines do the rest](engineer-merges-pipelines-do-the-rest.md)         |
| governance     | [Only PR build validation, the BVT and the failure stop are checked in code](which-rung-gates-exist-in-code.md)  |

## Commit lifecycle pictures

Two whole-picture diagrams of the same lifecycle ([commit-lifecycle](../../adr/design/commit-lifecycle.md)). They have no separate lenses.

| Picture         | Article                                                                                                                          |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| ten commits     | [Ten numbered commits trace the whole lifecycle across pipeline, environments and git](ten-commits-trace-the-whole-lifecycle.md) |
| pipeline shapes | [Each pipeline shape runs a stretch of the same ladder](each-pipeline-shape-runs-a-stretch-of-the-ladder.md)                     |

## Out-of-band topic deploy

Deploying a topic commit is not integrating it ([commit-lifecycle](../../adr/design/commit-lifecycle.md)).

| Lens           | Article                                                                                                                            |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Deploying a topic commit is not integrating it](deploying-is-not-integrating.md)                                                  |
| architecture   | [Deploying a topic commit and integrating it share only the topic commit](deploy-and-integrate-share-only-the-topic.md)            |
| implementation | [Every Deploy stage in cats runs only from main, so no topic commit is deployed](every-deploy-stage-is-main-only.md)               |
| operations     | [Merging to main is what deploys; there is no run that deploys a topic](merging-to-main-is-what-deploys.md)                        |
| governance     | [No gate checks the out-of-band deploy rule, and the only gate on deploys in code is main-only](out-of-band-deploy-is-adr-only.md) |

## The sync point

Upstream integrators sync from the last certified commit, not from the tip of main
([commit-lifecycle](../../adr/design/commit-lifecycle.md)). This diagram has no implementation or operations lens.

| Lens         | Article                                                                                                                |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| meta         | [Sync from the last certified commit, not from the tip of main](sync-from-the-last-certified-commit.md)                |
| architecture | [Upstream integrators depend on the main-UAT occupant, never on the tip of main](integrators-depend-on-an-occupant.md) |
| governance   | [Only BVT has a gate in code; the sync-point rules are ADR-only](sync-point-rules-are-adr-only.md)                     |

## Run modes

Where the code loads from decides the run mode ([run-modes](../../adr/design/run-modes.md)).

| Lens           | Article                                                                                                                     |
| -------------- | --------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Where the code loads from decides the run mode](where-code-loads-from-decides-the-mode.md)                                 |
| architecture   | [Two code roots feed one importer, which loads the same modules](two-roots-one-importer-same-modules.md)                    |
| implementation | [Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it](shims-set-roots-mode-read-back.md) |
| operations     | [Each run mode has one entry script, and a mixed session throws](one-entry-script-per-mode.md)                              |
| governance     | [Run-mode rules 1 to 6 each have a gate; the build kinds of rule 7 have none](which-run-mode-rules-have-a-gate.md)          |

## Module folder layout

Every module file is in exactly one aspect, and the manifest and the aspects both come from the module folder
([module-aspects](../../adr/design/module-aspects.md)).

| Lens           | Article                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------- |
| meta           | [Every module file is in exactly one aspect](every-file-in-exactly-one-aspect.md)                 |
| architecture   | [One module folder has two independent readers](one-folder-two-independent-readers.md)            |
| implementation | [The manifest and the aspects both come from one folder](manifest-and-aspects-from-one-folder.md) |
| operations     | [Drop a file, and the next import exports it](drop-a-file-the-import-exports-it.md)               |
| governance     | [Partition integrity runs only in unit tests](partition-integrity-runs-only-in-unit-tests.md)     |

## Tracks, units and pipelines

A track ships through a deployable-unit, and each unit has one pipeline ([tracks](../../adr/design/tracks.md)).

| Lens           | Article                                                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| meta           | [A track ships through a deployable-unit, and each unit has one pipeline](one-unit-one-pipeline.md)                                              |
| architecture   | [CD pipelines bind through deployable-units, while CI pipelines bind the track sets directly](units-not-tracks-own-the-pipelines.md)             |
| implementation | [One field in globs.yml, pipeline:, binds a set to its pipeline file](globs-yml-pipeline-field-is-the-binding.md)                                |
| operations     | [A push starts only the pipelines whose globset it touches](a-push-fires-only-touched-pipelines.md)                                              |
| governance     | [Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone](unit-to-pipeline-rule-is-review-only.md) |

## The thin platform

Consumers bind to one CLI, and everything behind it is delegated to the vendor ([thin-platforms](../../adr/design/thin-platforms.md)).

| Lens           | Article                                                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Consumers bind to one CLI, and everything behind it is delegated to the vendor](bind-to-one-cli-delegate-the-rest.md)                   |
| architecture   | [Every vendor call leaves cats through the az CLI](every-vendor-call-leaves-through-az.md)                                               |
| implementation | [Deploy-Bicep adds the guards and the config lookup, and hands every vendor step to az](deploy-bicep-delegates-to-az.md)                 |
| operations     | [A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription](same-deploy-bicep-on-both-sides.md) |
| governance     | [Three gates guard the CLI and az, but nothing checks that cats stays thin](what-keeps-the-platform-thin.md)                             |

## Server remote integration

Changes enter through one door, and consumers build on one stable point
([server-remote-integration](../../adr/design/server-remote-integration.md)).

| Lens           | Article                                                                                                                                     |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| meta           | [Changes enter through one door, and consumers build on one stable point](one-door-in-one-stable-point-out.md)                              |
| architecture   | [Clients bridge to one server remote: in through a pull request, out from the verified point](clients-bridge-to-one-server.md)              |
| implementation | [The code carries both halves of ingress, but nothing finds the last verified commit](local-guard-and-server-policies.md)                   |
| operations     | [A person turns on the local guard with one variant; an admin syncs the server policies with one command](guard-and-policies-by-command.md) |
| governance     | [Only ingress is checked by gates; the source-of-truth and integration rules rest on code review](ingress-gated-the-rest-by-review.md)      |
