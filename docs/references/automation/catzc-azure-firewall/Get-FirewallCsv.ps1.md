# automation/Catzc.Azure.Firewall/Get-FirewallCsv.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Downloads the newest firewall-rule CSV(s) from a blob container — one per requested rule type.

### description

For each requested -Type (application and/or network), locates the newest matching `*.csv` in the container and downloads it to the output
root's download folder (overridable via -DownloadPath). Emits one flat object per type as a stream, so the default (both types) yields two
objects.

"Newest" is decided by the UTC timestamp embedded in the filename (e.g. ...-16-06-2026-10-32.csv), which is the source of truth for
generation time — not blob last-modified. A matching blob whose name carries no parseable timestamp is ignored; if none qualifies for a
type, the function throws.

Data-plane access goes through the az CLI with AAD auth (--auth-mode login), so no account key or resource group is required — the caller's
identity needs the 'Storage Blob Data Reader' role on the account (or container). The session is asserted onto the expected subscription
first via Assert-AzCliConnected, which fails fast with remediation if az is not logged in or set elsewhere.

Each emitted object — Type, Path, Generated (UTC), Blob, Modified — pipes straight into Convert-FirewallCsvToMarkdown.

### parameter `SubscriptionId`

The subscription GUID the az session must be set to. Asserted, not switched.

### parameter `StorageAccountName`

The storage account holding the exports.

### parameter `ContainerName`

The blob container within the account to search.

### parameter `DownloadPath`

Destination directory. Defaults to the download folder under the output root (Get-OutputRoot: `<repo>/out` locally, the artifact staging
directory in a pipeline). Created if absent.

### parameter `Type`

One or both rule types. Empty/omitted = both. The type word also serves as the name filter ('application' matches ...ApplicationRules...,
'network' matches ...NetworkRules...). Which rule type(s) to fetch: 'application', 'network', or both (the default when omitted). The type
word is also used as the case-insensitive name filter for selecting the blob.

### parameter `TimestampPattern`

Regex capturing the timestamp substring in the filename (UTC), the source of truth for generation time. Default
'\d{2}-\d{2}-\d{4}-\d{2}-\d{2}'.

### parameter `TimestampFormat`

.NET ParseExact format for the captured timestamp, interpreted as UTC. Default 'dd-MM-yyyy-HH-mm'.

### example 1

```powershell
Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports
```

### example 2

```powershell
Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports -Type application
```

### example 3

```powershell
Get-FirewallCsv -SubscriptionId $sub -StorageAccountName stfwexports -ContainerName rule-exports |
    Convert-FirewallCsvToMarkdown -OutputFolder .\docs
```

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
