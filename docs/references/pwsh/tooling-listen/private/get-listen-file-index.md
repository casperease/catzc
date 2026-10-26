# pwsh/Tooling.Listen/private/Get-ListenFileIndex.ps1

A private helper of the listen module that builds a session's file index: every file under the watched folder, keyed by repository-relative
path and carrying its length, last-write ticks and content hash.

## help

### synopsis

Indexes every file under a folder: repository-relative path to length, last-write ticks and content hash.

### description

The folder is walked to depth 64 with nothing pruned, the vendor folder included, and every file is hashed (DurableHash). The keys are in
ordinal order.

### parameter `Root`

The folder to index.

### parameter `Prefix`

The repository-relative path the folder stands for (e.g. 'docs'), prepended to every key.

### outputs

`[System.Collections.Generic.SortedDictionary[string, object]]` path to an ordered { length, ticks, hash }.
