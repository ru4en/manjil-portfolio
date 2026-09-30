#!/usr/bin/env python3
"""Robust placeholder substitution for the dynamic CV / CL templates.

Reads a template file and a set of KEY=VALUE pairs from the environment
(or from a simple KEY=VALUE file) and writes the filled result.

Usage:
    python3 substitute.py template.tex output.tex
Environment variables of the form PLACEHOLDER_NAME are used for {{PLACEHOLDER_NAME}}.
"""

import os
import sys
import re

def main():
    if len(sys.argv) != 3:
        print("Usage: substitute.py <template> <output>", file=sys.stderr)
        sys.exit(1)

    template_path, output_path = sys.argv[1], sys.argv[2]

    with open(template_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Find all {{PLACEHOLDER}} tokens
    placeholders = set(re.findall(r"\{\{([A-Z0-9_]+)\}\}", content))

    for key in placeholders:
        value = os.environ.get(key, "")
        # Replace every occurrence
        content = content.replace("{{" + key + "}}", value)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"  filled {template_path} → {output_path}")

if __name__ == "__main__":
    main()
