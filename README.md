# Markdown to PDF Template System

This template system allows you to easily convert Markdown files to professionally formatted PDFs using pandoc.

## Quick Start

### Using the Convert Script

The project now includes both Windows batch files and cross-platform shell scripts:

**Windows:**
```cmd
# Convert using Windows batch script
convert.bat myfile.md

# Convert with table of contents  
convert.bat myfile.md myfile.pdf --toc

# Convert template.md (if no arguments provided)
convert.bat
```

**Linux/macOS/Windows (with Git Bash or WSL):**
```bash
# Convert using cross-platform shell script
./convert.sh myfile.md

# Convert with table of contents
./convert.sh myfile.md myfile.pdf --toc

# Show help and list available files
./convert.sh
```

Both scripts automatically:
- Detect and use bibliography files (`refs.bib`)
- Detect and use citation style files (`apa.csl`)
- Choose the best available PDF engine
- Provide helpful error messages

1. **Copy the template**: Start with `template.md` and rename it to your desired filename
2. **Edit your content**: Modify the YAML frontmatter and content as needed
3. **Convert to PDF**: Run the appropriate conversion script for your platform

## Files in This Template

| File | Purpose |
|------|---------|
| `template.md` | Template markdown file with example content and YAML frontmatter |
| `convert.bat` | Windows conversion script (batch file) |
| `convert.sh` | Cross-platform conversion script (Linux/macOS/Windows with Git Bash) |
| `setup.bat` | Automated setup script for Windows |
| `setup.sh` | Automated setup script for Linux/macOS |
| `refs.bib` | Bibliography file for citations |
| `apa.csl` | APA citation style file |
| `config.txt` | Configuration reference and options |
| `REQUIREMENTS.md` | Detailed list of all dependencies and installation instructions |
| `README.md` | This documentation file |

## Usage Examples

### Basic Conversion
```cmd
convert.bat mydocument.md
```
This creates `mydocument.pdf` using default settings.

### Custom Output Name
```cmd
convert.bat input.md output.pdf
```

### With Table of Contents
```cmd
convert.bat mydocument.md mydocument.pdf --toc
```

## Customizing Your Documents

### YAML Frontmatter Options

The YAML frontmatter at the top of your markdown file controls the document formatting:

```yaml
---
title: "Your Document Title"
author: "Your Name"
date: \today                    # Uses LaTeX \today command
bibliography: refs.bib          # Path to bibliography file
csl: apa.csl                   # Citation style file
geometry: margin=1in           # Page margins
fontsize: 12pt                 # Font size
linestretch: 1.5              # Line spacing (1.5 = 1.5x spacing)
documentclass: article         # LaTeX document class
header-includes:               # Additional LaTeX packages
  - \usepackage{setspace}
  - \usepackage{fancyhdr}
---
```

### Common Document Classes
- `article` - Default, good for papers and reports
- `report` - For longer documents with chapters
- `book` - For book-length documents
- `letter` - For formal letters

### Citation and Bibliography

1. **Add references** to `refs.bib` in BibTeX format:
```bibtex
@article{author2023,
  author={John Author},
  title={Article Title},
  journal={Journal Name},
  year={2023}
}
```

2. **Cite in your markdown**: `[@author2023]` or `@author2023`

3. **Citations will appear** automatically in your chosen style (APA by default)

### Math Support

The template includes math support:
- Inline math: `$E = mc^2$`
- Block math: `$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$`

### Code Syntax Highlighting

Code blocks with language specification get syntax highlighting:

```python
def hello_world():
    print("Hello, World!")
```

## Quick Setup

### Automated Setup (Recommended)

For a completely automated setup experience, use the provided setup scripts:

#### Windows
```cmd
# Run the setup script (will install dependencies automatically)
setup.bat
```

#### Linux/macOS
```bash
# Make the setup script executable and run it
chmod +x setup.sh
./setup.sh
```

The setup scripts will:
- Check for existing installations
- Install Pandoc, LaTeX distribution, and Git
- Verify the installation
- Test the converter with a sample document

### Manual Prerequisites

If you prefer manual installation, you need:

1. **Pandoc** - [Download from pandoc.org](https://pandoc.org/installing.html)
2. **LaTeX distribution** (for PDF generation):
   - **Windows**: MiKTeX or TeX Live
   - **macOS**: MacTeX
   - **Linux**: TeX Live

For detailed dependency information, see [REQUIREMENTS.md](REQUIREMENTS.md).

### Quick Manual Installation

#### Windows
```cmd
# Using Chocolatey (recommended)
choco install pandoc miktex git

# Using Windows Package Manager
winget install pandoc miktex git

# Or download manually from:
# Pandoc: https://pandoc.org/installing.html  
# MiKTeX: https://miktex.org/download
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install pandoc texlive-latex-base texlive-latex-extra git

# Fedora
sudo dnf install pandoc texlive-scheme-basic git

# Arch Linux
sudo pacman -S pandoc texlive-core texlive-latexextra git
```

#### macOS
```bash
# Using Homebrew
brew install pandoc mactex git
```

## Troubleshooting

### Common Issues

1. **"pandoc: command not found"**
   - Install pandoc and ensure it's in your PATH

2. **"LaTeX Error: File 'article.cls' not found"**
   - Install a LaTeX distribution (MiKTeX, TeX Live, etc.)

3. **Bibliography not working**
   - Ensure `refs.bib` exists and contains valid BibTeX entries
   - Check that citations in markdown use correct syntax: `[@key]`

4. **Math not rendering**
   - Ensure you're using `xelatex` or `lualatex` as the PDF engine
   - Check that math expressions are properly formatted

### Testing Your Installation

Run the template conversion to test everything:

```cmd
convert.bat template.md test.pdf
```

If successful, you should get a `test.pdf` file with the template content.

## Advanced Customization

### Using Different Citation Styles

Download `.csl` files from the [Citation Style Language repository](https://github.com/citation-style-language/styles) and reference them in your YAML frontmatter:

```yaml
csl: chicago-author-date.csl  # Chicago style
csl: ieee.csl                 # IEEE style
csl: nature.csl              # Nature journal style
```

### Custom LaTeX Templates

You can create custom pandoc templates for more control over formatting. Place them in your pandoc data directory and reference them:

```yaml
template: mytemplate.latex
```

### Filters and Extensions

Pandoc supports filters for additional functionality:
- `pandoc-crossref` - Cross-references for figures, tables, equations
- `pandoc-include` - Include content from other files

## Creating New Documents

1. Copy `template.md` to a new filename: 
   - Windows: `copy template.md mydocument.md`
   - Linux/macOS: `cp template.md mydocument.md`
2. Edit the YAML frontmatter with your document information
3. Replace the content with your writing
4. Convert to PDF:
   - Windows: `convert.bat mydocument.md`
   - Linux/macOS: `./convert.sh mydocument.md`

## Getting Started After Cloning

When you clone or download this repository to a new computer:

1. **Run the setup script** for your platform:
   - Windows: Double-click `setup.bat` or run from command prompt
   - Linux/macOS: `chmod +x setup.sh && ./setup.sh`

2. **Test the installation**:
   - Windows: `convert.bat template.md`
   - Linux/macOS: `./convert.sh template.md`

3. **Start creating documents** using the template system

The setup scripts will handle all dependency installation and configuration automatically.

## Support

- [Pandoc Documentation](https://pandoc.org/MANUAL.html)
- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)
- [Citation Style Language](https://citationstyles.org/)

Happy writing! 📝