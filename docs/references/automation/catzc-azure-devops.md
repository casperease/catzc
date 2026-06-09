# Catzc.Azure.DevOps

The Azure DevOps integration module. It is the boundary between the automation layer and an Azure DevOps organization: authenticating to it,
calling its REST API, taking inventory of the pipeline YAML in the repository, and bridging a running pipeline back to PowerShell. Its
organization identity is configured, not guessed.

## Domains

| Domain   | Area      | Name                                                                                               |
| -------- | --------- | -------------------------------------------------------------------------------------------------- |
| domain:1 | auth      | [Organization identity and authentication](#domain1--organization-identity-and-authentication)     |
| domain:2 | rest      | [Azure DevOps REST operations](#domain2--azure-devops-rest-operations)                             |
| domain:3 | discovery | [Pipeline YAML discovery and classification](#domain3--pipeline-yaml-discovery-and-classification) |
| domain:4 | runtime   | [Pipeline runtime bridge](#domain4--pipeline-runtime-bridge)                                       |

### domain:1 — Organization identity and authentication

Knowing which organization and tenant the automation targets, and producing an authorization header proven to point at that organization.
The credential is selected by a fixed precedence — an in-pipeline agent token, then a personal access token, then the Azure CLI session —
and each source must prove it targets the configured organization before a header is returned. The organization identity lives in `ado.yml`.
See [dual-authentication](../../adr/pipelines/dual-authentication.md).

### domain:2 — Azure DevOps REST operations

Acting on the organization through its REST API: issuing an authenticated request, opening a pull request, registering or updating a
pipeline definition, and reading the pipeline definitions the organization already has. This is the outward, state-changing surface.

### domain:3 — Pipeline YAML discovery and classification

Reading the repository's own pipeline YAML: finding the YAML files and classifying each as a pipeline or a template (and which kind) from
its structure and the organization's registration data. This answers "what pipelines and templates does this repo define?" without deploying
anything.

### domain:4 — Pipeline runtime bridge

The thin interface a job uses while it is running inside a pipeline: setting an output variable through the validated wrapper (never a raw
logging command), normalising a command string handed in by the YAML layer, and emitting an environment diagnostic. These are no-ops or
pass-through's outside a pipeline. Its environment config lives in `pipeline-env.yml`. See
[pipeline-variables](../../adr/pipelines/pipeline-variables.md).

## What the module does

The module has an inward face and an outward face. The outward face (domains 1 and 2) talks _to_ the organization: authentication
establishes a proven identity, and the REST operations act through it. The defining rule of domain 1 is that a present credential is not
enough — every source must prove it is aimed at the configured organization, so a token can never silently act against the wrong tenant.

The inward faces (domains 3 and 4) are about the repository and the running job. Discovery (domain 3) treats the pipeline YAML as data to be
inventoried and classified — by structure, not by filename — which is how tooling reasons about what the repo defines. The runtime bridge
(domain 4) is the narrow seam a step uses while executing: it sets variables and reads commands through validated wrappers so that the sharp
edges of Azure DevOps logging commands are handled in one place rather than scattered as raw strings, and so the same code runs unchanged on
a developer's machine, where those operations simply do nothing.

The module reads two configs. `ado.yml` carries the organization and tenant that define "correct" for authentication. `pipeline-env.yml`
carries the environment settings the runtime bridge needs.

## Division

The module's public functions and configuration, sorted into the domains above.

| Domain                                                | Function                         |
| ----------------------------------------------------- | -------------------------------- |
| domain:1 — Organization identity and authentication   | `Get-AdoAuthorizationHeader`     |
| config                                                | `ado.yml`                        |
| domain:2 — Azure DevOps REST operations               | `Invoke-AdoRestMethod`           |
|                                                       | `New-AdoPullRequest`             |
|                                                       | `Register-AdoPipeline`           |
|                                                       | `Get-AdoPipelineDefinitions`     |
| domain:3 — Pipeline YAML discovery and classification | `Get-AdoYamlFiles`               |
|                                                       | `Get-AdoYamlInventory`           |
| domain:4 — Pipeline runtime bridge                    | `Set-AdoPipelineVariable`        |
|                                                       | `ConvertFrom-AdoPipelineCommand` |
|                                                       | `Write-AdoEnvironmentDiagnostic` |
| config                                                | `pipeline-env.yml`               |
