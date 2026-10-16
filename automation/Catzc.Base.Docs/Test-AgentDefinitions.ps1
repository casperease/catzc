<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Test-AgentDefinitions.ps1
    kind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Docs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-AGENTS
  config:
    synopsis: 'Quality gate: the sub-agent definitions, their registry (agents.yml), and the .claude/CLAUDE.md list agree.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
      sub-agent definitions .claude/agents/*.md, the registry (Get-Config -Config agents, an AgentsConfig), and the
      `## Sub-agents` section of .claude/CLAUDE.md
      ([ADR-REPO-AGENTS](/docs/adr/repository/agent-definitions.md)). It collects an issue when:

        - an agent file has no registry entry, or an entry has no agent file;
        - a file's front matter does not parse, its `name` differs from the file name, or it lacks a `description`,
          a `Do NOT` clause in that description, or `tools`
          ([ADR-REPO-AGENTS#1](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents1));
        - a `supported_by` citation names no rule (Get-CatsAdrRuleIds), or a `checks` entry names no command
          ([ADR-REPO-AGENTS#2](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents2));
        - a registered agent is not listed in the CLAUDE.md section, or a listed agent is not registered
          ([ADR-REPO-AGENTS#3](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents3));
        - a specialised agent is not named in the standard agent's description
          ([ADR-REPO-AGENTS#4](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents4)).

      The registry's own shape (citation and command spelling, distinct names, a standard that names an entry) is an
      AgentsConfig construction rule, not this gate's.
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-agent-definitions/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Agents; Files }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-AgentDefinitions
---
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
