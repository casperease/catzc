/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Objects/types/TypeShape.cs
    folder: types
    name: type-shape
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-CACHE
      - ADR-AUTO-TYPES#7
---
*/

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Reflection;

namespace Catzc.Base.Objects;

// The reflected properties of a type, read once. The table is keyed by Type and filled on first use: a loaded type cannot change in
// a process (ADR-AUTO-TYPES#7), so an entry cannot go stale, and it is not a session cache of the file set (ADR-AUTO-CACHE).
public static class TypeShape
{
    private static readonly ConcurrentDictionary<Type, Shape> Shapes = new ConcurrentDictionary<Type, Shape>();

    public static Shape Of(Type type) => Shapes.GetOrAdd(type, Build);

    private static Shape Build(Type type)
    {
        ConsoleDisplayAttribute display = type.GetCustomAttribute<ConsoleDisplayAttribute>(true);
        List<PropertyInfo> data = new List<PropertyInfo>();
        List<PropertyInfo> console = new List<PropertyInfo>();
        foreach (PropertyInfo property in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        {
            if (!property.CanRead || property.GetIndexParameters().Length != 0 || property.DeclaringType == typeof(DictionaryRecord)) { continue; }
            data.Add(property);
            if (property.GetGetMethod() != null && !IsHidden(property)) { console.Add(property); }
        }
        return new Shape(data.ToArray(), console.ToArray(), display == null ? null : display.Properties);
    }

    private static bool IsHidden(PropertyInfo property)
    {
        foreach (object attribute in property.GetCustomAttributes(true))
        {
            if (attribute.GetType().FullName == "System.Management.Automation.HiddenAttribute") { return true; }
        }
        return false;
    }

    // Read-only after construction: callers only read the arrays and the maps.
    public sealed class Shape
    {
        // The readable, non-indexed properties the type declares itself: the dictionary view of a DictionaryRecord.
        public readonly PropertyInfo[] Data;

        // The data properties that have a public getter and are not [Hidden]: what the console text renders.
        public readonly PropertyInfo[] Console;

        // The type's [ConsoleDisplay] property names, or null when it has none.
        public readonly string[] Display;

        private readonly Dictionary<string, PropertyInfo> dataByName;
        private readonly Dictionary<string, PropertyInfo> consoleByName;

        internal Shape(PropertyInfo[] data, PropertyInfo[] console, string[] display)
        {
            Data = data;
            Console = console;
            Display = display;
            dataByName = ByName(data);
            consoleByName = ByName(console);
        }

        public PropertyInfo DataProperty(string name) => name != null && dataByName.TryGetValue(name, out PropertyInfo p) ? p : null;

        public PropertyInfo ConsoleProperty(string name) => name != null && consoleByName.TryGetValue(name, out PropertyInfo p) ? p : null;

        private static Dictionary<string, PropertyInfo> ByName(PropertyInfo[] properties)
        {
            Dictionary<string, PropertyInfo> map = new Dictionary<string, PropertyInfo>(StringComparer.Ordinal);
            foreach (PropertyInfo property in properties) { map[property.Name] = property; }
            return map;
        }
    }
}
