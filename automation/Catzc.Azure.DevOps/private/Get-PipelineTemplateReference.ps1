<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1
    folder: private
    name: get-pipeline-template-reference
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1
    cites:
      - ADR-PIPE-NAME#4
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
