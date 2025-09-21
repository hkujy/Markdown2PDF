# Markdown to PDF Converter - Dependencies

This file lists all required and optional dependencies for the Markdown to PDF conversion system.

## Required Dependencies

### Core Tools
- **Pandoc** (>= 2.0)
  - Universal document converter
  - Download: https://pandoc.org/installing.html
  - Windows: Available via chocolatey, winget, or direct download
  - Linux: Available in most distribution repositories

- **LaTeX Distribution**
  - Required for PDF generation
  - Windows: MiKTeX (recommended) or TeX Live
    - MiKTeX: https://miktex.org/download
    - TeX Live: https://www.tug.org/texlive/
  - Linux: TeX Live (usually texlive-latex-base + texlive-latex-extra)
  - macOS: MacTeX

### Version Control
- **Git** (>= 2.0)
  - For version control and cloning repositories
  - Download: https://git-scm.com/downloads
  - Usually pre-installed on Linux, available via package managers

## Optional Dependencies

### Advanced Features
- **Python** (>= 3.6)
  - Required for some pandoc filters
  - Recommended for advanced document processing
  - Download: https://python.org/downloads/

### Pandoc Filters (Python packages)
- **pandoc-crossref**
  - Cross-references for figures, tables, equations
  - Install: pip install pandoc-crossref
  
- **pandoc-include**
  - Include content from other files
  - Install: pip install pandoc-include

- **pandocfilters**
  - Base library for creating custom filters
  - Install: pip install pandocfilters

### Additional LaTeX Packages
These are often included in full LaTeX distributions but may need separate installation:
- **setspace** - Line spacing control
- **fancyhdr** - Custom headers and footers  
- **graphicx** - Image support
- **hyperref** - Hyperlinks and bookmarks
- **amsmath** - Advanced math typesetting
- **amssymb** - Mathematical symbols
- **geometry** - Page layout control
- **xcolor** - Color support
- **listings** - Code syntax highlighting
- **booktabs** - Professional table formatting

## Development Tools (Optional)

### Text Editors/IDEs
- **Visual Studio Code** (recommended)
  - Excellent Markdown support
  - Extensions: Markdown Preview Enhanced, LaTeX Workshop
  - Download: https://code.visualstudio.com/

- **Typora** - WYSIWYG Markdown editor
- **Obsidian** - Knowledge management with Markdown
- **Vim/Neovim** - For command-line editing

### Package Managers

#### Windows
- **Chocolatey** (recommended)
  - Install: https://chocolatey.org/install
  - Allows easy installation: choco install pandoc miktex git
  
- **Windows Package Manager (winget)**
  - Built into Windows 10/11
  - Install packages: winget install pandoc

#### Linux
Package managers are distribution-specific:
- **Ubuntu/Debian**: apt
- **Fedora**: dnf
- **Arch Linux**: pacman
- **openSUSE**: zypper

#### macOS
- **Homebrew** (recommended)
  - Install: https://brew.sh/
  - Install packages: brew install pandoc mactex

## File Requirements

### Template Files
- **template.md** - Base template with YAML frontmatter
- **refs.bib** - Bibliography file (BibTeX format)
- **apa.csl** - Citation style file (APA format)

### Configuration Files
- **config.txt** - Default settings and options reference

### Scripts
- **convert.bat** - Windows conversion script
- **convert.sh** - Linux conversion script (cross-platform)
- **setup.bat** - Windows automated setup
- **setup.sh** - Linux automated setup

## Minimum System Requirements

### Windows
- Windows 7 or later
- 2GB free disk space (for full LaTeX installation)
- 1GB RAM minimum, 2GB recommended

### Linux
- Any modern Linux distribution (Ubuntu 18.04+, Fedora 30+, etc.)
- 2GB free disk space (for full TeX Live installation)
- 1GB RAM minimum, 2GB recommended

### macOS
- macOS 10.12 or later
- 4GB free disk space (for MacTeX)
- 2GB RAM minimum, 4GB recommended

## Installation Verification

After installation, verify with these commands:

```bash
# Check Pandoc
pandoc --version

# Check LaTeX
pdflatex --version

# Check Git
git --version

# Test conversion (if template.md exists)
pandoc template.md -o test.pdf --pdf-engine=pdflatex
```

## Troubleshooting

### Common Issues
1. **"pandoc: command not found"**
   - Install pandoc and ensure it's in your PATH
   
2. **"LaTeX Error: File 'article.cls' not found"**
   - Install a complete LaTeX distribution
   
3. **Bibliography not working**
   - Ensure refs.bib exists and contains valid BibTeX entries
   - Use --citeproc flag with pandoc
   
4. **Math equations not rendering**
   - Use appropriate PDF engine (xelatex or lualatex recommended)
   - Ensure amsmath package is available

### Getting Help
- Pandoc documentation: https://pandoc.org/MANUAL.html
- LaTeX documentation: https://www.latex-project.org/help/documentation/
- Issues with this template: Check README.md or open an issue on the repository

## License Information
- Pandoc: GPL v2+
- TeX Live/MiKTeX: Various open source licenses
- This template: MIT License (adjust as needed)