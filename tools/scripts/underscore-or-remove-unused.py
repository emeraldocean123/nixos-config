#!/usr/bin/env python3
import json, sys, re, os

"""
Reads deadnix JSON from stdin and edits files in place:
- For messages starting with 'Unused lambda pattern: NAME' (attrset pattern), remove the NAME token from the pattern line.
- For messages starting with 'Unused lambda argument: NAME', prefix NAME with '_' at the given span.

We apply fixes grouped per file and sorted in reverse (line, col) so earlier edits don’t shift later spans.
"""

def load_report(stdin):
    text = stdin.read()
    if not text.strip():
        return []
    items = []
    # deadnix -o json on a directory prints multiple JSON objects separated by newlines
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError:
            continue
        file = obj.get("file") or obj.get("path") or ""
        results = obj.get("results") or []
        for r in results:
            msg = r.get("message", "")
            line_no = r.get("line")
            col = r.get("column")
            endcol = r.get("endColumn", col)
            if not file or not line_no or not col or not msg:
                continue
            items.append({
                "file": file,
                "line": int(line_no),
                "col": int(col),
                "endcol": int(endcol) if endcol else int(col),
                "msg": msg,
            })
    return items

def edit_file(path, edits):
    # edits: list of dict with line, col, endcol, action, name
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    # Sort by (line desc, col desc)
    edits.sort(key=lambda e: (e['line'], e['col']), reverse=True)
    for e in edits:
        li = e['line'] - 1
        if li < 0 or li >= len(lines):
            continue
        s = lines[li]
        start = e['col'] - 1
        end = e['endcol'] - 1
        if start < 0 or start > len(s):
            continue
        if end < start:
            end = start
        end = min(end, len(s))
        token = s[start:end]
        if e['action'] == 'prefix_':
            # Replace exact token with _token
            new = s[:start] + '_' + token + s[end:]
            lines[li] = new
        elif e['action'] == 'remove_token':
            # Remove token and a nearby comma/whitespace elegantly
            before = s[:start]
            after = s[end:]
            # If next non-space char after token is '@' or ':', prefer prefixing underscore (e.g., inputs @ {..} or name: expr)
            nxt = after
            mnext = re.match(r"\s*([@:])", nxt)
            if mnext:
                # prefix instead of remove
                new = s[:start] + '_' + token + s[end:]
                lines[li] = new
                continue
            # Trim patterns: ", token" or "token, "
            # Prefer removing surrounding comma and spaces once.
            # Try remove preceding comma form
            m = re.search(r",\s*$", before)
            if m:
                before = before[:m.start()]
            else:
                # Try remove following comma
                m2 = re.match(r"^\s*,\s*", after)
                if m2:
                    after = after[m2.end():]
            lines[li] = before + after
    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(lines)

def main():
    items = load_report(sys.stdin)
    # Build per-file edits
    per_file = {}
    for it in items:
        msg = it['msg']
        # Only act on specific messages
        if msg.startswith('Unused lambda pattern: '):
            name = msg.split(': ',1)[1].strip()
            action = 'remove_token'
        elif msg.startswith('Unused lambda argument: '):
            name = msg.split(': ',1)[1].strip()
            action = 'prefix_'
        else:
            continue
        path = it['file']
        per_file.setdefault(path, []).append({
            'line': it['line'], 'col': it['col'], 'endcol': it['endcol'], 'name': name, 'action': action
        })

    # Apply edits
    for path, edits in per_file.items():
        try:
            edit_file(path, edits)
            print(f"edited {path}: {len(edits)} change(s)")
        except Exception as e:
            print(f"failed {path}: {e}")

if __name__ == '__main__':
    main()
