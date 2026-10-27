// Evaluates the small ARM expression subset the compiled templates use for the values a compliance check reads; anything outside it is Unresolved, never a guess.
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Catzc.Azure.Templates;

public static class ArmExpression
{
    // The value of an expression outside the subset, or of a parameter with no value: a check reports it, never passes it.
    public static readonly object Unresolved = new UnresolvedValue();

    private sealed class UnresolvedValue
    {
        public override string ToString() { return "<unresolved>"; }
    }

    // The value of a template property: a non-string as is, a plain or [[-escaped string as text, a [..] string evaluated.
    public static object Evaluate(object value, IDictionary parameters)
    {
        return Evaluate(value, parameters, null);
    }

    // As above, with the template's variables: a variables() call evaluates that variable's own expression over the same scope, on demand.
    public static object Evaluate(object value, IDictionary parameters, IDictionary variables)
    {
        return Evaluate(value, parameters, variables, null, null, 0);
    }

    // As above, inside copy loops: copyIndexes maps each loop's name to its instance index, and the empty name to the innermost loop's.
    public static object Evaluate(object value, IDictionary parameters, IDictionary variables, IDictionary copyIndexes)
    {
        return Evaluate(value, parameters, variables, copyIndexes, null, 0);
    }

    public static object Evaluate(object value, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, IDictionary deployment)
    {
        return Evaluate(value, parameters, variables, copyIndexes, deployment, 0);
    }

    public static object EvaluateCopy(IDictionary copy, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, IDictionary deployment)
    {
        return EvaluateCopy(copy, parameters, variables, copyIndexes, deployment, 0);
    }

    // The deepest chain of variables referring to variables; past it the value is Unresolved, so a cycle cannot recurse forever.
    private const int MaxVariableDepth = 16;

    private static object EvaluateCopy(IDictionary copy, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, IDictionary deployment, int depth)
    {
        if (copy == null || !(copy["name"] is string name) || !copy.Contains("input")) { return Unresolved; }
        object count = Evaluate(copy["count"], parameters, variables, copyIndexes, deployment, depth);
        if (!ArmFunction.IsNumber(count)) { return Unresolved; }
        var values = new List<object>();
        for (long index = 0; index < Convert.ToInt64(count, CultureInfo.InvariantCulture); index++)
        {
            var bound = new Hashtable(StringComparer.OrdinalIgnoreCase);
            if (copyIndexes != null) { foreach (DictionaryEntry e in copyIndexes) { bound[e.Key] = e.Value; } }
            bound[name] = index;
            bound[string.Empty] = index;
            values.Add(EvaluateTree(copy["input"], parameters, variables, bound, deployment, depth));
        }
        return values.ToArray();
    }

    // A variable or a copy input may be an object or array of expressions, not one string: each leaf string evaluates in the given scope.
    private static object EvaluateTree(object node, IDictionary parameters, IDictionary variables, IDictionary bound, IDictionary deployment, int depth)
    {
        if (node is string) { return Evaluate(node, parameters, variables, bound, deployment, depth); }
        if (node is IDictionary map)
        {
            var result = new System.Collections.Specialized.OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (DictionaryEntry e in map) { result[e.Key] = EvaluateTree(e.Value, parameters, variables, bound, deployment, depth); }
            return result;
        }
        if (node is IList list)
        {
            var items = new List<object>();
            foreach (object item in list) { items.Add(EvaluateTree(item, parameters, variables, bound, deployment, depth)); }
            return items.ToArray();
        }
        return node;
    }

    private static object Evaluate(object value, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, IDictionary deployment, int depth)
    {
        string text = value as string;
        if (text == null) { return value; }
        if (!text.StartsWith("[", StringComparison.Ordinal) || !text.EndsWith("]", StringComparison.Ordinal)) { return text; }
        if (text.StartsWith("[[", StringComparison.Ordinal)) { return text.Substring(1); }
        try
        {
            var parser = new Parser(text.Substring(1, text.Length - 2), parameters ?? new Hashtable(), variables, copyIndexes, deployment, depth);
            object result = parser.Expression();
            parser.SkipSpace();
            return parser.AtEnd ? result : Unresolved;
        }
        catch (FormatException) { return Unresolved; }
    }

    public static bool IsUnresolved(object value) { return ReferenceEquals(value, Unresolved); }

    private sealed class Parser
    {
        private readonly string text;
        private readonly IDictionary parameters;
        private readonly IDictionary variables;
        private readonly IDictionary copyIndexes;
        private readonly IDictionary deployment;
        private readonly int depth;
        private int position;

        public Parser(string text, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, IDictionary deployment, int depth)
        {
            this.text = text;
            this.parameters = parameters;
            this.variables = variables;
            this.copyIndexes = copyIndexes;
            this.deployment = deployment;
            this.depth = depth;
        }

