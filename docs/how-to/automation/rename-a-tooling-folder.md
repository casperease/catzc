# Rename a folder or command the tooling names

Some names are read on every import: a module's command that `rootconfig.yml` names as a generator, a folder `Get-LanguageTestFolders`
walks, a function the `.internal` loaders call. Renaming one of them is safe only as one change: every reader moves with the name, and a
fresh full import proves the result before anything else runs. A half-renamed tree breaks the import of every session that opens on it, so
the rename is prepared first, applied in one burst, and rolled back whole when the import fails. Each name follows its language's idiom
([idiomatic-names](../../adr/automation/idiomatic-names.md)), and the old name is gone afterwards, with no alias kept
([one-living-version](../../adr/principles/one-living-version.md)).

## Prepare

1. List every tracked file that names the old spelling: `git grep -l '<old name>'`, leaving out the logs under `.claude/learnings/` and
   `.claude/hindsight/`, which record history. For a folder or file the quality gate `Test-IdiomaticNames` reports,
   `Repair-IdiomaticNames -DryRun` gives the target and the files that name the old path.
2. Mark which of those files the import reads: `rootconfig.yml`, the generator switch in `Invoke-RootConfigGenerator`, the `.internal`
   modules, any `configs/*.yml` a janitor loads. They decide the burst; the rest can follow it.
3. Check that the old spelling is never a substring of a name that must stay, such as an environment variable or a third-party command, so
   each file's edit replaces exactly the names it should.

## Apply in one burst

1. Move the files on disk: the command's file, its test file and its reference pages, or the folder.
2. Edit every listed file, one file at a time, replacing the old spelling with the new.
3. Run one fresh full import, `. ./importer.ps1` in a new `pwsh -NoProfile`, before any other command, then the renamed command's tests.

## Roll back whole

When the import fails, restore every import-path file from HEAD in the same call (`git show HEAD:<path>`), so no session meets the broken
state, then find the cause before trying again. A rename that only changes letter case moves on disk with no change git sees on a
case-insensitive checkout: the commit records it with `git mv`, and the tests that read the git index see the new spelling only after that
commit.
