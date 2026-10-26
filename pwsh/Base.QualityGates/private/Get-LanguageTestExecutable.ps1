<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestExecutable.ps1.md"
  header: "generated"
---
#>

function Get-LanguageTestExecutable {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $languages = @(Get-LanguageTestFolders | ForEach-Object Language | Select-Object -Unique)
    $toolLanguages = @((Get-Config -Config languages).languages | Where-Object { $_.tests -and -not $_.tests.engine })
    $executables = @{}
    foreach ($language in $toolLanguages) {
        $executables[$language.name] = ''
    }
    $pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name
    foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
        if ($engine.Name -eq $pwsh) {
            continue
        }
        $executables[$engine.Name] = ''
        if ($languages.Count -gt 0) {
            try {
                $executables[$engine.Name] = "$(Resolve-EngineExecutable -Engine $engine.Name)"
            }
            catch {
                Write-Verbose "The $($engine.Name) engine is not available, so the tests' $($engine.Name) runs skip: $($_.Exception.Message)"
            }
        }
    }
    foreach ($language in $toolLanguages) {
        if ($language.name -notin $languages) {
            continue
        }
        $resolved = @(foreach ($tool in $language.tests.tools) {
                Resolve-ToolExecutable -Tool $tool
            })
        if (@($resolved | Where-Object { -not ($_.Found -and $_.VersionOk) }).Count -eq 0) {
            $executables[$language.name] = $resolved[0].Path
        }
    }
    $executables
}