        public bool AtEnd { get { return position >= text.Length; } }

        public void SkipSpace()
        {
            while (!AtEnd && char.IsWhiteSpace(text[position])) { position++; }
        }

        public object Expression()
        {
            SkipSpace();
            if (AtEnd) { throw new FormatException("empty expression"); }
            char c = text[position];
            if (c == '\'') { return StringLiteral(); }
            if (char.IsDigit(c) || c == '-') { return Number(); }
            if (!char.IsLetter(c)) { throw new FormatException("unexpected character"); }
            string name = ArmFunction.Canonical(Identifier());
            SkipSpace();
            Expect('(');
            switch (name)
            {
                case "filter":
                case "map":
                case "toObject":
                    return Postfix(LambdaCall(name));
            }
            var args = new List<object>();
            SkipSpace();
            if (!AtEnd && text[position] == ')') { position++; }
            else
            {
                while (true)
                {
                    args.Add(Expression());
                    SkipSpace();
                    if (AtEnd) { throw new FormatException("unclosed call"); }
                    if (text[position] == ',') { position++; continue; }
                    Expect(')');
                    break;
                }
            }
            return Postfix(Call(name, args));
        }

        private object Postfix(object result)
        {
            SkipSpace();
            while (!AtEnd && (text[position] == '.' || text[position] == '['))
            {
                object key;
                if (text[position] == '.') { position++; key = Identifier(); }
                else { position++; key = Expression(); SkipSpace(); Expect(']'); }
                result = Member(result, key);
                SkipSpace();
            }
            return result;
        }

        private static object Member(object container, object key)
        {
            if (IsUnresolved(container) || IsUnresolved(key)) { return Unresolved; }
            if (container is IDictionary map && key is string name)
            {
                foreach (object k in map.Keys)
                {
                    if (string.Equals(k == null ? null : k.ToString(), name, StringComparison.OrdinalIgnoreCase)) { return map[k]; }
                }
                return Unresolved;
            }
            if (container is IList list && ArmFunction.IsNumber(key))
            {
                long index = Convert.ToInt64(key, CultureInfo.InvariantCulture);
                return index >= 0 && index < list.Count ? list[(int)index] : Unresolved;
            }
            return Unresolved;
        }

        // The lambda variables bound while a lambda body evaluates for one item, innermost last.
        private readonly List<KeyValuePair<string, object>> bindings = new List<KeyValuePair<string, object>>();

        private object LambdaCall(string name)
        {
            object source = Expression();
            SkipSpace();
            Expect(',');
            List<object> first = EachItem(source, LambdaHead());
            List<object> values = null;
            SkipSpace();
            if (name == "toObject" && !AtEnd && text[position] == ',')
            {
                position++;
                values = EachItem(source, LambdaHead());
                SkipSpace();
            }
            Expect(')');
            if (first == null) { return Unresolved; }
            if (name == "map") { return first.ToArray(); }
            int index = 0;
            if (name == "filter")
            {
                var kept = new List<object>();
                foreach (object item in (IEnumerable)source)
                {
                    object keep = first[index++];
                    if (!(keep is bool)) { return Unresolved; }
                    if ((bool)keep) { kept.Add(item); }
                }
                return kept.ToArray();
            }
            // toObject: a later item with the same key replaces an earlier one; with no value lambda the item itself is the value.
            var built = new System.Collections.Specialized.OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (object item in (IEnumerable)source)
            {
                if (!(first[index] is string key)) { return Unresolved; }
                built[key] = values == null ? item : values[index];
                index++;
            }
            return built;
        }

        private List<string> LambdaHead()
        {
            SkipSpace();
            if (!Identifier().Equals("lambda", StringComparison.OrdinalIgnoreCase)) { throw new FormatException("expected a lambda"); }
            SkipSpace();
            Expect('(');
            var names = new List<string>();
            while (true)
            {
                SkipSpace();
                if (AtEnd || text[position] != '\'') { break; }
                int start = position;
                string variable = StringLiteral();
                SkipSpace();
                if (AtEnd || text[position] != ',') { position = start; break; }
                position++;
                names.Add(variable);
            }
            if (names.Count < 1 || names.Count > 2) { throw new FormatException("a lambda binds an item and at most its index"); }
            return names;
        }

        private List<object> EachItem(object source, List<string> names)
        {
            int body = position;
            List<object> results = null;
            if (!IsUnresolved(source) && source is IEnumerable && !(source is string) && !(source is IDictionary))
            {
                results = new List<object>();
                long index = 0;
                foreach (object item in (IEnumerable)source)
                {
                    position = body;
                    Bind(names, item, index);
                    results.Add(Expression());
                    bindings.RemoveRange(bindings.Count - names.Count, names.Count);
                    index++;
                }
            }
            position = body;
            Bind(names, Unresolved, Unresolved);
            Expression();
            bindings.RemoveRange(bindings.Count - names.Count, names.Count);
            SkipSpace();
            Expect(')');
            return results;
        }

