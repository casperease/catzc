# pwsh/Azure.DevOps/configs/service-connections.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `connections:`, written with `#`.

```text
The Azure service connections of the project, one per subscription: each authenticates by workload identity federation, the one scheme
the config type knows, so no connection can hold a stored secret. Sync-AdoServiceConnections applies this file to Azure DevOps.
```
