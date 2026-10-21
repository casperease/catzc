/*
---
catzc:
  immutable:
    with_body_sha: "5b6e3869da0d"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
    docs: "[GlossaryEntry.cs.md](../../../docs/references/pwsh/catzc-base-docs/types/GlossaryEntry.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-VOCAB
---
*/

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class GlossaryEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A repo-relative, '/'-separated path: no leading '/', no drive, no '\', no '..' segment.
    private static readonly Regex DriveRe = new Regex("^[A-Za-z]:", RegexOptions.Compiled);

    // The concept as its source declares it.
    public GlossaryConcept Concept { get; }

    // The module whose configs/glossary.yml declares the concept.
    public string Owner { get; }

    // The declaring source's repo-relative path ('pwsh/<Owner>/configs/glossary.yml').
    public string SourcePath { get; }

    // The declaring source's options, every key defaulted.
    public GlossaryOptions Options { get; }

    public GlossaryEntry(GlossaryConcept concept, string owner, string sourcePath, GlossaryOptions options)
    {
        if (concept == null) { throw new ArgumentNullException(nameof(concept)); }
        if (options == null) { throw new ArgumentNullException(nameof(options)); }
        if (string.IsNullOrWhiteSpace(owner)) { throw new ArgumentException("a glossary entry needs its owning module", nameof(owner)); }
        if (string.IsNullOrWhiteSpace(sourcePath) || sourcePath.StartsWith("/") || sourcePath.Contains("\\")
            || DriveRe.IsMatch(sourcePath) || Array.IndexOf(sourcePath.Split('/'), "..") >= 0)
        {
            throw new ArgumentException(string.Format("source path '{0}' must be repo-relative and '/'-separated", sourcePath), nameof(sourcePath));
        }

        Concept = concept;
        Owner = owner;
        SourcePath = sourcePath;
        Options = options;
    }
}
