# pwsh/Azure.Firewall/Get-FirewallCsv.ps1

The command that downloads the newest firewall-rule CSV from a blob container, one per requested rule type, and emits a CSV export
reference for each.

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

## The download path

The download path is pinned to an absolute path. `Invoke-Executable` runs az from the repository root, so a relative `--file` would resolve
there while `New-Item` resolves against `$PWD`; pinning makes the two agree.

## Shared arguments

The arguments common to the list and download calls are one string for `Invoke-AzCli`. The subscription, account and container hold no
spaces. `--auth-mode login` rides the Entra session already asserted, so no account key is ever fetched.

## Picking the newest blob

The listing passes `--num-results *`. List order is lexicographic by name, not by date, and the `dd-MM-yyyy` names do not sort
chronologically, so every blob is listed and the newest is picked from the timestamp in each name. The listing passes `-Silent` because it
is a data read, parsed by the function, and would otherwise echo the whole listing to the console. The download stays loud because it is a
real action.

## The download

`--name` and `--file` are quoted, because the blob name and the repository path may hold spaces. `-o none` keeps az quiet, and its stream
mode does not leak to the pipeline, so no `Out-Null` is needed.

az can exit 0 yet leave no file, for example after a silent partial download. The function confirms the file landed before it emits an
object that claims that path, so a downstream consumer never trusts a missing file.
