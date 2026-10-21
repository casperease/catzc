# Merging to main is what deploys; there is no run that deploys a topic

```text
An engineer has nothing to run to deploy a topic commit; completing the pull request into main is what deploys.

1  push topic, open PR     the engineer opens a pull request into main
2  ADO PR build            runs the CI stage and skips every Deploy_* stage
3  Release: Run workflow   builds the package from any ref; a release, not a deploy
4  deploy topic            no pipeline or workflow to run; DRS-only
5  complete PR             lands the commit on main; the push trigger starts the CD run
6  ADO CD run              deploys foundation, discovery, then expedition

Supports FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND (operations lens).
```

Merging to main is the act that deploys, and an engineer who wants a topic commit in an environment has nothing else to run for it. A pull
request starts a build that skips every deploy stage, and the `Release` workflow builds a package but deploys nothing. Only completing the
pull request into main starts a run that deploys. The out-of-band topic deploy that FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND allows has no pipeline
behind it.

![Merging to main is what deploys](.assets/merging-to-main-is-what-deploys.drawio.png)

## Walkthrough

1. **Push topic, open PR.** The engineer pushes a topic branch and opens a pull request into main. The CD pipelines trigger on a PR into
   main.
2. **ADO PR build.** Azure DevOps runs the `CI` stage and skips every `Deploy_*` stage. A PR build's source branch is a pull-request ref,
   and each deploy stage runs only when the source branch is `refs/heads/main`.
3. **Release: Run workflow.** The GitHub `Release` workflow is started by hand and runs on any ref. It always builds the `.nupkg` and
   uploads it; publishing to a GitHub Release, GitHub Packages or the PowerShell Gallery is opt-in per input. It is a release, not a deploy
   to an environment.
4. **Deploy topic.** Deploying a topic commit to an environment has no pipeline or workflow to run.
5. **Complete PR.** Completing the pull request lands the commit on main, and the push trigger on main starts the CD run.
6. **ADO CD run.** On main, the deploy stages run in order, foundation, discovery, then expedition. Each job deploys to an Azure DevOps
   environment named `<Customer>-<env>[-<slot>]`: an expedition entry with a slot adds `-<slot>`, and one without deploys the env's base
   slot.

## Why it holds

- A topic commit can be deployed out-of-band by a workflow or pipeline, and that deploy is not an integration
  (FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND). The operator sees the stricter code: only main deploys.

## Where the code and the decision record differ

FDR-CD-LIFE-TOPICDEPLOYSOUTOFBAND describes an out-of-band topic deploy that no pipeline offers, so an operator has nothing to run for it.

## See also

- [The commit lifecycle](../../drs/flow/commit-lifecycle.md) — the decision this article explains.
- The other lenses on the same deploy: [meta](deploying-is-not-integrating.md),
  [architecture](deploy-and-integrate-share-only-the-topic.md), [implementation](every-deploy-stage-is-main-only.md) and
  [governance](out-of-band-deploy-is-drs-only.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
