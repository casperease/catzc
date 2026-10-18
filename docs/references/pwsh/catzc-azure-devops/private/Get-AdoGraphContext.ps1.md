# automation/Catzc.Azure.DevOps/private/Get-AdoGraphContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names the project's REST base, the organization's Graph service and the project's Graph descriptor, for the environment-approvals apply.

### description

The Graph service (groups, memberships, users) lives on `vssps.dev.azure.com`, beside the organization's `dev.azure.com` REST API, and a
project group is created under the project's Graph descriptor. This reads the project's id, then that descriptor, and returns both bases
with the descriptor, so each step of `Sync-AdoEnvironmentApprovals` builds its URLs from one record. An organization URL that is not
`https://dev.azure.com/<org>` throws, since its Graph service cannot be named.

### parameter `Project`

The Azure DevOps project name.

### parameter `Organization`

The organization URL, `https://dev.azure.com/<org>`.

### outputs

`[pscustomobject]` { Organization; Project; ApiBase; GraphBase; ScopeDescriptor }.

### example 1

```powershell
Get-AdoGraphContext -Project 'Gadget' -Organization 'https://dev.azure.com/widgetorg'
```
