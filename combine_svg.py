#!/usr/bin/env python3

# Vibe code by Claude under the commands from xieby1
import sys
import re

# Configuration
border_width = 1  # Border stroke width
border_color = "gray"
padding = 10  # Padding around each page

# Get SVG files from command-line arguments
if len(sys.argv) < 3:
    print("Usage: python3 combine_svg.py <input_svg_files...> <output_file>")
    print("Example: python3 combine_svg.py main*.svg combined.svg")
    exit(1)

# Last argument is output file, rest are input files
output_file = sys.argv[-1]
svg_files = sorted(sys.argv[1:-1])

if not svg_files:
    print("No input SVG files provided!")
    exit(1)

# Parse first SVG to get dimensions using regex
with open(svg_files[0], 'r') as f:
    first_svg = f.read()

# Extract width and height
width_match = re.search(r'width="([0-9.]+)pt"', first_svg)
height_match = re.search(r'height="([0-9.]+)pt"', first_svg)

if not width_match or not height_match:
    print("Could not extract dimensions from SVG!")
    exit(1)

width = float(width_match.group(1))
height = float(height_match.group(1))

print(f"Page dimensions: {width}pt × {height}pt")
print(f"Processing {len(svg_files)} files...")

# Calculate combined dimensions
page_height_with_padding = height + 2 * padding
total_height = len(svg_files) * page_height_with_padding
total_width = width + 2 * padding

# Create combined SVG
combined = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
     width="{total_width}pt" height="{total_height}pt"
     viewBox="0 0 {total_width} {total_height}">
'''

# Collect all defs and content
all_defs = []
all_content = []

# Process each SVG file
for i, svg_file in enumerate(svg_files):
    print(f"Adding {svg_file}...")

    # Calculate Y offset for this page
    y_offset = i * page_height_with_padding

    # Read the SVG content
    with open(svg_file, 'r') as f:
        content = f.read()

    # Extract the defs section
    defs_match = re.search(r'<defs>(.*?)</defs>', content, re.DOTALL)

    # Extract everything between <svg...> and </svg>, excluding the defs
    # Remove the opening svg tag
    content = re.sub(r'<\?xml[^>]*\?>', '', content)
    content = re.sub(r'<svg[^>]*>', '', content)
    content = re.sub(r'</svg>', '', content)

    # Remove defs from content (we'll add them separately)
    if defs_match:
        content = content.replace(defs_match.group(0), '')

    # Create unique ID prefix for this page
    id_prefix = f"page{i+1}_"

    # Find all id definitions and rename them
    def replace_id_def(match):
        return f'id="{id_prefix}{match.group(1)}"'

    # Find all id references in xlink:href and url() and rename them
    def replace_xlink_href(match):
        return f'xlink:href="#{id_prefix}{match.group(1)}"'

    def replace_url_ref(match):
        return f'url(#{id_prefix}{match.group(1)})'

    # Replace IDs in defs if they exist
    if defs_match:
        defs_content = defs_match.group(1)
        defs_content = re.sub(r'id="([^"]+)"', replace_id_def, defs_content)
        all_defs.append(defs_content)

    # Replace ID references in content
    content = re.sub(r'xlink:href="#([^"]+)"', replace_xlink_href, content)
    content = re.sub(r'url\(#([^)]+)\)', replace_url_ref, content)

    # Add page content with border
    page_content = f'\n  <!-- Page {i+1}: {svg_file} -->\n'
    page_content += f'  <g transform="translate({padding}, {y_offset + padding})">\n'
    page_content += f'    <rect x="0" y="0" width="{width}" height="{height}" '
    page_content += f'fill="none" stroke="{border_color}" stroke-width="{border_width}"/>\n'
    page_content += content
    page_content += '  </g>\n'

    all_content.append(page_content)

# Add all defs at the beginning
if all_defs:
    combined += '  <defs>\n'
    for defs in all_defs:
        combined += defs
    combined += '  </defs>\n'

# Add white background
combined += f'  <rect x="0" y="0" width="{total_width}" height="{total_height}" fill="white"/>\n'

# Add all content
for content in all_content:
    combined += content

# Close the combined SVG
combined += '</svg>\n'

# Write output (output_file already set from command-line arguments)
with open(output_file, 'w') as f:
    f.write(combined)

print(f"\nCombined SVG created: {output_file}")
print(f"Total dimensions: {total_width}pt × {total_height}pt")
