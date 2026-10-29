# pwsh/Base.QualityGates/private/Get-PlanHeadIssue.ps1

A private helper of the plans quality gate. It reads the `plan:` block of one plan's head and names every way it breaks the plan keys of the
plans config.

## help

### synopsis

Names each issue of a plan head's `plan:` block, one string per issue.

### description

A head with no `plan:` block yields that one issue and nothing else. Otherwise each required key the block misses, each key outside the
required and allowed keys, a `status` outside the configured statuses, a `blocked` plan that names neither `blocked_on` nor `waits_on`, a
`value` outside the ranks, and each `targets` path the repository does not hold is one issue. A clean head yields nothing.

Private helper of the plans quality gate; not exported.

### parameter `FrontMatter`

The plan's parsed front matter, or null when the plan has none.

### parameter `Config`

The plans config, which holds the required and allowed head keys, the statuses and the ranks.

### parameter `RepositoryRoot`

The root a `targets` path is resolved against.

### outputs

`[string]` One sentence per issue.

### example 1

```powershell
Get-PlanHeadIssue -FrontMatter $head -Config (Get-Config -Config plans) -RepositoryRoot (Get-RepositoryRoot)
```
