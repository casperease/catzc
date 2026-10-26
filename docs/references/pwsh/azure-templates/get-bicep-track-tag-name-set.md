# pwsh/Azure.Templates/Get-BicepTrackTagNameSet.ps1

The function that returns the Azure tag names used to record what was last deployed.

## help

### synopsis

Returns the Azure tag _names_ used to record what was last deployed.

### description

For ResourceGroup-target templates the tags live on the RG and have generic names (`Deployed_From_Commit`, etc.) — every template that
deploys into that RG writes the same three tags.

For Subscription-target templates the tags live on the subscription itself, so they are prefixed with the template name to avoid collisions
across templates.

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