        private void Bind(List<string> names, object item, object index)
        {
            bindings.Add(new KeyValuePair<string, object>(names[0], item));
            if (names.Count > 1) { bindings.Add(new KeyValuePair<string, object>(names[1], index)); }
        }

        // A for-variable: ARM writes it as an entry of variables.copy ({ name, count, input }), its value one input per copyIndex(name).
        private object CopyVariable(string name)
        {
            IEnumerable copies = variables.Contains("copy") ? variables["copy"] as IEnumerable : null;
            if (copies == null) { return Unresolved; }
            foreach (object item in copies)
            {
                IDictionary copy = item as IDictionary;
                if (copy == null || !copy.Contains("name") || !string.Equals(copy["name"] as string, name, StringComparison.OrdinalIgnoreCase)) { continue; }
                return EvaluateCopy(copy, parameters, variables, copyIndexes, deployment, depth + 1);
            }
            return Unresolved;
        }

        private object Call(string name, List<object> args)
        {
            switch (name)
            {
                case "parameters":
                    if (args.Count != 1 || !(args[0] is string)) { return Unresolved; }
                    return parameters.Contains(args[0]) ? parameters[args[0]] : Unresolved;
                case "variables":
                    if (args.Count != 1 || !(args[0] is string) || variables == null || depth >= MaxVariableDepth) { return Unresolved; }
                    if (variables.Contains(args[0])) { return EvaluateTree(variables[args[0]], parameters, variables, copyIndexes, deployment, depth + 1); }
                    return CopyVariable((string)args[0]);
                case "if":
                    // Lazy in effect: once the condition resolves, the branch it picks is the value, whatever the other branch is.
                    if (args.Count != 3 || !(args[0] is bool)) { return Unresolved; }
                    return (bool)args[0] ? args[1] : args[2];
                case "copyIndex":
                    // copyIndex(), copyIndex(offset), copyIndex('loop') or copyIndex('loop', offset); outside its loop it is Unresolved.
                    if (args.Exists(IsUnresolved) || copyIndexes == null) { return Unresolved; }
                    string loop = args.Count > 0 && args[0] is string named ? named : string.Empty;
                    object offset = args.Count > 0 && ArmFunction.IsNumber(args[args.Count - 1]) ? args[args.Count - 1] : 0L;
                    if (!copyIndexes.Contains(loop)) { return Unresolved; }
                    return Convert.ToInt64(copyIndexes[loop], CultureInfo.InvariantCulture) + Convert.ToInt64(offset, CultureInfo.InvariantCulture);
                case "lambdaVariables":
                    if (args.Count != 1 || !(args[0] is string)) { return Unresolved; }
                    for (int i = bindings.Count - 1; i >= 0; i--)
                    {
                        if (bindings[i].Key == (string)args[0]) { return bindings[i].Value; }
                    }
                    return Unresolved;
                case "deployment":
                case "subscription":
                case "resourceGroup":
                case "resourceId":
                case "subscriptionResourceId":
                case "reference":
                    return ArmScopeFunction.Call(name, args, deployment);
                case "true": return true;
                case "false": return false;
                case "null": return args.Count == 0 ? null : Unresolved;
                case "createArray": return args.Exists(IsUnresolved) ? Unresolved : (object)args.ToArray();
            }
            return ArmFunction.Call(name, args);
        }

        private string StringLiteral()
        {
            Expect('\'');
            var builder = new StringBuilder();
            while (true)
            {
                if (AtEnd) { throw new FormatException("unclosed string"); }
                char c = text[position++];
                if (c == '\'')
                {
                    if (!AtEnd && text[position] == '\'') { builder.Append('\''); position++; continue; }
                    return builder.ToString();
                }
                builder.Append(c);
            }
        }

        private object Number()
        {
            int start = position;
            if (text[position] == '-') { position++; }
            while (!AtEnd && char.IsDigit(text[position])) { position++; }
            long number;
            if (!long.TryParse(text.Substring(start, position - start), NumberStyles.AllowLeadingSign, CultureInfo.InvariantCulture, out number)) { throw new FormatException("bad number"); }
            return number;
        }

        private string Identifier()
        {
            int start = position;
            while (!AtEnd && (char.IsLetterOrDigit(text[position]) || text[position] == '_')) { position++; }
            if (position == start) { throw new FormatException("expected identifier"); }
            return text.Substring(start, position - start);
        }

        private void Expect(char c)
        {
            if (AtEnd || text[position] != c) { throw new FormatException("expected " + c); }
            position++;
        }
    }
}
