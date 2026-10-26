# .ado/pipelines/stages/deploy-unit.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `parameters:`, written with `#`.

```text
The one deploy path of a unit, shared by its CD and its DEPLOY pipeline (FDR-CD-TYPE-ONEDEPLOYPATH): foundation, then discovery, then
expedition, each stage emitted only when its list is non-empty. A list entry is { env, slot?, serviceConnection, subscriptionIdAssertIs,
adoEnvironment? }; the ADO environment defaults to <Unit>-<env>[-<slot>]. CD passes no RunId (this run's artifacts); DEPLOY passes the
certifying CD's pipeline and run id.
```
