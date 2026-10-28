# pwsh/Base.Files/Get-GitBlobText.ps1

The command that reads committed file texts by blob id, every one in a single git process.

## help

### synopsis

Returns the texts of the given blobs as a map of blob id to text.

### description

Reads every blob not read before in one `git cat-file --batch` through Invoke-Executable, the ids on its standard input, inside git's time
limit. A fresh marker heads each object, since the decoded text cannot count git's byte sizes, and the marker itself is asked for last, so
its 'missing' answer closes the stream and no trim reaches the last text. The text is UTF-8, without a leading byte-order mark, as
[System.IO.File]::ReadAllText reads a file. Texts are cached under their blob id, which names its content, so a cached text is never stale.
An id the repository does not hold throws, and nothing of that call is cached.

### parameter `Blob`

The blob ids to read, such as the values Get-GitCommitTree returns.

### outputs

`[hashtable]`

### example 1

```powershell
$tree = Get-GitCommitTree
(Get-GitBlobText $tree['README.md'])[$tree['README.md']]
```

## comment:1

Above `$marker = "catzc-blob-$([guid]::NewGuid().ToString('N'))"`, written with `#`.

```text
One git process reads every missing blob. A fresh marker heads each object, since the decoded text cannot count
git's byte sizes; the marker asked for last comes back as missing, so no trim reaches the last blob's text.
```
