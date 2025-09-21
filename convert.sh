#!/bin/bash

# Cross-platform Markdown to PDF converter script
# Works on Linux, macOS, and Windows (with Git Bash/WSL)
# Usage: ./convert.sh [input.md] [output.pdf] [additional pandoc options...]

set -e  # Exit on error

# Colors for output (if terminal supports it)
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to show usage information
show_usage() {
    echo "Markdown to PDF Converter"
    echo "========================="
    echo
    echo "Usage: $0 [input.md] [output.pdf] [pandoc options...]"
    echo
    echo "Examples:"
    echo "  $0 mydocument.md                    # Creates mydocument.pdf"
    echo "  $0 mydocument.md output.pdf         # Creates output.pdf"
    echo "  $0 mydocument.md output.pdf --toc   # Creates output.pdf with table of contents"
    echo "  $0                                  # Shows this help and lists .md files"
    echo
    echo "Available markdown files in current directory:"
    for file in *.md; do
        if [[ -f "$file" ]]; then
            echo "  $file"
        fi
    done
    echo
}

# Function to get file size in a cross-platform way
get_file_size() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f%z "$file" 2>/dev/null || echo "unknown"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        # Linux
        stat -c%s "$file" 2>/dev/null || echo "unknown"
    else
        # Windows/Other - try both formats
        stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "unknown"
    fi
}

# Check if running on Windows (including Git Bash, WSL, etc.)
is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]] || [[ "$(uname -s)" == MINGW* ]] || [[ "$(uname -s)" == CYGWIN* ]]
}

# Main conversion function
convert_document() {
    local input="$1"
    local output="$2"
    shift 2
    local additional_options=("$@")
    
    # Validate input file
    if [[ ! -f "$input" ]]; then
        print_error "File '$input' not found."
        return 1
    fi
    
    # Generate output filename if not provided
    if [[ -z "$output" ]]; then
        output="${input%.*}.pdf"
    fi
    
    print_info "Converting '$input' to '$output'..."
    
    # Check for pandoc
    if ! command_exists pandoc; then
        print_error "Pandoc is not installed or not in PATH."
        echo
        echo "Please install pandoc:"
        if is_windows; then
            echo "  - Download from: https://pandoc.org/installing.html"
            echo "  - Or use chocolatey: choco install pandoc"
            echo "  - Or use winget: winget install pandoc"
        else
            echo "  - Linux: Use your distribution's package manager"
            echo "    Ubuntu/Debian: sudo apt install pandoc"
            echo "    Fedora: sudo dnf install pandoc"
            echo "    Arch: sudo pacman -S pandoc"
            echo "  - macOS: brew install pandoc"
        fi
        return 1
    fi
    
    # Build pandoc options
    local pandoc_options=()
    
    # Add PDF engine - try to use the best available
    local pdf_engine="pdflatex"  # Default
    if command_exists xelatex; then
        pdf_engine="xelatex"
    elif command_exists lualatex; then
        pdf_engine="lualatex"
    fi
    pandoc_options+=("--pdf-engine=$pdf_engine")
    
    # Check for bibliography and citation files
    if [[ -f "refs.bib" ]]; then
        pandoc_options+=("--citeproc" "--bibliography=refs.bib")
        print_info "Using bibliography: refs.bib"
    fi
    
    if [[ -f "apa.csl" ]]; then
        pandoc_options+=("--csl=apa.csl")
        print_info "Using citation style: apa.csl"
    fi
    
    # Add any additional options passed by user
    pandoc_options+=("${additional_options[@]}")
    
    # Perform the conversion
    echo "Running: pandoc \"$input\" -o \"$output\" ${pandoc_options[*]}"
    echo
    
    if pandoc "$input" -o "$output" "${pandoc_options[@]}"; then
        print_success "Conversion completed successfully!"
        
        if [[ -f "$output" ]]; then
            local file_size
            file_size=$(get_file_size "$output")
            print_success "Created: $output"
            if [[ "$file_size" != "unknown" ]]; then
                print_info "File size: $file_size bytes"
            fi
        fi
        
        return 0
    else
        print_error "Conversion failed."
        echo
        echo "Common issues and solutions:"
        echo "1. LaTeX not installed:"
        if is_windows; then
            echo "   - Install MiKTeX: https://miktex.org/download"
            echo "   - Or install TeX Live: https://www.tug.org/texlive/"
        else
            echo "   - Linux: Install texlive packages"
            echo "     Ubuntu/Debian: sudo apt install texlive-latex-base texlive-latex-extra"
            echo "     Fedora: sudo dnf install texlive-scheme-basic"
            echo "   - macOS: Install MacTeX: https://www.tug.org/mactex/"
        fi
        echo
        echo "2. Missing LaTeX packages:"
        echo "   - Install additional packages as needed"
        echo "   - Try using --pdf-engine=xelatex for better Unicode support"
        echo
        echo "3. Bibliography issues:"
        echo "   - Ensure refs.bib contains valid BibTeX entries"
        echo "   - Check citation syntax in markdown: [@key]"
        echo
        return 1
    fi
}

# Main script logic
main() {
    # Show usage if no arguments provided
    if [[ $# -eq 0 ]]; then
        show_usage
        return 0
    fi
    
    # Show version information
    if [[ "$1" == "--version" || "$1" == "-v" ]]; then
        echo "Markdown to PDF Converter Script"
        echo "Cross-platform wrapper for pandoc"
        echo
        if command_exists pandoc; then
            pandoc --version
        else
            echo "Pandoc not found - please install pandoc first"
            return 1
        fi
        return 0
    fi
    
    # Show help
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        show_usage
        echo
        echo "This script is a cross-platform wrapper around pandoc that:"
        echo "- Automatically detects and uses bibliography files (refs.bib)"
        echo "- Automatically detects and uses citation style files (*.csl)"
        echo "- Chooses the best available PDF engine"
        echo "- Provides helpful error messages and troubleshooting tips"
        echo "- Works on Linux, macOS, and Windows"
        echo
        return 0
    fi
    
    # Convert document
    convert_document "$@"
}

# Run main function with all arguments
main "$@"