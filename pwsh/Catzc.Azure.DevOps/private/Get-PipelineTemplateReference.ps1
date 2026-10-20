<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
    folder: private
    name: get-pipeline-template-reference
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1
    docs: "[Get-PipelineTemplateReference.ps1.md](docs/references/pwsh/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md)"
    cites:
      - ADR-ADO-NAME-ABSOLUTETEMPLATEPATH
---
#>

function Get-PipelineTemplateReference {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $refs = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Get-Content -Path $Path)) {
        # A `template:` key at a mapping position, optionally the first entry of a list item (`- template:`).
        if ($line -notmatch '^\s*(?:-\s*)?template:\s*(.+?)\s*$') {
            continue
        }
        $value = $matches[1].Trim().Trim('"', "'")

        # Skip template expressions / runtime variables — their target is not a static path.
        if ($value -match '\$\{\{' -or $value -match '\$\(') {
            continue
        }
        # Only actual template file paths (.yaml); anything else is not a reference we validate.
        if ($value -notmatch '\.yaml$') {
            continue
        }
        $refs.Add($value)
    }
    $refs.ToArray()
}
