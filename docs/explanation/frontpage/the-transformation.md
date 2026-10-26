# The transformation

| Before                                   | With cats                                              |
| ---------------------------------------- | ------------------------------------------------------ |
| ~~A CMDB kept in parity by hand~~        | **The repository is the record**                       |
| ~~Wiki pages that drift from what runs~~ | **Docs and READMEs generated from one source**         |
| ~~Manual checklists before release~~     | **Gates and asserts that fail fast**                   |
| ~~Approvals in a separate system~~       | **Approvals as config, driven one way from the trunk** |
| ~~Audit spreadsheets~~                   | **Git history, read through the query surface**        |
| ~~"Works on my machine"~~                | **Devbox and pipeline run the same commands**          |
| ~~Internal version matrices~~            | **Everything at HEAD; versions only at the boundary**  |

Service management follows delivery, never the reverse: a change record is the commit and its review
([processes follow delivery](../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-processesfollowdelivery)).
