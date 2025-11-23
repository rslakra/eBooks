#!/usr/bin/env python3
"""
Script to find duplicate PDF files by comparing file hashes.
"""
import os
import hashlib
from collections import defaultdict
from pathlib import Path

def calculate_file_hash(filepath):
    """Calculate MD5 hash of a file."""
    hash_md5 = hashlib.md5()
    try:
        with open(filepath, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_md5.update(chunk)
        return hash_md5.hexdigest()
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return None

def find_duplicate_pdfs(root_dir):
    """Find all duplicate PDF files in the directory tree."""
    pdf_files = []
    hash_to_files = defaultdict(list)
    
    # Find all PDF files
    print("Scanning for PDF files...")
    root_path = Path(root_dir)
    for pdf_file in root_path.rglob("*.pdf"):
        pdf_files.append(pdf_file)
    
    print(f"Found {len(pdf_files)} PDF files. Calculating checksums...")
    
    # Calculate hashes for all PDF files
    for i, pdf_file in enumerate(pdf_files, 1):
        if i % 100 == 0:
            print(f"  Processed {i}/{len(pdf_files)} files...")
        
        file_hash = calculate_file_hash(pdf_file)
        if file_hash:
            hash_to_files[file_hash].append(str(pdf_file))
    
    # Find duplicates (hashes with more than one file)
    duplicates = {h: files for h, files in hash_to_files.items() if len(files) > 1}
    
    return duplicates

def main():
    root_dir = "/Users/rslakra/Workspaces/dGitHub/eBooks"
    duplicates = find_duplicate_pdfs(root_dir)
    
    if not duplicates:
        print("\nNo duplicate PDF files found.")
        return
    
    print(f"\n{'='*80}")
    print(f"Found {len(duplicates)} sets of duplicate PDF files:")
    print(f"{'='*80}\n")
    
    total_duplicate_files = 0
    for i, (file_hash, files) in enumerate(duplicates.items(), 1):
        print(f"Duplicate Set #{i} (Hash: {file_hash[:16]}...)")
        print(f"  Number of copies: {len(files)}")
        for file_path in sorted(files):
            file_size = os.path.getsize(file_path)
            print(f"    - {file_path} ({file_size:,} bytes)")
        print()
        total_duplicate_files += len(files) - 1  # -1 because one is the original
    
    print(f"{'='*80}")
    print(f"Summary:")
    print(f"  - Total duplicate sets: {len(duplicates)}")
    print(f"  - Total duplicate files (excluding originals): {total_duplicate_files}")
    print(f"  - Total space that could be freed: {sum(sum(os.path.getsize(f) for f in files[1:]) for files in duplicates.values()):,} bytes")
    print(f"{'='*80}")

if __name__ == "__main__":
    main()

