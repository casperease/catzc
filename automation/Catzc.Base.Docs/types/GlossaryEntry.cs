// One concept of the merged controlled vocabulary ([ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)) as
// Get-Glossary returns it: the GlossaryConcept itself, the module whose configs/glossary.yml declares it (Owner), that
// source's repo-relative path (SourcePath), and the source's defaulted GlossaryOptions — so a gate or a reader knows
// where each term lives and which checks it takes part in without going back to the source. A result type, not a
// YAML mirror, so its properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class GlossaryEntry
{
    // A repo-relative, '/'-separated path: no leading '/', no drive, no '\', no '..' segment.
    private static readonly Regex DriveRe = new Regex("^[A-Za-z]:", RegexOptions.Compiled);

    // The concept as its source declares it.
    public GlossaryConcept Concept { get; }

    // The module whose configs/glossary.yml declares the concept.
    public string Owner { get; }

    // The declaring source's repo-relative path ('automation/<Owner>/configs/glossary.yml').
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
