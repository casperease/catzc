// One managed root-file entry from configs/rootconfig.yml — a repository-root `target` fully managed by the
// source-of-truth automation. Exactly one of `source` (an authored file copied out) or `generator` (a function
// that renders the content, e.g. New-Importer) supplies the content. `optIn` (default false) activates the
// entry; `committed` (default false) keeps the managed target tracked in git instead of gitignored (for files
// git or the bootstrap reads before the importer runs). `comment` ('hash' or 'none', default 'none') picks the
// generated-file header style and is meaningful only for `source` entries — a generator owns its whole output,
// header included. Paths are repository-root-relative, '/'-separated communication-form values (see
// docs/adr/automation/path-representation.md). Mirrors a rootconfig.yml files entry (snake_case keys).
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's extraction helpers.

using System;
using System.Collections;

namespace Catzc.Base.RootConfig;

public sealed class RootConfigFile : Catzc.Base.Objects.DictionaryRecord
{
    // Repository-root-relative path of the managed file (e.g. ".editorconfig"). Required.
    public string target { get; }

    // Authored source file copied out to the target (repo-relative). Exactly one of source/generator.
    public string source { get; }

    // Name of the function that renders the target's full content (e.g. "New-Importer"). Exactly one of
    // source/generator.
    public string generator { get; }

    // Generated-file header style for source copy-ins: "hash" (# ... block) or "none". Default "none".
    public string comment { get; }

    // Is this file managed at all? Opt-out is the default: false leaves the target hand-authored and committed.
    public bool optIn { get; }

    // Keep the managed target tracked in git (true) instead of gitignored (false, the default). For files
    // needed before the importer runs (importer.ps1, the git files).
    public bool committed { get; }

    public RootConfigFile(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("RootConfigFile requires a dictionary"); }
        target = Req(d, "target");
        source = OptStr(d, "source");
        generator = OptStr(d, "generator");
        comment = OptStr(d, "comment") ?? "none";
        optIn = Flag(d, "optIn");
        committed = Flag(d, "committed");

        if ((source == null) == (generator == null))
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' must declare exactly one of 'source' or 'generator'", target));
        }
        if (comment != "hash" && comment != "none")
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' has unknown comment style '{1}' (expected 'hash' or 'none')", target, comment));
        }
        if (generator != null && OptStr(d, "comment") != null)
        {
            throw new ArgumentException(string.Format(
                "root config entry '{0}' is generator-produced and must not declare 'comment' — the generator owns its whole output", target));
        }
    }
}
