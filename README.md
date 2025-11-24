# eBooks

--- 
This repository contains an electronic books, which are categorized based
on the usability. It might be some of the books have copyright as most of these
are downloaded from the public links (and owner of those books, can send email
to remove that book from this repository, and I'll remove that one). I'm
maintaining it only for personal learning, so anyone can either download or
uses this repository AS IT IS with their own responsibility.

---

* Version: 1.0.0

---

## Folder Structure Conventions

---

```
/
├── BuildTools              # The build tools
├── Database                # The database scripts
├── Docker                  # The docker script
├── IDE                     # The IDE scripts
├── Java                    # The Java
├── Logs                    # The Logs
├── Mobile                  # The Mobile
├── OS                      # The OS Scripts
├── Python                  # The Python
├── Servers                 # The Server
├── VCS                     # The verson control system
└── README.md
```

## Duplicate File Finder

---

The repository includes a unified script `find_duplicates.py` to identify duplicate files by content (hash comparison) and filename similarity. This helps identify redundant files and free up storage space.

### Features

- **Content-based duplicates**: Compares file hashes (MD5) to find identical files
- **Filename-based duplicates**: Finds files with similar names (handles variations like `-0`, `-1`, `(1)`, etc.)
- **Multiple file extensions**: Supports any file extension (pdf, docx, doc, etc.)
- **Flexible search modes**: Can search by content only, filename only, or both
- **Detailed reports**: Generates comprehensive reports with file paths, sizes, and potential space savings

### Usage

#### Basic Commands

```bash
# Find duplicate PDF files (both content and filename)
python3 find_duplicates.py --ext pdf --output report.txt

# Find duplicate DOCX files
python3 find_duplicates.py --ext docx --output docx_report.txt

# Find duplicates for multiple extensions
python3 find_duplicates.py --ext pdf --ext docx --ext doc --output all_report.txt
```

#### Advanced Options

```bash
# Find only content-based duplicates (identical files by hash)
python3 find_duplicates.py --ext pdf --content-only --output content_duplicates.txt

# Find only filename-based duplicates (very fast, no hash calculation)
python3 find_duplicates.py --ext pdf --filename-only --output filename_duplicates.txt

# Search in a specific directory
python3 find_duplicates.py --ext pdf --root-dir "Computer" --output computer_duplicates.txt

# Adjust filename similarity threshold (0.0-1.0, default: 0.85)
python3 find_duplicates.py --ext pdf --similarity-threshold 0.9 --output report.txt

# Suppress progress messages
python3 find_duplicates.py --ext pdf --no-progress --output report.txt
```

#### Command Line Options

| Option | Description |
|-------|-------------|
| `--ext, --extension` | File extension(s) to search for (required, can be specified multiple times) |
| `--root, --root-dir` | Root directory to search (default: current directory) |
| `--output, -o` | Output file for the report (default: print to stdout) |
| `--content-only` | Only find duplicates by content (hash comparison) |
| `--filename-only` | Only find duplicates by filename similarity |
| `--similarity-threshold` | Similarity threshold for filename matching (0.0-1.0, default: 0.85) |
| `--no-progress` | Suppress progress messages |

### Report Format

The generated report includes:

1. **Content-based duplicates**: Lists files with identical content (same hash), showing:
   - Number of duplicate copies
   - File paths and sizes
   - Potential space savings

2. **Filename-based duplicates**: Lists files with similar names, showing:
   - Files that may be duplicates (requires manual review)
   - File paths and sizes

### Examples

```bash
# Find all duplicate PDFs in the repository
python3 find_duplicates.py --ext pdf --output duplicate_pdfs_report.txt

# Find duplicate DOCX files in a specific folder
python3 find_duplicates.py --ext docx --root-dir "English As Second Language" --output idioms_duplicates.txt

# Quick check for similar filenames only (no hash calculation)
python3 find_duplicates.py --ext pdf --filename-only --output similar_names.txt
```

### Notes

- Content-based duplicates are **definitely identical** and safe to remove (keeping one copy)
- Filename-based duplicates **may have different content** and should be reviewed manually before removal
- The script processes files efficiently, showing progress for large file sets
- Reports include relative paths and file sizes for easy review

---

# Reference

---

- [How Amazon Lambda works](https://newsletter.systemdesign.one/p/how-does-aws-lambda-work)
- [Dependency management with package-json to increase your project's health](https://thetshaped.dev/p/pin-your-dependencies-in-packagejson)
- [The importance of having a career growth plan in the engineering industry](https://newsletter.eng-leadership.com/p/the-importance-of-having-a-career)
- [In the real world, you might need more than a simple Work Queue](https://newsletter.systemdesignclassroom.com/p/in-the-real-world-you-might-need)
- [How to be Influential as a New Hire](https://thehustlingengineer.substack.com/p/how-to-be-influential-as-a-new-hire)
- [Session Management Demystified: Cookies, Tokens, and Security](https://blog.levelupcoding.com/p/luc-61-session-management-demystified-cookies-tokens-security)
- [Tips to become 10x better in Tech Interviews](https://www.leadership-letters.com/p/tips-to-become-10x-better-in-tech)
- [Forget code coverage! Use Mutation Testing](https://craftbettersoftware.com/p/forget-code-coverage-use-mutation)
- [Screaming Architecture](https://www.milanjovanovic.tech/blog/screaming-architecture)
- [Alexandre Zajac writes a weekly curating important articles](https://hungrymindsdev.substack.com/)
- [Git Large File Storage](https://git-lfs.github.com)



# Author

---

- [Rohtash Lakra](https://github.com/rslakra)
