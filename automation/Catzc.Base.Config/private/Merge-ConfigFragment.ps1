<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/private/Merge-ConfigFragment.ps1
    folder: private
    name: merge-config-fragment
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Config/tests/Merge-ConfigFragment.Tests.ps1
    cites:
      - ADR-AUTO-OVERLAY
  config:
    synopsis: Merges a consumer overlay's config fragment onto a bundled config, key by key.
    description: |-
      A fragment states only the keys that differ ([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)):
        - a map merges into the bundled map recursively;
        - a scalar or a list replaces the bundled value (a list is never appended to, so the result is predictable);
        - an explicit null removes the key, so the config type's declared default applies.
      A key the fragment does not name keeps the bundled value. Neither input is changed; the result is a new
      ordered dictionary, which the config's own type then validates like any parsed config.
    parameters:
      Base: The parsed bundled config.
      Fragment: The parsed overlay fragment.
---
#>

function Merge-ConfigFragment {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Base,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Fragment
    )

    $merged = [ordered]@{}
    foreach ($key in $Base.Keys) {
        $merged[$key] = $Base[$key]
    }
    foreach ($key in $Fragment.Keys) {
        $value = $Fragment[$key]
        if ($null -eq $value) {
            $merged.Remove($key)
        }
        elseif ($value -is [System.Collections.IDictionary] -and $merged[$key] -is [System.Collections.IDictionary]) {
            $merged[$key] = Merge-ConfigFragment -Base $merged[$key] -Fragment $value
        }
        else {
            $merged[$key] = $value
        }
    }
    $merged
}
