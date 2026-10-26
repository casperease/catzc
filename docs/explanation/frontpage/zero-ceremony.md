# Zero ceremony, hard to fail

**Drop a file, get a command.** No manifests, no installers, no registration: a folder is a module, a file is a function, and its location
decides whether it is public. Every choice is judged against two questions — _does this add ceremony?_ and _can the author get this wrong?_
([zero ceremony, hard to fail](../../drs/automation/zero-ceremony-poka-yoke.md)).

Self-contained by design: vendored dependencies, no network calls at import, the same commands on a devbox and in a pipeline
([the devbox and the pipeline are one environment](../../drs/automation/devbox-pipeline-parity.md)).
