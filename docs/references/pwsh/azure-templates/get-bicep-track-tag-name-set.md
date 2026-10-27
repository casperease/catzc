# pwsh/Azure.Templates/Get-BicepTrackTagNameSet.ps1

The function that returns the Azure tag names used to record what was last deployed.

## help

### synopsis

Returns the Azure tag _names_ used to record what was last deployed.

### description

The names are the `tags.provenance` entries of `azure.yml`, lowercase (`deployed-from-commit`, etc.). For ResourceGroup-target templates the
tags live on the RG and carry those names as they are — every template that deploys into that RG writes the same three tags.

For Subscription-target templates the tags live on the subscription itself, so they are prefixed with the lowercase template name and a
hyphen (`discovery-deployed-from-commit`) to avoid collisions across templates.

Returned shape:

```text
{ commit, build_id, branch }
```

### parameter `Template`

Template name.

### example 1

```powershell
Get-BicepTrackTagNameSet sample
```
