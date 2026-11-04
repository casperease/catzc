# pwsh/Base.QualityGates/private/Assert-BuiltBundleStore.ps1

Fails fast when the build store lacks the build of a declared bundle at the tree's source stamp. It is the check that comes before the
post-build run's discovery.

## help

### synopsis

Throws, naming the missing bundles and the build event to run, when the build store holds no build of a declared bundle at this tree's
source stamp.

### description

The post-build run tests the built bundles in the build store
([ADR-AUTO-TEST-POSTBUILDTAG](../../../../drs/automation/test-automation.md#rule-adr-auto-test-postbuildtag)). For every bundle exporter.yml
declares, this asks Build-Modules for a dry run, which reports the source stamp of the tree and the store build root a build of that bundle
fills, and reads the `build.json` there. A bundle counts as built when the record parses and its `sourceStamp` equals the tree's. It builds
nothing: a missing bundle is named with its build event command (`Build-Modules -Bundle <name>`), all of them in one message. In CI the
store is the downloaded artifact of the build job, so the check passes without building.

### outputs

None. It returns when every declared bundle is stored, and throws otherwise.
