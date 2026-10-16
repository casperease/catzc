---
catzc:
  immutable:
    with_body_sha: "3c8efece77ee"
    path: docs/references/automation/catzc-azure-firewall/Get-FirewallCsv.ps1.md
    folder: docs/references/automation/catzc-azure-firewall
    name: get-firewall-csv-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Firewall/Get-FirewallCsv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$DownloadPath =...`, written with `#`.

```text
Pin to absolute: Invoke-Executable runs az from the repo root, so a relative --file would resolve
there while New-Item resolves against $PWD. Make them agree before anyone touches the path.
```

## comment:2

Above `$common = "--subscription $SubscriptionId --account-name $StorageAccountName...`, written with `#`.

```text
Shared args, as a string for Invoke-AzCli. Sub/account/container are token-safe (no spaces).
--auth-mode login: ride the AAD session asserted above rather than fetching an account key.
```

## comment:3

Above `$cli = Invoke-AzCli "storage blob list $common --num-results * -o json"...`, written with `#`.

```text
--num-results *: list order is lexicographic by name, not by date — and the dd-MM-yyyy names
don't sort chronologically — so fetch every blob and let the filename-timestamp sort below decide.
-Silent here only: this is a data read (-o json, parsed below), not an action. Without it the
entire listing echoes to the console. The download call stays loud — that one is a real action.
```

## comment:4

Above ``Invoke-AzCli "storage blob download $common --name `"$blobName`" --file...``, written with `#`.

```text
Quote --name and --file: blob names and the repo path may contain spaces.
-o none keeps az quiet; stream mode doesn't leak to the pipeline, so no Out-Null needed.
```

## comment:5

Above `Assert-PathExist $destination -PathType Leaf -ErrorText "Blob '$blobName'...`, written with `#`.

```text
az can exit 0 yet leave no file (e.g. a silent partial). Confirm the download landed before
emitting an object that claims this Path, so a downstream consumer never trusts a missing file.
```
