# Design explanations

```text
How the platform is shaped.

Commit lifecycle states     a commit only climbs, then ends in one of three ways
Out-of-band topic deploy    deploying a topic commit is not integrating it
The sync point              sync from the last certified commit, not from the tip of main
Run modes                   where the code loads from decides the run mode
Module folder layout        every module file is in exactly one aspect
Tracks, units, pipelines    a track ships through a deployable-unit, one pipeline each
The sibling model          catzc and eac compared model by model; an idea crosses by being rebuilt here
The thin platform           consumers bind to one CLI; the rest is delegated to the vendor
Server remote integration   one door in, one stable point out
```

These articles explain decisions from the [design decision-record domain](../../drs/index.md#design). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## Commit lifecycle states

A commit only climbs, then ends in one of three ways ([commit-lifecycle](../../drs/flow/commit-lifecycle.md)).

| Lens           | Article                                                                             |
| -------------- | ----------------------------------------------------------------------------------- |
| meta           | [How a commit climbs the ladder](how-a-commit-climbs-the-ladder.md)                 |
| architecture   | [How one build reaches production](how-one-build-reaches-production.md)             |
| implementation | [Which ladder rungs the pipelines wire](which-ladder-rungs-the-pipelines-wire.md)   |
| operations     | [Who does what from merge to production](who-does-what-from-merge-to-production.md) |
| governance     | [Which ladder rungs have a gate in code](which-ladder-rungs-have-a-gate-in-code.md) |

## Commit lifecycle pictures

Two whole-picture diagrams of the same lifecycle ([commit-lifecycle](../../drs/flow/commit-lifecycle.md)). They have no separate lenses.

- **ten commits**: [The commit lifecycle end to end](ten-commits-trace-the-whole-lifecycle.md)
- **pipeline shapes**: [Which ladder stretch each pipeline runs](each-pipeline-shape-runs-a-stretch-of-the-ladder.md)

## Out-of-band topic deploy

Deploying a topic commit is not integrating it ([commit-lifecycle](../../drs/flow/commit-lifecycle.md)).

- **meta**: [How deploying differs from integrating](how-deploying-differs-from-integrating.md)
- **architecture**: [What deploying and integrating share](what-deploying-and-integrating-share.md)
- **implementation**: [Where a Deploy stage may run](where-a-deploy-stage-may-run.md)
- **operations**: [What triggers a deploy](what-triggers-a-deploy.md)
- **governance**: [Which deploy rules have a gate](which-deploy-rules-have-a-gate.md)

## The sync point

Upstream integrators sync from the last certified commit, not from the tip of main ([commit-lifecycle](../../drs/flow/commit-lifecycle.md)).
This diagram has no implementation or operations lens.

- **meta**: [Which commit a sync starts from](which-commit-a-sync-starts-from.md)
- **architecture**: [Where upstream integrators sync from](where-upstream-integrators-sync-from.md)
- **governance**: [Which sync-point rules have a gate](which-sync-point-rules-have-a-gate.md)

## Run modes

Where the code loads from decides the run mode ([run-modes](../../drs/design/run-modes.md)).

- **meta**: [How the run mode is decided](how-the-run-mode-is-decided.md)
- **architecture**: [How two code roots load the modules](how-two-code-roots-load-the-modules.md)
- **implementation**: [How the run mode is read back](how-the-run-mode-is-read-back.md)
- **operations**: [Which entry script each run mode uses](which-entry-script-each-run-mode-uses.md)
- **governance**: [Which run-mode rules have a gate](which-run-mode-rules-have-a-gate.md)

## Module folder layout

Every module file is in exactly one aspect, and the manifest and the aspects both come from the module folder
([module-aspects](../../drs/design/module-aspects.md)).

| Lens           | Article                                                                                         |
| -------------- | ----------------------------------------------------------------------------------------------- |
| meta           | [Which aspect a module file belongs to](which-aspect-a-module-file-belongs-to.md)               |
| architecture   | [Who reads a module folder](who-reads-a-module-folder.md)                                       |
| implementation | [Where the manifest and the aspects come from](where-the-manifest-and-the-aspects-come-from.md) |
| operations     | [How a dropped file gets exported](how-a-dropped-file-gets-exported.md)                         |
| governance     | [Where partition integrity is checked](where-partition-integrity-is-checked.md)                 |

## Tracks, units and pipelines

A track ships through a deployable-unit, and each unit has one pipeline ([tracks](../../drs/design/tracks.md)).

- **meta**: [How a track ships through a unit](how-a-track-ships-through-a-unit.md)
- **architecture**: [How CD and CI pipelines bind](how-cd-and-ci-pipelines-bind.md)
- **implementation**: [How a glob set binds to its pipeline](how-a-glob-set-binds-to-its-pipeline.md)
- **operations**: [Which pipelines a push starts](which-pipelines-a-push-starts.md)
- **governance**: [Which track and unit rules have a gate][unit-review]

## The sibling model

Catzc and eac, the same family in two languages, compared model by model ([tracks](../../drs/design/tracks.md),
[one-living-version](../../drs/principles/one-living-version.md)). One article, one meta slide, no other lenses.

| Picture      | Article                                                           |
| ------------ | ----------------------------------------------------------------- |
| the siblings | [How a sibling project is used](how-a-sibling-project-is-used.md) |

## The thin platform

Consumers bind to one CLI, and everything behind it is delegated to the vendor ([thin-platforms](../../drs/design/thin-platforms.md)).

- **meta**: [Which CLI consumers bind to](which-cli-consumers-bind-to.md)
- **architecture**: [How vendor calls leave cats](how-vendor-calls-leave-cats.md)
- **implementation**: [How Deploy-Bicep hands work to az](how-deploy-bicep-hands-work-to-az.md)
- **operations**: [How developers and pipelines run Deploy-Bicep](how-developers-and-pipelines-run-deploy-bicep.md)
- **governance**: [Which gates guard the az boundary](which-gates-guard-the-az-boundary.md)

## Server remote integration

Changes enter through one door, and consumers build on one stable point
([server-remote-integration](../../drs/design/server-remote-integration.md)).

- **meta**: [How changes enter and consumers build](how-changes-enter-and-consumers-build.md)
- **architecture**: [How clients reach the server remote](how-clients-reach-the-server-remote.md)
- **architecture**: [How a change leaves and returns through a topic](how-a-change-leaves-and-returns-through-a-topic.md)
- **implementation**: [How ingress is guarded locally and on the server](how-ingress-is-guarded-locally-and-on-the-server.md)
- **operations**: [How the guard and the server policies are turned on][guard-policies]
- **governance**: [Which ingress rules have a gate](which-ingress-rules-have-a-gate.md)

[unit-review]: which-track-and-unit-rules-have-a-gate.md
[guard-policies]: how-the-guard-and-the-server-policies-are-turned-on.md
