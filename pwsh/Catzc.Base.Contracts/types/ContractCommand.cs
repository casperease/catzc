/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/types/ContractCommand.cs
    folder: types
    name: contract-command
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/types/ContractCommand.Tests.ps1
    docs: "[ContractCommand.cs.md](docs/references/pwsh/catzc-base-contracts/types/ContractCommand.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE
      - ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS
      - ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Contracts;

// Rests on [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder), [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml) and [ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-contractlanguage).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Name), nameof(Signature))]
public sealed class ContractCommand
{
    // The output of a command that returns nothing, the default when `output` is omitted.
    public const string DefaultOutput = "void";

    public const string Suffix = ".command.yml";

    private static readonly string[] AllowedKeys = { "parameters", "output", "default_set" };

    private static readonly System.Text.RegularExpressions.Regex SetNameRe = new System.Text.RegularExpressions.Regex("^[A-Za-z][A-Za-z0-9_]*$");

    // The parameters in the order the contract states them (snake_case: the YAML keys).
    public IReadOnlyList<ContractParameter> parameters { get; }

    // The output type: a contract type, with '[]' for a list, or void.
    public string output { get; }

    // The parameter set a call that fits several resolves to; null when the command names none, the default.
    public string default_set { get; }

    // Every set the command has: the sets its parameters name and the default set, sorted; empty for a command with one set.
    public IReadOnlyList<string> Sets
    {
        get
        {
            var sets = new SortedSet<string>(StringComparer.Ordinal);
            foreach (ContractParameter parameter in parameters)
            {
                sets.UnionWith(parameter.Sets);
            }
            if (default_set != null)
            {
                sets.Add(default_set);
            }
            return new List<string>(sets);
        }
    }

    // The asset the contract was read from, and the command it names; null and empty for a signature read from a command's file.
    public ContractAsset Asset { get; }

    public string Name { get; }

