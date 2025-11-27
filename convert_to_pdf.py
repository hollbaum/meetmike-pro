#!/usr/bin/env python3
"""Convert all markdown files in meet-mike project to PDF"""

import os
import subprocess
from pathlib import Path

# Base directory
base_dir = Path("/workspaces/Measai-Maestro/projects/meet-mike")
pdf_dir = base_dir / "pdfs"

# Create output directory
pdf_dir.mkdir(exist_ok=True)

# Find all markdown files
md_files = list(base_dir.rglob("*.md"))

print(f"Found {len(md_files)} markdown files to convert")

for md_file in md_files:
    # Get relative path for better naming
    rel_path = md_file.relative_to(base_dir)
    # Create output filename (replace / with _)
    output_name = str(rel_path).replace("/", "_").replace(".md", ".pdf")
    output_path = pdf_dir / output_name

    print(f"Converting: {rel_path} -> {output_name}")

    try:
        result = subprocess.run(
            ["mdpdf", str(md_file), "-o", str(output_path)],
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode == 0:
            print(f"  ✓ Success: {output_name}")
        else:
            print(f"  ✗ Failed: {result.stderr}")
    except Exception as e:
        print(f"  ✗ Error: {e}")

print(f"\nConversion complete. PDFs saved to: {pdf_dir}")
print(f"Total files: {len(list(pdf_dir.glob('*.pdf')))}")
