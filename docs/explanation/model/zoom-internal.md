# Zooming in on pwsh/.internal: the internal modules and their files

```text
The internal folder at C3 and C4: its modules, and its tracked files, both drawn from the tree at every build.

C3  components   the internal modules the importer loads before any catzc module
C4  code         every tracked file of the folder but its tests

Supports DDR-VISUAL-ZOOMISANAXIS, ADR-PWSH-ENGINE-IMPORTERDOTSOURCED and ADR-REPO-LINKS-EVERYLINKHASADIRECTION.
```

The third ladder stands at `pwsh/.internal/`, the infrastructure that loads every module of the [pwsh ladder](zoom-pwsh.md).

## C3: the internal modules

![The internal modules of pwsh/.internal](.assets/zoom-internal-c3.drawio.png)

The importer, always dot-sourced
([ADR-PWSH-ENGINE-IMPORTERDOTSOURCED](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-importerdotsourced)), loads these
modules first. No dependency query covers them, so the slide draws the modules alone, read from the folder.

## C4: the tracked files

![The internal folder's tracked files](.assets/zoom-internal-c4.drawio.png)

This slide is drawn from the git index and `Get-LinkEdge` at every build: one glyph per tracked file, its tests left out and a build's
output beside the sources never drawn. A file linked to another file of the folder carries a chip counting those links; no file here links
to another today, so the slide draws none
([ADR-REPO-LINKS-EVERYLINKHASADIRECTION](../../drs/repository/links-in-repository.md#rule-adr-repo-links-everylinkhasadirection)).
