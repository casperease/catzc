# .ado/pipelines/stages/deploy-unit.yaml

The one deploy path of a unit ([FDR-TYPE-ONEDEPLOYPATH](../../../../drs/flow/pipeline-types.md#rule-fdr-type-onedeploypath)). The CD
pipeline of a unit and its DEPLOY pipeline both include it: foundation, then discovery, then expedition. The expedition stage lives in
[`deploy-expedition.yaml`](deploy-expedition.md), which this file includes with the stage's dependency and condition resolved.

## Parameters

- **`Unit`** — the unit name, used in stage names and in the default ADO environment.
- **`Foundations`**, **`Discoveries`**, **`Expeditions`** — lists of
  `{ env, slot?, serviceConnection, subscriptionIdAssertIs, adoEnvironment? }`. Each stage is emitted only when its list is non-empty. The
  ADO environment defaults to `<Unit>-<env>`, with `-<slot>` added for a slotted expedition.
- **`DependsOn`**, **`FirstCondition`**, **`Condition`** — the first emitted stage depends on `DependsOn` and takes `FirstCondition`; each
  later stage depends on the one before it and takes `Condition`, so a skipped first stage skips them all.
- **`ArtifactPipeline`** and **`RunId`** — CD passes no run id and downloads this run's artifacts; DEPLOY passes the certifying CD's
  pipeline and run id.
- **`StageSuffix`** — appended to the stage names, so one pipeline can stage twice, as the prod target does with `_preprod` and `_prod`.
- **`CertifiedBy`** — the environment whose deployment history must hold the commit before any job deploys, for example `<unit>-pre-prod`
  for a prod target.

## Job shape

Every entry becomes one deployment job: it checks out, asserts the deployment history of `CertifiedBy` when set, downloads the tier's
artifact, and runs `Deploy-Bicep` under the entry's service connection with `-SubscriptionIdAssertIs` pinned. A discovery job first runs
`Set-AnomalyAlertRecipientSecret` with the secret pipeline variable `AnomalyAlertRecipients`, which seeds the secret its anomaly alert reads
from the foundation vault, so the what-if resolves the reference.
