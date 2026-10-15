<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-AGENTS
      - ADR-REPO-AGENTS#1
      - ADR-REPO-AGENTS#2
      - ADR-REPO-AGENTS#3
      - ADR-REPO-AGENTS#4
---
#>

<#
.SYNOPSIS
    Quality gate: the sub-agent definitions, their registry (agents.yml), and the .claude/CLAUDE.md list agree.
.DESCRIPTION
    AgentsConfig already rules on spelling and distinct names, so this gate checks only agreement across the files.
    [comment:1](/docs/references/automation/catzc-base-docs/Test-AgentDefinitions.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-agent-definitions/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Agents; Files }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-AgentDefinitions
#>
function Test-AgentDefinitions {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $config = Get-Config -Config agents
    $agentsRoot = Resolve-RepoPath '.claude/agents'
    $claudeMd = Resolve-RepoPath '.claude/CLAUDE.md'
    $issues = [System.Collections.Generic.List[string]]::new()

    $entries = [ordered]@{}
    foreach ($entry in $config.agents) {
        $entries[$entry.name] = $entry
    }

    # The agent files, by name, and the descriptions the standard-agent check reads.
    $files = @(if ([System.IO.Directory]::Exists($agentsRoot)) {
            [System.IO.Directory]::GetFiles($agentsRoot, '*.md') | Sort-Object
        })
    $descriptions = @{}
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $relative = ".claude/agents/$name.md"
        if (-not $entries.Contains($name)) {
            $issues.Add("${relative}: has no entry in agents.yml")
        }
        try {
            $frontMatter = Get-AgentFrontMatter -Path $file
        }
        catch {
            $issues.Add("${relative}: $($_.Exception.Message)")
            continue
        }
        $declared = if ($frontMatter.Contains('name')) {
            [string]$frontMatter['name']
        }
        if ($declared -cne $name) {
            $issues.Add("${relative}: front-matter name '$declared' must equal the file name '$name'")
        }
        $description = if ($frontMatter.Contains('description')) {
            [string]$frontMatter['description']
        }
        if ([string]::IsNullOrWhiteSpace($description)) {
            $issues.Add("${relative}: front matter has no description")
        }
        else {
            $descriptions[$name] = $description
            if (-not $description.Contains('Do NOT')) {
                $issues.Add("${relative}: description has no 'Do NOT' clause saying when not to use the agent")
            }
        }
        if (-not $frontMatter.Contains('tools') -or [string]::IsNullOrWhiteSpace([string]$frontMatter['tools'])) {
            $issues.Add("${relative}: front matter has no tools")
        }
    }

    $fileNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        [void]$fileNames.Add([System.IO.Path]::GetFileNameWithoutExtension($file))
    }
    # Get-CatsAdrRuleIds returns its array as one object (`, $ret`); the assignment takes that array as is.
    [string[]] $ruleIdList = Get-CatsAdrRuleIds
    $ruleIds = [System.Collections.Generic.HashSet[string]]::new($ruleIdList, [System.StringComparer]::Ordinal)
    foreach ($entry in $config.agents) {
        if (-not $fileNames.Contains($entry.name)) {
            $issues.Add("agents.yml: agent '$($entry.name)' has no file .claude/agents/$($entry.name).md")
        }
        foreach ($citation in $entry.supported_by) {
            if (-not $ruleIds.Contains($citation.Replace('#', ':'))) {
                $issues.Add("agents.yml: agent '$($entry.name)' supported_by '$citation' names no ADR rule")
            }
        }
        foreach ($check in $entry.checks) {
            if (-not (Get-Command -Name $check -ErrorAction Ignore)) {
                $issues.Add("agents.yml: agent '$($entry.name)' checks '$check' names no command")
            }
        }
    }

    $listed = @(Get-ClaudeMdAgentNames -Path $claudeMd)
    foreach ($name in $entries.Keys) {
        if ($listed -cnotcontains $name) {
            $issues.Add(".claude/CLAUDE.md: the Sub-agents section does not list registered agent '$name'")
        }
    }
    foreach ($name in $listed) {
        if (-not $entries.Contains($name)) {
            $issues.Add(".claude/CLAUDE.md: the Sub-agents section lists '$name', which agents.yml does not register")
        }
    }

    if ($descriptions.ContainsKey($config.standard)) {
        foreach ($name in $entries.Keys) {
            if ($name -cne $config.standard -and -not $descriptions[$config.standard].Contains($name)) {
                $issues.Add(".claude/agents/$($config.standard).md: the standard agent's description does not name specialised agent '$name'")
            }
        }
    }

    Write-QualityGateReport -Subject 'agent-definitions' -Title 'Test-AgentDefinitions' -Issues $issues `
        -Facts ([ordered]@{ Agents = $entries.Count; Files = $files.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
