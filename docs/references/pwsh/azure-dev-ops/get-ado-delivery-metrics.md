# pwsh/Azure.DevOps/Get-AdoDeliveryMetrics.ps1

Reports DORA's four delivery metrics per deployable unit, read from the deployments of the unit's production environment in Azure DevOps:
deployment frequency, change lead time, change fail rate and failed deployment recovery time ([metrics](../../dora/metrics.md)).

## help

### synopsis

Returns the four DORA delivery metrics of each deployable unit's production environment over a window of days.

### description

A unit's production environment is `<unit>-<rung>`, the last rung of the ladder (Get-Rung). Its succeeded and failed deployment records that
finished in the window are read once. Deployment frequency is the succeeded deployments per day. Change lead time is the median, in hours,
from the deployed commit's commit time to the deployment's finish; the commit is the one the run built, or the CI run a DEPLOY run names
(Resolve-AdoRunCommit), and its time is read from the local git history. Change fail rate is the failed deployments over all of them. Failed
deployment recovery time is the median, in hours, from a failed deployment to the next succeeded one. A unit whose production environment
does not exist, or saw no deployment, reports zero deployments and empty metrics.

### parameter `Unit`

The deployable units. Default: every unit a deploy pipeline (`.ado/pipelines/deploy-<unit>.yaml`) names.

### parameter `Days`

The window, in days back from `-Now`. Default: 30.

### parameter `Now`

The end of the window. Default: now, in UTC.

### parameter `Project`

The Azure DevOps project. Default: ado.yml's `project`.

### parameter `Organization`

The Azure DevOps organization URL. Default: ado.yml's `organization`.

### parameter `Top`

The most deployment records read per environment. Default: 1000.

### parameter `RepositoryRoot`

The repository whose git history gives each commit's time. Default: the loaded repository root.

### outputs

`[pscustomobject]` per unit: Unit, Environment, Days, Deployments, DeploymentsPerDay, LeadTimeHours, ChangeFailRate, RecoveryHours.

### example 1

```powershell
Get-AdoDeliveryMetrics -Days 90 | Format-Table
```
