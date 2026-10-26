# pwsh/Azure.Templates/Get-BicepTrackTagNameSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
