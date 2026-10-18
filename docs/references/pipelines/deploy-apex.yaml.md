# pipelines/deploy-apex.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `- ${{ if eq(parameters.Target, 'release-uat') }}:`, written with `#`.

```text
release-uat is test; the RC approval check on apex-release-uat holds the job for its certifier
([ADR-FLOW-CD-TWORELEASEGATES](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-tworeleasegates)).
```

## comment:2

Above `- ${{ if eq(parameters.Target, 'prod') }}:`, written with `#`.

```text
Stage the exact artifact in pre-prod, the inactive slot of prod, then activate it to prod
([ADR-FLOW-CD-TWOENVIRONMENTACTIVATION](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-twoenvironmentactivation)).
```
