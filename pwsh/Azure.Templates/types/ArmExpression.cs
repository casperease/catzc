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
        return Evaluate(value, parameters, variables, null, 0);
    }

    // As above, inside copy loops: copyIndexes maps each loop's name to its instance index, and the empty name to the innermost loop's.
    public static object Evaluate(object value, IDictionary parameters, IDictionary variables, IDictionary copyIndexes)
    {
        return Evaluate(value, parameters, variables, copyIndexes, 0);
    }

    // The deepest chain of variables referring to variables; past it the value is Unresolved, so a cycle cannot recurse forever.
    private const int MaxVariableDepth = 16;

    private static object Evaluate(object value, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, int depth)
    {
        string text = value as string;
        if (text == null) { return value; }
        if (!text.StartsWith("[", StringComparison.Ordinal) || !text.EndsWith("]", StringComparison.Ordinal)) { return text; }
        if (text.StartsWith("[[", StringComparison.Ordinal)) { return text.Substring(1); }
        try
        {
            var parser = new Parser(text.Substring(1, text.Length - 2), parameters ?? new Hashtable(), variables, copyIndexes, depth);
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
        private readonly int depth;
        private int position;

        public Parser(string text, IDictionary parameters, IDictionary variables, IDictionary copyIndexes, int depth)
        {
            this.text = text;
            this.parameters = parameters;
            this.variables = variables;
            this.copyIndexes = copyIndexes;
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
            string name = Identifier();
            SkipSpace();
            Expect('(');
            if (name.Equals("filter", StringComparison.OrdinalIgnoreCase)) { return Postfix(Filter()); }
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

        // A property or index access on a call result (reference(...).outputs) is outside the subset.
        // A property (.name) or index ([key]) of a resolved object or list; on anything unresolved, or a missing key, it stays Unresolved.
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
            if (container is IList list && IsNumber(key))
            {
                long index = Convert.ToInt64(key, CultureInfo.InvariantCulture);
                return index >= 0 && index < list.Count ? list[(int)index] : Unresolved;
            }
            return Unresolved;
        }

        // The lambda variables bound while a lambda body evaluates for one item, innermost last.
        private readonly List<KeyValuePair<string, object>> bindings = new List<KeyValuePair<string, object>>();

        // filter(array, lambda('item', predicate)): the body is parsed once per item with the variable bound; the list's order is kept.
        private object Filter()
        {
            object source = Expression();
            SkipSpace();
            Expect(',');
            SkipSpace();
            if (!Identifier().Equals("lambda", StringComparison.OrdinalIgnoreCase)) { throw new FormatException("filter takes a lambda"); }
            SkipSpace();
            Expect('(');
            SkipSpace();
            string variable = StringLiteral();
            SkipSpace();
            Expect(',');
            int body = position;
            var kept = new List<object>();
            bool resolved = !IsUnresolved(source) && source is IEnumerable && !(source is string) && !(source is IDictionary);
            if (resolved)
            {
                foreach (object item in (IEnumerable)source)
                {
                    position = body;
                    bindings.Add(new KeyValuePair<string, object>(variable, item));
                    object keep = Expression();
                    bindings.RemoveAt(bindings.Count - 1);
                    if (!(keep is bool)) { resolved = false; break; }
                    if ((bool)keep) { kept.Add(item); }
                }
            }
            // The body is parsed once more, unbound, so the position passes it whatever the list held.
            position = body;
            bindings.Add(new KeyValuePair<string, object>(variable, Unresolved));
            Expression();
            bindings.RemoveAt(bindings.Count - 1);
            SkipSpace();
            Expect(')');
            SkipSpace();
            Expect(')');
            return resolved ? kept.ToArray() : Unresolved;
        }

        private object Call(string name, List<object> args)
        {
            switch (name.ToLowerInvariant())
            {
                case "parameters":
                    if (args.Count != 1 || !(args[0] is string)) { return Unresolved; }
                    return parameters.Contains(args[0]) ? parameters[args[0]] : Unresolved;
                case "variables":
                    if (args.Count != 1 || !(args[0] is string) || variables == null || !variables.Contains(args[0]) || depth >= MaxVariableDepth) { return Unresolved; }
                    return Evaluate(variables[args[0]], parameters, variables, copyIndexes, depth + 1);
                case "copyindex":
                    // copyIndex(), copyIndex(offset), copyIndex('loop') or copyIndex('loop', offset); outside its loop it is Unresolved.
                    if (args.Exists(IsUnresolved) || copyIndexes == null) { return Unresolved; }
                    string loop = args.Count > 0 && args[0] is string named ? named : string.Empty;
                    object offset = args.Count > 0 && IsNumber(args[args.Count - 1]) ? args[args.Count - 1] : 0L;
                    if (!copyIndexes.Contains(loop)) { return Unresolved; }
                    return Convert.ToInt64(copyIndexes[loop], CultureInfo.InvariantCulture) + Convert.ToInt64(offset, CultureInfo.InvariantCulture);
                case "lambdavariables":
                    if (args.Count != 1 || !(args[0] is string)) { return Unresolved; }
                    for (int i = bindings.Count - 1; i >= 0; i--)
                    {
                        if (bindings[i].Key == (string)args[0]) { return bindings[i].Value; }
                    }
                    return Unresolved;
                case "true": return true;
                case "false": return false;
                case "createarray": return args.Exists(IsUnresolved) ? Unresolved : (object)args.ToArray();
            }
            if (args.Exists(IsUnresolved)) { return Unresolved; }
            switch (name.ToLowerInvariant())
            {
                case "equals":
                    return args.Count == 2 ? (object)Same(args[0], args[1]) : Unresolved;
                case "not":
                    return args.Count == 1 && args[0] is bool ? (object)!(bool)args[0] : Unresolved;
                case "and":
                case "or":
                    if (args.Count < 2 || !args.TrueForAll(a => a is bool)) { return Unresolved; }
                    bool and = name.Equals("and", StringComparison.OrdinalIgnoreCase);
                    foreach (object a in args)
                    {
                        if ((bool)a != and) { return !and; }
                    }
                    return and;
                case "if":
                    return args.Count == 3 && args[0] is bool ? ((bool)args[0] ? args[1] : args[2]) : Unresolved;
                case "objectkeys":
                    if (args.Count != 1 || !(args[0] is IDictionary)) { return Unresolved; }
                    var keys = new List<object>();
                    foreach (object key in ((IDictionary)args[0]).Keys) { keys.Add(key == null ? string.Empty : key.ToString()); }
                    return keys.ToArray();
                case "length":
                    if (args.Count != 1) { return Unresolved; }
                    if (args[0] is string ls) { return (long)ls.Length; }
                    if (args[0] is ICollection lc) { return (long)lc.Count; }
                    return Unresolved;
                case "empty":
                    if (args.Count != 1) { return Unresolved; }
                    if (args[0] == null) { return true; }
                    if (args[0] is string s) { return s.Length == 0; }
                    if (args[0] is ICollection collection) { return collection.Count == 0; }
                    return Unresolved;
                case "contains":
                    if (args.Count != 2) { return Unresolved; }
                    if (args[0] is string container) { return args[1] is string part ? (object)(container.IndexOf(part, StringComparison.OrdinalIgnoreCase) >= 0) : Unresolved; }
                    if (args[0] is IDictionary map) { return args[1] is string key ? (object)map.Contains(key) : Unresolved; }
                    if (args[0] is IEnumerable items)
                    {
                        foreach (object item in items)
                        {
                            if (Same(item, args[1])) { return true; }
                        }
                        return false;
                    }
                    return Unresolved;
                default:
                    return Unresolved;
            }
        }

        // ARM compares strings without regard to case; numbers by value.
        private static bool Same(object a, object b)
        {
            if (a is string sa && b is string sb) { return string.Equals(sa, sb, StringComparison.OrdinalIgnoreCase); }
            if (a is bool ba && b is bool bb) { return ba == bb; }
            if (IsNumber(a) && IsNumber(b)) { return Convert.ToDecimal(a, CultureInfo.InvariantCulture) == Convert.ToDecimal(b, CultureInfo.InvariantCulture); }
            return Equals(a, b);
        }

        private static bool IsNumber(object value)
        {
            return value is int || value is long || value is double || value is decimal;
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
