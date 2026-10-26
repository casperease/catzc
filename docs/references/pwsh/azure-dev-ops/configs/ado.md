# pwsh/Azure.DevOps/configs/ado.yml

The Azure DevOps coupling of this repository's automation: the organization and project it targets and the Entra tenant behind them. It is
loaded by `Get-Config -Config ado` and mirrored by the `AdoConfig` type.

## Keys

- **`organization`** — the organization URL, the REST API host. The API functions (`New-AdoPullRequest`, `Register-AdoPipeline`,
  `Get-AdoPipelineDefinitions` and the others) default their organization from it.
- **`project`** — the default project, URL-encoded.
- **`yaml_inventory_depth`** — optional; how deep the YAML inventory walks below its root, 6 when the key is absent. Pipelines sit up to
  five folders below the repository root.
- **`tenant`** — the Entra (Azure AD) tenant GUID backing the organization, a required key. The az session that mints an Azure DevOps token
  must be logged into this directory, and `Get-AdoAuthorizationHeader` asserts it before minting on its az fallback path. The shipped value
  is a placeholder, the same minted tenant as `azure.yml`'s; each deployment target replaces it with the real one.
