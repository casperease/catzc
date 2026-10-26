# pwsh/Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1

The tests of `Get-GlobSetChangeRange`, the reference-commit resolver ([FDR-CD-DETECT](../../../../drs/flow/pipeline-detection.md)).

## What it proves

The diff range follows the execution context: the local working tree, the post-commit first-parent range (squash-proof), or the pull request
merge-base. A context whose range cannot be resolved returns null, the fail-open signal.
