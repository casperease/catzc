<#
---
catzc:
  immutable:
    with_body_sha: "8ca3122d80e2"
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Build-AgentHook.Tests.ps1
    docs: "[Build-AgentHook.ps1.md](../../docs/references/pwsh/catzc-base-types-system/Build-AgentHook.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - ADR-REPO-AI-EDITORISFACT
      - DDR-RUNMODE
---
#>

function Build-AgentHook {
    <#
    .SYNOPSIS
        Publishes the Claude Code agent hooks (small C# programs under .claude/hooks/) whose source has changed.

    .DESCRIPTION
        Each folder under .claude/hooks/ that holds a .csproj is one hook: Assert-BashTimeout runs before every Bash call an agent makes
        and denies a call that does not run inside the safeguard
        ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait));
        Record-AgentWrite records what an agent session writes, so the listen mode tells it from the editor's changes
        ([ADR-REPO-AI-EDITORISFACT](/docs/drs/repository/ai-agent-contract.md#rule-adr-repo-ai-editorisfact)). A hook is
        a compiled
        program rather than a script because it runs that often: it starts in about a third of the time pwsh does. This publishes each,
        framework-dependent, to .claude/hooks/bin/ (gitignored), and records a hash of its sources beside it as <AssemblyName>.source.sha256;
        while the hash matches and the program is present, it does nothing, so the importer can run it on every import.

        dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper lives in the Tooling layer, which this Base module
        must not depend on, so dotnet must be on PATH. The hooks' C# code lives in the source tree, so it stops with a named error in build
        mode (Assert-SourceTree, [DDR-RUNMODE](/docs/drs/design/run-modes.md)).

    .PARAMETER Name
        The hooks to publish, by folder name. Default: every hook folder under .claude/hooks/.

    .PARAMETER OutputDirectory
        Where to publish the hooks. Defaults to .claude/hooks/bin/ — the path .claude/settings.json runs them from.

    .PARAMETER Force
        Publish even when the source hash recorded at the last publish matches.

    .OUTPUTS
        [string] Each published program's path, in folder-name order.

    .EXAMPLE
        Build-AgentHook

    .EXAMPLE
        Build-AgentHook -Name Assert-BashTimeout -Force
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name = (Get-AgentHookName),

        [string] $OutputDirectory = (Join-Path (Get-RepositoryRoot) '.claude/hooks/bin'),

        [switch] $Force
    )

    Assert-SourceTree

    $hooks = Join-Path (Get-RepositoryRoot) '.claude/hooks'

    foreach ($hook in $Name) {
        $project = Join-Path $hooks $hook
        Assert-PathExist $project -PathType Container

        $csproj = Join-Path $project "$hook.csproj"
        Assert-PathExist $csproj
        $projectXml = [xml](Get-Content -LiteralPath $csproj -Raw)

        $sources = @(Get-ChildPath $project -File -Filter '*.cs', '*.csproj' -Depth 1 | Sort-Object { [System.IO.Path]::GetFileName($_) })
        Assert-True ($sources.Count -gt 0) -ErrorText "No hook files (*.cs, *.csproj) in $project"
        $modulesFolder = Get-CatzcModulesFolder
        $linked = @($projectXml.SelectNodes('//Compile/@Include') | ForEach-Object { $_.Value.Replace('$(CatzcModulesFolder)', $modulesFolder) } | Sort-Object)
        $hashLines = @($sources | ForEach-Object { "$([System.IO.Path]::GetFileName($_)):$((Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash)" })
        foreach ($include in $linked) {
            $linkedPath = Join-Path $project $include
            Assert-PathExist $linkedPath -PathType Leaf
            $hashLines += "$($include):$((Get-FileHash -LiteralPath $linkedPath -Algorithm SHA256).Hash)"
        }
        $sourceHash = $hashLines -join "`n"

        $assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object { $_ } | Select-Object -First 1
        Assert-NotNullOrWhitespace $assemblyName -ErrorText "No <AssemblyName> in $csproj — it names the published hook program."
        $programBase = Join-Path $OutputDirectory $assemblyName
        $findProgram = {
            $application = Get-Command -Name $programBase -CommandType Application -ErrorAction Ignore | Select-Object -First 1
            if ($application) {
                $application.Source
            }
        }

        $stamp = Join-Path $OutputDirectory "$assemblyName.source.sha256"
        $program = & $findProgram
        $isCurrent = $program -and (Test-Path -LiteralPath $stamp) -and ((Get-Content -LiteralPath $stamp -Raw).Trim() -ceq $sourceHash.Trim())
        if ($isCurrent -and -not $Force) {
            $program
            continue
        }

        if (-not (Test-Command 'dotnet')) {
            throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Build-AgentHook.'
        }

        $configuration = (Get-Config -Config bcl).configuration
        Invoke-Executable "dotnet publish `"$csproj`" --configuration $configuration --output `"$OutputDirectory`" --verbosity quiet --disable-build-servers -p:CatzcModulesFolder=$modulesFolder" -Silent
        $program = & $findProgram
        Assert-NotNullOrWhitespace $program -ErrorText "dotnet publish succeeded but produced no runnable '$assemblyName' program in $OutputDirectory."
        Set-Content -LiteralPath $stamp -Value $sourceHash -NoNewline
        Write-Message "Agent hook: published $assemblyName to $program"

        $program
    }
}
