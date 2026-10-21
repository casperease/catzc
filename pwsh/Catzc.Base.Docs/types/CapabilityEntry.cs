/*
---
catzc:
  immutable:
    with_body_sha: "034ba760978a"
  edges:
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-CONF-LOADING-CSHARPCONFIGTYPE
      - ADR-PWSH-ERROR-THROWNOTWRITEERROR
      - ADR-REPO-AGENTS-NOORPHANNOGHOST
      - ADR-REPO-AGENTS-CAPABILITYREGISTERED
      - ADR-REPO-AGENTS-USERSKILL
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

// Rests on [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml), [ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype), [ADR-REPO-AGENTS-NOORPHANNOGHOST](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-noorphannoghost) and [ADR-REPO-AGENTS-CAPABILITYREGISTERED](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-capabilityregistered).
public sealed class CapabilityEntry : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "name", "supported_by", "checks", "invoked_by" };
    private static readonly string[] Invokers = { "robot", "user" };
    // <domain>-<job>: lowercase letters, digits and hyphens only (the harness accepts nothing else in a skill name), at least one hyphen.
    private static readonly Regex NameRe = new Regex("^[a-z0-9]+(-[a-z0-9]+)+$", RegexOptions.Compiled);
    private static readonly Regex CitationRe = new Regex("^" + AdrCodeForm.AnyKind.Rule + "$", RegexOptions.Compiled);
    private static readonly Regex CommandRe = new Regex("^[A-Z][a-z]+-[A-Za-z0-9]+$", RegexOptions.Compiled);

    // The capability's name, <domain>.<job>: the file .claude/skills/<name>/SKILL.md and its front-matter name.
    public string name { get; }

    // The rule citations (ADR-<CODE>#<n>) that justify the capability, in file order.
    public IReadOnlyList<string> supported_by { get; }

    // The gate and check functions the capability runs or guards, in file order; empty when it has none.
    public IReadOnlyList<string> checks { get; }

    // Who loads the capability: a robot preloads it, or the user invokes it by name as a user skill ([ADR-REPO-AGENTS-USERSKILL](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-userskill)).
    public string invoked_by { get; } = "robot";

    public CapabilityEntry(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("must be a mapping with a 'name' key"); }
        List<string> errors = new List<string>();

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        name = OptStr(d, "name");
        if (name == null) { errors.Add("'name' is required and must be non-empty"); }
        else if (!NameRe.IsMatch(name)) { errors.Add(string.Format("name '{0}' must be <domain>-<job>: lowercase letters, digits and hyphens", name)); }

        supported_by = AgentEntry.ReadList(d, "supported_by", CitationRe, "a rule's code, e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR", errors);
        if (d.Contains("supported_by") && supported_by.Count == 0)
        {
            errors.Add("'supported_by' must cite at least one rule");
        }

        checks = AgentEntry.ReadList(d, "checks", CommandRe, "a Verb-Noun command name", errors);

        if (d.Contains("invoked_by"))
        {
            string invoker = OptStr(d, "invoked_by");
            if (invoker == null || Array.IndexOf(Invokers, invoker) < 0)
            {
                errors.Add(string.Format("invoked_by must be one of: {0}", string.Join(", ", Invokers)));
            }
            else { invoked_by = invoker; }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
