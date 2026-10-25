<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Get-EngineStripMinimapData.ps1.md"
  warning: "Generated Header"
---
#>

function Get-EngineStripMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [System.Collections.IDictionary] $Facts,

        [switch] $AsJson
    )

    # Each execution engine beside the file languages it runs: a language whose extensions include one of the engine's script extensions.
    $languages = @(Get-FileLanguage)
    $cells = [System.Collections.Generic.List[string[]]]::new()
    $runs = @{}
    foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
        foreach ($language in $languages) {
            if (@($language.extensions | Where-Object { $engine.ScriptExtensions -contains $_ }).Count -gt 0) {
                $cells.Add([string[]] @($engine.Name, $language.name))
                if (-not $runs.ContainsKey($language.name)) {
                    $runs[$language.name] = [System.Collections.Generic.List[string]]::new()
                }
                $runs[$language.name].Add($engine.Name)
            }
        }
    }
    $count = @{}
    $reasons = @{}
    foreach ($item in @(Get-MinimapSubject -Adr $Adr -WorldMap $WorldMap -Facts $Facts)) {
        $language = if ($item.Facts) {
            "$($item.Facts['language'])"
        }
        if (-not $language -or -not $runs.ContainsKey($language)) {
            continue
        }
        $module = if ($item.Facts['module']) {
            "$($item.Facts['module'])"
        }
        else {
            $null
        }
        foreach ($engineName in @($runs[$language])) {
            $reason = [Catzc.Base.Maps.MinimapReason]::new($item.Path, 'runs-on', $item.Requested, $module)
            Add-MinimapHit -Count $count -Reasons $reasons -At @($engineName, $language) -Reason $reason
        }
    }
    $axes = [ordered]@{
        engine        = [string[]] @([Catzc.Base.Engines.ExecutionEngines]::Names)
        file_language = [string[]] @($cells | ForEach-Object { $_[1] } | Select-Object -Unique)
    }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::EngineStrip) -Axes $axes -Cells ([string[][]] $cells.ToArray()) -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
