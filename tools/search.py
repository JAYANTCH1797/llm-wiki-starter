#!/usr/bin/env python3
"""
Simple wiki search — grep-based search over markdown files.
Good enough for <200 pages. Replace with qmd when you outgrow this.

Usage:
    python tools/search.py "attention mechanism"
    python tools/search.py "transformer" --limit 5
"""

import argparse
import os
import re
from pathlib import Path

WIKI_DIR = Path(__file__).parent.parent / "wiki"

def search(query: str, limit: int = 10) -> list[dict]:
    results = []
    terms = query.lower().split()

    for md_file in WIKI_DIR.rglob("*.md"):
        try:
            content = md_file.read_text(encoding="utf-8")
        except Exception:
            continue

        content_lower = content.lower()
        score = 0
        for term in terms:
            score += content_lower.count(term)

        if score > 0:
            # Extract title from frontmatter or first heading
            title = md_file.stem
            title_match = re.search(r"^title:\s*(.+)$", content, re.MULTILINE)
            if title_match:
                title = title_match.group(1).strip()
            else:
                heading_match = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
                if heading_match:
                    title = heading_match.group(1).strip()

            # Extract first matching line for context
            context = ""
            for line in content.split("\n"):
                if any(t in line.lower() for t in terms):
                    context = line.strip()[:120]
                    break

            rel_path = md_file.relative_to(WIKI_DIR)
            results.append({
                "path": str(rel_path),
                "title": title,
                "score": score,
                "context": context,
            })

    results.sort(key=lambda r: r["score"], reverse=True)
    return results[:limit]


def main():
    parser = argparse.ArgumentParser(description="Search the wiki")
    parser.add_argument("query", help="Search terms")
    parser.add_argument("--limit", type=int, default=10, help="Max results")
    args = parser.parse_args()

    results = search(args.query, args.limit)

    if not results:
        print(f"No results for: {args.query}")
        return

    print(f"\n{len(results)} results for: {args.query}\n")
    for i, r in enumerate(results, 1):
        print(f"  {i}. [{r['score']}] {r['title']}")
        print(f"     wiki/{r['path']}")
        if r["context"]:
            print(f"     ...{r['context']}...")
        print()


if __name__ == "__main__":
    main()
