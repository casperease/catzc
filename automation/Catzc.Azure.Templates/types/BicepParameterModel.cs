// catzc:
//   path: automation/Catzc.Azure.Templates/types/BicepParameterModel.cs
//   module: Catzc.Azure.Templates

// Keys compare case-insensitively, as ARM matches parameter names.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-azure-templates/types/BicepParameterModel.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.Json;

namespace Catzc.Azure.Templates;

public sealed class BicepParameterModel
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The template the model belongs to. Always present.
    public string Template { get; }

    // Every declared parameter, keyed by its name (case-insensitive). Empty for a template without parameters.
    public IReadOnlyDictionary<string, BicepParameter> Parameters { get; }

    public BicepParameterModel(string template, IEnumerable<BicepParameter> parameters)
    {
        if (string.IsNullOrWhiteSpace(template)) { throw new ArgumentException("BicepParameterModel.Template is required"); }
        var byName = new Dictionary<string, BicepParameter>(StringComparer.OrdinalIgnoreCase);
        foreach (var parameter in parameters ?? Array.Empty<BicepParameter>())
        {
            if (parameter == null) { throw new ArgumentException($"BicepParameterModel '{template}' was given a null parameter"); }
            if (byName.ContainsKey(parameter.Name))
            {
                throw new ArgumentException($"BicepParameterModel '{template}' declares parameter '{parameter.Name}' twice");
            }
            byName[parameter.Name] = parameter;
        }
        Template = template;
        Parameters = new ReadOnlyDictionary<string, BicepParameter>(byName);
    }

    // Throws, naming the template, when the text is not a JSON object or a parameter declaration is malformed.
    // [comment:2](/docs/references/automation/catzc-azure-templates/types/BicepParameterModel.cs.md#comment2)
    public static BicepParameterModel Parse(string template, string mainJson)
    {
        if (string.IsNullOrWhiteSpace(mainJson)) { throw new ArgumentException($"main.json of template '{template}' is empty"); }

        JsonDocument document;
        try
        {
            document = JsonDocument.Parse(mainJson);
        }
        catch (JsonException exception)
        {
            throw new ArgumentException($"main.json of template '{template}' is not valid JSON: {exception.Message}");
        }

        using (document)
        {
            var root = document.RootElement;
            if (root.ValueKind != JsonValueKind.Object)
            {
                throw new ArgumentException($"main.json of template '{template}' is not a JSON object");
            }

            var parameters = new List<BicepParameter>();
            if (root.TryGetProperty("parameters", out var section))
            {
                if (section.ValueKind != JsonValueKind.Object)
                {
                    throw new ArgumentException($"main.json of template '{template}' has a parameters section that is not a JSON object");
                }
                root.TryGetProperty("definitions", out var definitions);
                foreach (var declaration in section.EnumerateObject())
                {
                    try
                    {
                        parameters.Add(BicepParameter.FromArmDeclaration(declaration.Name, declaration.Value, definitions));
                    }
                    catch (ArgumentException exception)
                    {
                        throw new ArgumentException($"Template '{template}': {exception.Message}");
                    }
                }
            }
            return new BicepParameterModel(template, parameters);
        }
    }
}
