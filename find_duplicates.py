#!/usr/bin/env python3
"""
Unified script to find duplicate files by content (hash) and filename similarity.
Supports multiple file extensions and generates detailed reports.
"""
import os
import sys
import hashlib
import argparse
from collections import defaultdict
from pathlib import Path
from difflib import SequenceMatcher

def calculate_file_hash(filepath):
    """Calculate MD5 hash of a file."""
    hash_md5 = hashlib.md5()
    try:
        with open(filepath, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_md5.update(chunk)
        return hash_md5.hexdigest()
    except Exception as e:
        print(f"Error reading {filepath}: {e}", file=sys.stderr)
        return None

def similarity_ratio(name1, name2):
    """Calculate similarity ratio between two filenames."""
    return SequenceMatcher(None, name1.lower(), name2.lower()).ratio()

def normalize_filename(filename):
    """Normalize filename for comparison (remove common variations)."""
    # Remove extension
    name = Path(filename).stem.lower()
    # Remove common suffixes like -0, -1, (1), etc.
    import re
    name = re.sub(r'[-_]\d+$', '', name)  # Remove -0, -1, _2, etc.
    name = re.sub(r'\(\d+\)$', '', name)   # Remove (1), (2), etc.
    name = re.sub(r'\s+', ' ', name)      # Normalize whitespace
    return name.strip()

def find_files_by_extension(root_dir, extensions):
    """Find all files with specified extensions."""
    files = []
    root_path = Path(root_dir)
    
    for ext in extensions:
        # Handle both .ext and ext formats
        if not ext.startswith('.'):
            ext = '.' + ext
        pattern = f"*{ext}"
        for file_path in root_path.rglob(pattern):
            files.append(file_path)
    
    return files

def find_duplicates_by_content(files, show_progress=True):
    """Find duplicate files by comparing content hashes."""
    hash_to_files = defaultdict(list)
    
    if show_progress:
        print(f"Calculating checksums for {len(files)} files...")
    
    for i, file_path in enumerate(files, 1):
        if show_progress and i % 100 == 0:
            print(f"  Processed {i}/{len(files)} files...")
        
        file_hash = calculate_file_hash(file_path)
        if file_hash:
            hash_to_files[file_hash].append(str(file_path))
    
    # Find duplicates (hashes with more than one file)
    duplicates = {h: files for h, files in hash_to_files.items() if len(files) > 1}
    
    return duplicates

def find_duplicates_by_filename(files, similarity_threshold=0.85):
    """Find duplicate files by comparing filenames."""
    # Group files by normalized filename
    normalized_groups = defaultdict(list)
    
    for file_path in files:
        filename = os.path.basename(file_path)
        normalized = normalize_filename(filename)
        normalized_groups[normalized].append(str(file_path))
    
    # Find groups with multiple files
    filename_duplicates = {}
    for normalized, file_list in normalized_groups.items():
        if len(file_list) > 1:
            # Further check similarity for files with same normalized name
            similar_groups = []
            processed = set()
            
            for i, file1 in enumerate(file_list):
                if file1 in processed:
                    continue
                
                group = [file1]
                name1 = os.path.basename(file1)
                
                for j, file2 in enumerate(file_list[i+1:], i+1):
                    if file2 in processed:
                        continue
                    
                    name2 = os.path.basename(file2)
                    similarity = similarity_ratio(name1, name2)
                    
                    if similarity >= similarity_threshold:
                        group.append(file2)
                        processed.add(file2)
                
                if len(group) > 1:
                    similar_groups.append(group)
                    processed.add(file1)
            
            if similar_groups:
                for idx, group in enumerate(similar_groups):
                    key = f"{normalized}_group_{idx}"
                    filename_duplicates[key] = group
    
    return filename_duplicates

def generate_report(content_duplicates, filename_duplicates, output_file=None, root_dir=None):
    """Generate a detailed report of duplicates."""
    output = sys.stdout if output_file is None else open(output_file, 'w')
    
    try:
        print("=" * 80, file=output)
        print("DUPLICATE FILES REPORT", file=output)
        print("=" * 80, file=output)
        print(file=output)
        
        # Content-based duplicates
        if content_duplicates:
            print("=" * 80, file=output)
            print(f"CONTENT-BASED DUPLICATES (Identical Files): {len(content_duplicates)} sets", file=output)
            print("=" * 80, file=output)
            print(file=output)
            
            total_duplicate_files = 0
            total_wasted_space = 0
            
            for i, (file_hash, files) in enumerate(sorted(content_duplicates.items()), 1):
                print(f"Duplicate Set #{i} (Hash: {file_hash[:16]}...)", file=output)
                print(f"  Number of copies: {len(files)}", file=output)
                
                file_sizes = []
                for file_path in sorted(files):
                    file_size = os.path.getsize(file_path)
                    file_sizes.append(file_size)
                    rel_path = os.path.relpath(file_path, root_dir) if root_dir else file_path
                    print(f"    - {rel_path} ({file_size:,} bytes)", file=output)
                
                # Calculate wasted space (all but one copy)
                wasted = sum(file_sizes[1:])
                total_wasted_space += wasted
                total_duplicate_files += len(files) - 1
                
                if wasted > 0:
                    print(f"  Wasted space: {wasted:,} bytes ({wasted / 1024 / 1024:.2f} MB)", file=output)
                print(file=output)
            
            print("-" * 80, file=output)
            print(f"Content Duplicates Summary:", file=output)
            print(f"  - Total duplicate sets: {len(content_duplicates)}", file=output)
            print(f"  - Total duplicate files (excluding originals): {total_duplicate_files}", file=output)
            print(f"  - Total space that could be freed: {total_wasted_space:,} bytes ({total_wasted_space / 1024 / 1024:.2f} MB)", file=output)
            print(file=output)
        else:
            print("No content-based duplicates found.", file=output)
            print(file=output)
        
        # Filename-based duplicates
        if filename_duplicates:
            print("=" * 80, file=output)
            print(f"FILENAME-BASED DUPLICATES (Similar Names): {len(filename_duplicates)} sets", file=output)
            print("=" * 80, file=output)
            print(file=output)
            print("NOTE: These files have similar names but may have different content.", file=output)
            print("Please review manually before removing.", file=output)
            print(file=output)
            
            for i, (key, files) in enumerate(sorted(filename_duplicates.items()), 1):
                print(f"Similar Name Set #{i}", file=output)
                print(f"  Number of files: {len(files)}", file=output)
                
                for file_path in sorted(files):
                    file_size = os.path.getsize(file_path)
                    rel_path = os.path.relpath(file_path, root_dir) if root_dir else file_path
                    print(f"    - {rel_path} ({file_size:,} bytes)", file=output)
                print(file=output)
        else:
            print("No filename-based duplicates found.", file=output)
            print(file=output)
        
        print("=" * 80, file=output)
        
    finally:
        if output_file and output != sys.stdout:
            output.close()

def main():
    parser = argparse.ArgumentParser(
        description='Find duplicate files by content (hash) and filename similarity',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Find duplicate PDF files
  python3 find_duplicates.py --ext pdf

  # Find duplicate DOCX files
  python3 find_duplicates.py --ext docx

  # Find duplicates for multiple extensions
  python3 find_duplicates.py --ext pdf --ext docx --ext doc

  # Find duplicates and save to report file
  python3 find_duplicates.py --ext pdf --output report.txt

  # Find duplicates by filename only (faster, no hash calculation)
  python3 find_duplicates.py --ext pdf --filename-only

  # Find duplicates by content only (default)
  python3 find_duplicates.py --ext pdf --content-only
        """
    )
    
    parser.add_argument(
        '--ext',
        '--extension',
        dest='extensions',
        action='append',
        required=True,
        help='File extension(s) to search for (e.g., pdf, docx, doc). Can be specified multiple times.'
    )
    
    parser.add_argument(
        '--root',
        '--root-dir',
        dest='root_dir',
        default='/Users/rslakra/Workspaces/dGitHub/eBooks',
        help='Root directory to search (default: /Users/rslakra/Workspaces/dGitHub/eBooks)'
    )
    
    parser.add_argument(
        '--output',
        '-o',
        dest='output_file',
        default=None,
        help='Output file for the report (default: print to stdout)'
    )
    
    parser.add_argument(
        '--content-only',
        action='store_true',
        help='Only find duplicates by content (hash comparison)'
    )
    
    parser.add_argument(
        '--filename-only',
        action='store_true',
        help='Only find duplicates by filename similarity'
    )
    
    parser.add_argument(
        '--similarity-threshold',
        type=float,
        default=0.85,
        help='Similarity threshold for filename matching (0.0-1.0, default: 0.85)'
    )
    
    parser.add_argument(
        '--no-progress',
        action='store_true',
        help='Suppress progress messages'
    )
    
    args = parser.parse_args()
    
    # Validate arguments
    if args.content_only and args.filename_only:
        print("Error: Cannot use both --content-only and --filename-only", file=sys.stderr)
        sys.exit(1)
    
    # Find files
    print(f"Scanning for files with extensions: {', '.join(args.extensions)}...")
    files = find_files_by_extension(args.root_dir, args.extensions)
    print(f"Found {len(files)} files.")
    print()
    
    if not files:
        print("No files found with the specified extensions.")
        return
    
    content_duplicates = {}
    filename_duplicates = {}
    
    # Find duplicates by content
    if not args.filename_only:
        content_duplicates = find_duplicates_by_content(files, show_progress=not args.no_progress)
        print()
    
    # Find duplicates by filename
    if not args.content_only:
        print("Analyzing filenames for similar names...")
        filename_duplicates = find_duplicates_by_filename(files, args.similarity_threshold)
        print()
    
    # Generate report
    if args.output_file:
        print(f"Generating report to: {args.output_file}")
    else:
        print("Generating report...")
    print()
    
    generate_report(
        content_duplicates,
        filename_duplicates,
        output_file=args.output_file,
        root_dir=args.root_dir
    )
    
    if args.output_file:
        print(f"\nReport saved to: {args.output_file}")

if __name__ == "__main__":
    main()

