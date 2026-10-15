---
catzc:
  derived:
    path: docs/references/pipelines/cd-shared.yaml.md
    kind: reference
    body_sha: d944d39fa28b
    adrs:
      - ADR-AZ-LZ#7
---

# pipelines/cd-shared.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CD pipeline for the central / shared subscription (standalone — not a customer).

CD = CI + CD (see [ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md)): the SAME CI engine as ci-infrastructure.yaml
builds the immutable artifacts, then the deploy stages apply them — build-once / deploy-many. The
shared subscriptions deploy exactly the configuration-root configs: foundation (the per-subscription
Log Analytics + Key Vault) at nsub and psub, discovery (the hub of each tier) at nsub and psub, and
expedition at dev and test (base slots, in the nonprod hub's shared-services subnet).

Stage order is the safety property: foundation owns the Key Vault that discovery and expedition
reference, and expedition lands in the network discovery deploys, so Deploy_Foundation ->
Deploy_Discovery -> Deploy_Expedition. Encoded via dependsOn.

The hubs list the customer spokes they peer to, and the spokes deploy from the customer pipelines.
Adding a spoke therefore runs hub, then spoke, then hub again
([ADR-AZ-LZ#7](/docs/adr/azure/landing-zones.md#rule-adr-az-lz7)) — by hand across this pipeline and the customer's, not
encoded here.

Tier -> service connection: sc-shared-nonprod logs into shared_nonprod (serves nsub / dev / test);
sc-shared-prod into shared_prod (serves psub / preprod / prod). nsub / psub are ordinary -Environment
values (the per-subscription env class). The deploy TARGET is the az session's subscription — what the
service connection logged into — and every deploy pins it with -SubscriptionIdAssertIs (mandatory in a
pipeline — see [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)). The shared platform's configs live at the template's
configuration ROOT, which a non-customer session addresses.

Reference only: deploying requires real Azure service connections and a non-placeholder azure.yml (the
shipped one has placeholder subscription GUIDs). The 'sc-shared-*' names are illustrative.
```

## comment:2

Above `trigger:`.

```text
Trigger = the 'shared' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)):
the foundation, discovery, and expedition templates + modules, plus the configuration-ROOT ymls of each,
minus the customer subfolders. NOTE: on
ADO's order-independent filter, configuration/*.yml (include) and configuration/*/** (exclude) sit at the
SAME folder depth, so ADO may drop a root yml (it is not a deeper-folder re-add). The in-pipeline
Test-GlobSetAffected gate is the exact backstop; the definitive fix is to move the shared platform config
into its own configuration/_shared/ subfolder (folder=key, like every customer) — deferred (touches the
Azure data model). GitHub's ordered '!' negation projects this set exactly.
```

## comment:3

Above `- template: /pipelines/steps/invoke-automation.yaml`.

```text
Build-Bicep writes each template to out/template/<name>; publish that as the artifact the
deploy stages consume. -Shared scopes the build to the configuration-root (shared platform)
slots — customer subfolders are built by their own customer CD.
```
