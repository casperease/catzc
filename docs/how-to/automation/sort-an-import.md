---
catzc:
  immutable:
    repo_status: clean
    path: docs/how-to/automation/sort-an-import.md
    folder: docs/how-to/automation
    name: sort-an-import
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-DSGN-TRACK#17
    links:
      - docs/adr/design/tracks.md#rule-adr-dsgn-track17
---

# Sort an import into the modules

An **import** brings an outside repository into this one with its full history, at a **landing address** under the unordered track
([ADR-DSGN-TRACK#17](../../adr/design/tracks.md#rule-adr-dsgn-track17)). **Sorting** moves its files, one file or folder at a time, to the
module or track where each belongs. This guide covers both.

## Import the repository

1. Commit or discard every change in the source repository; a source with uncommitted changes is refused.
2. Make sure nothing is staged in this repository; the import commit would carry it.
3. Check the landing address first:

   ```powershell
   Import-RepositoryWithHistory -Source C:\projects\widget-tools -DryRun
   ```

   The landing name is the source's folder or repository name in kebab case. Pass `-Name` for another short kebab word, and `-Ref` for a
   ref other than the source's default branch. A name that is taken fails; no suffix is ever added.

4. Run the same command without `-DryRun`. One merge commit joins the source's history to this repository's, and the files land under
   `.unordered/<name>/`; nothing outside the address changes.

## Sort the files

Move one file or one folder per step, then run the gates that hold the place it moved to before the next move:

1. Pick the destination: the module or track whose tech-stack the file belongs to. A file that fits no track stays where it is.
2. Move it with `git mv`, so `git log --follow` keeps its history:

   ```powershell
   git mv .unordered/widget-tools/Spin-Widget.ps1 automation/Catzc.Widget/Spin-Widget.ps1
   ```

3. Bring the file to the domain rules of its new place: its head, its tests, its links. Run that module's tests and the gates for its file
   kind, and fix what they report before the next move.

## What stays

Whatever is still under `.unordered/` is the work left to sort. Nothing reads from it or depends on it, so a half-sorted import never
breaks the system. When a landing address is empty, remove its folder.
