# infrastructure/templates/discovery/configuration/psub.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
discovery, shared prod subscription (env psub): the prod hub. The kind and the ranges come from network.yml
by config address; the hub peers to the prod spokes and links its private DNS zones to them.
```