    // The call interface as one line: each parameter as name and spec, then the output unless it is void.
    public string Signature
    {
        get
        {
            var parts = new List<string>();
            foreach (ContractParameter parameter in parameters)
            {
                parts.Add(parameter.Name + ": " + parameter.Spec);
            }
            string text = parts.Count == 0 ? "no parameters" : string.Join(", ", parts);
            if (default_set != null)
            {
                text += "; default set " + default_set;
            }
            return output == DefaultOutput ? text : text + " -> " + output;
        }
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractCommand(ContractAsset asset, IDictionary raw) : this(raw)
    {
        Asset = asset ?? throw new ArgumentNullException(nameof(asset), "contract command: the asset is required");
        Name = NameOf(asset);
    }

    // The command a command asset names: its file name without the suffix.
    public static string NameOf(ContractAsset asset)
    {
        if (asset == null || asset.Kind != ContractAssetKind.Command)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "contract command: '{0}' is not a command contract",
                asset == null ? "" : asset.AssetPath));
        }
        return asset.Path.Substring(0, asset.Path.Length - Suffix.Length);
    }

    // The parsed contract: raw is the YAML document, null or empty for a command with no parameters and no output.
    public ContractCommand(IDictionary raw)
    {
        var list = new List<ContractParameter>();
        var errors = new List<string>();
        string outputType = DefaultOutput;
        string defaultSet = null;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("parameters") && raw["parameters"] != null)
            {
                if (raw["parameters"] is IDictionary map)
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                        string spec = entry.Value == null ? null : Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
                        try
                        {
                            list.Add(ContractParameter.Parse(name, spec));
                        }
                        catch (ArgumentException error)
                        {
                            errors.Add(error.Message);
                        }
                    }
                }
                else
                {
                    errors.Add("parameters must be a map of parameter name to spec, e.g. { Path: string! }");
                }
            }

            if (raw.Contains("output") && raw["output"] != null)
            {
                string value = Convert.ToString(raw["output"], CultureInfo.InvariantCulture);
                if (!IsOutputType(value))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "output '{0}' is not void, a contract type or a contract type followed by []", value));
                }
                outputType = value;
            }

            if (raw.Contains("default_set") && raw["default_set"] != null)
            {
                string value = Convert.ToString(raw["default_set"], CultureInfo.InvariantCulture);
                if (!SetNameRe.IsMatch(value))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "default_set '{0}' is not a set name", value));
                }
                defaultSet = value;
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("command contract validation failed:\n" + string.Join("\n", errors));
        }
        parameters = list;
        output = outputType;
        default_set = defaultSet;
        Name = "";
    }

    // The signature a checker read from a command's file, in the same shape as a contract, so the two compare.
    public ContractCommand(IEnumerable<ContractParameter> parameterList, string outputType, string defaultSet = null)
    {
        var list = new List<ContractParameter>(parameterList ?? Array.Empty<ContractParameter>());
        parameters = list;
        output = string.IsNullOrEmpty(outputType) ? DefaultOutput : outputType;
        default_set = string.IsNullOrEmpty(defaultSet) ? null : defaultSet;
        Name = "";
    }

    public static bool IsOutputType(string value)
    {
        if (value == DefaultOutput)
        {
            return true;
        }
        string bare = value != null && value.EndsWith("[]", StringComparison.Ordinal) ? value.Substring(0, value.Length - 2) : value;
        return ContractParameter.IsContractType(bare);
    }

    public static IReadOnlyList<string> Compare(ContractCommand contract, ContractCommand command)
    {
        if (contract == null || command == null)
        {
            throw new ArgumentNullException(contract == null ? nameof(contract) : nameof(command), "contract command: both sides are required");
        }
        var findings = new List<string>();
        var declared = new Dictionary<string, ContractParameter>(StringComparer.Ordinal);
        foreach (ContractParameter parameter in command.parameters)
        {
            declared[parameter.Name] = parameter;
        }
        var promised = new HashSet<string>(StringComparer.Ordinal);
        foreach (ContractParameter expected in contract.parameters)
        {
            promised.Add(expected.Name);
            if (!declared.TryGetValue(expected.Name, out ContractParameter actual))
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}' is in the contract but not in the command", expected.Name));
                continue;
            }
            string expectedType = expected.Type + (expected.IsList ? "[]" : "");
            string actualType = actual.Type + (actual.IsList ? "[]" : "");
            if (expectedType != actualType)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the contract says {1}, the command declares {2}",
                    expected.Name, expectedType, actualType));
            }
            if (expected.Mandatory != actual.Mandatory)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the contract says {1}, the command declares {2}",
                    expected.Name, expected.Mandatory ? "mandatory" : "optional", actual.Mandatory ? "mandatory" : "optional"));
            }
            if (expected.Pipeline != actual.Pipeline)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the contract says {1}, the command declares {2}",
                    expected.Name, expected.Pipeline ? "pipeline" : "no pipeline", actual.Pipeline ? "pipeline" : "no pipeline"));
            }
            if (actual.Default != ContractParameter.ComputedDefault && expected.Default != actual.Default)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the contract's default is {1}, the command's is {2}",
                    expected.Name, Describe(expected.Default), Describe(actual.Default)));
            }
            string expectedSets = DescribeSets(expected.Sets);
            string actualSets = DescribeSets(actual.Sets);
            if (expectedSets != actualSets)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the contract puts it in {1}, the command in {2}",
                    expected.Name, expectedSets, actualSets));
            }
        }
        if (contract.default_set != command.default_set)
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "default_set: the contract says {0}, the command declares {1}",
                Describe(contract.default_set), Describe(command.default_set)));
        }
        foreach (ContractParameter actual in command.parameters)
        {
            if (!promised.Contains(actual.Name))
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "parameter '{0}' is in the command but not in the contract", actual.Name));
            }
        }
        if (contract.output != command.output)
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "output: the contract says {0}, the command declares {1}", contract.output, command.output));
        }
        return findings;
    }

    private static string Describe(string value) => value == null ? "none" : "'" + value + "'";

    private static string DescribeSets(IReadOnlyList<string> sets) => sets.Count == 0 ? "every set" : "the sets " + string.Join(",", sets);
}
