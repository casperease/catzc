<#
.SYNOPSIS
    Publishes the Claude Code Bash time-safeguard hook (a small C# program) when its source has changed.
.DESCRIPTION
    The hook (.claude/hooks/Assert-BashTimeout/) runs before every Bash call an agent makes and denies a call that...
    [ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md#comment1)
.PARAMETER OutputDirectory
    Where to publish the hook. Defaults to .claude/hooks/bin/ — the path .claude/settings.json runs it from.
.PARAMETER Force
    Publish even when the source hash recorded at the last publish matches.
.OUTPUTS
    [string] The published program's path.
.EXAMPLE
    Build-BashTimeoutHook
.EXAMPLE
    Build-BashTimeoutHook -Force
#>
function Build-BashTimeoutHook {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $OutputDirectory = (Join-Path (Get-RepositoryRoot) '.claude/hooks/bin'),
        [switch] $Force
    )

    Assert-SourceTree

    $project = Join-Path (Get-RepositoryRoot) '.claude/hooks/Assert-BashTimeout'
    Assert-PathExist $project -PathType Container

    $csproj = Join-Path $project 'Assert-BashTimeout.csproj'
    Assert-PathExist $csproj
    $projectXml = [xml](Get-Content -LiteralPath $csproj -Raw)

    # The sources are this folder's *.cs/*.csproj plus every linked <Compile Include> (the module types the hook...
    # [comment:2](/docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md#comment2)
    $sources = @(Get-ChildItem -LiteralPath $project -File | Where-Object Extension -In '.cs', '.csproj' | Sort-Object Name)
    Assert-True ($sources.Count -gt 0) -ErrorText "No hook files (*.cs, *.csproj) in $project"
    $linked = @($projectXml.SelectNodes('//Compile/@Include') | ForEach-Object Value | Sort-Object)
    $hashLines = @($sources | ForEach-Object { "$($_.Name):$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)" })
    foreach ($include in $linked) {
        $linkedPath = Join-Path $project $include
        Assert-PathExist $linkedPath -PathType Leaf
        $hashLines += "$($include):$((Get-FileHash -LiteralPath $linkedPath -Algorithm SHA256).Hash)"
    }
    $sourceHash = $hashLines -join "`n"

    # The program's name is the project's AssemblyName — the one place it is set.
    # [comment:3](/docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md#comment3)
    $assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ } | Select-Object -First 1
    Assert-NotNullOrWhitespace $assemblyName -ErrorText "No <AssemblyName> in $csproj — it names the published hook program."
    $programBase = Join-Path $OutputDirectory $assemblyName
    $findProgram = {
        $application = Get-Command -Name $programBase -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        if ($application) {
            $application.Source
        }
    }

    $stamp = Join-Path $OutputDirectory 'source.sha256'
    $program = & $findProgram
    $isCurrent = $program -and (Test-Path -LiteralPath $stamp) -and ((Get-Content -LiteralPath $stamp -Raw).Trim() -ceq $sourceHash.Trim())
    if ($isCurrent -and -not $Force) {
        return $program
    }

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Build-BashTimeoutHook.'
    }

    # --disable-build-servers: no MSBuild node or compiler server outlives the publish.
    # [comment:4](/docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md#comment4)
    Invoke-Executable "dotnet publish `"$csproj`" --configuration Release --output `"$OutputDirectory`" --verbosity quiet --disable-build-servers" -Silent
    $program = & $findProgram
    Assert-NotNullOrWhitespace $program -ErrorText "dotnet publish succeeded but produced no runnable '$assemblyName' program in $OutputDirectory."
    Set-Content -LiteralPath $stamp -Value $sourceHash -NoNewline
    Write-Message "Agent hook: published the Bash time safeguard to $program"

    $program
}
