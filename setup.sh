#!/bin/bash

# Markdown to PDF Converter Setup Script (Linux)
# This script will install the required dependencies for the
# Markdown to PDF conversion system on various Linux distributions.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
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

print_header() {
    echo
    echo "================================================================"
    echo "          Markdown to PDF Converter Setup (Linux)"
    echo "================================================================"
    echo
    echo "This script will install the required dependencies for the"
    echo "Markdown to PDF conversion system."
    echo
    echo "Required dependencies:"
    echo "- Pandoc (document converter)"
    echo "- TeX Live (LaTeX distribution)"
    echo "- Git (if not already installed)"
    echo
}

# Detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    else
        DISTRO="unknown"
    fi
    
    print_info "Detected distribution: $DISTRO"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
check_permissions() {
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root. This is generally not recommended."
        print_info "The script will install packages system-wide."
    else
        print_info "Running as regular user. May need sudo for package installation."
    fi
    echo
}

# Check current installations
check_installations() {
    echo "[1/4] Checking Pandoc installation..."
    if command_exists pandoc; then
        print_status "Pandoc is already installed"
        pandoc --version | head -n 1
        NEED_PANDOC=false
    else
        print_error "Pandoc not found - will install"
        NEED_PANDOC=true
    fi

    echo
    echo "[2/4] Checking LaTeX installation..."
    if command_exists pdflatex; then
        print_status "LaTeX distribution is already installed"
        pdflatex --version | head -n 1
        NEED_LATEX=false
    else
        print_error "LaTeX distribution not found - will install TeX Live"
        NEED_LATEX=true
    fi

    echo
    echo "[3/4] Checking Git installation..."
    if command_exists git; then
        print_status "Git is already installed"
        git --version
        NEED_GIT=false
    else
        print_error "Git not found - will install"
        NEED_GIT=true
    fi

    echo
    echo "[4/4] Checking Python (optional for advanced features)..."
    if command_exists python3; then
        print_status "Python is already installed"
        python3 --version
    elif command_exists python; then
        print_status "Python is already installed"
        python --version
    else
        print_error "Python not found (optional - needed for some pandoc filters)"
    fi
}

# Install packages based on distribution
install_packages() {
    echo
    echo "================================================================"
    echo "                    Installing Dependencies"
    echo "================================================================"
    echo

    case $DISTRO in
        ubuntu|debian)
            print_info "Using apt package manager..."
            
            # Update package list
            echo "Updating package list..."
            sudo apt update
            
            # Install packages
            PACKAGES=""
            if [ "$NEED_PANDOC" = true ]; then
                PACKAGES="$PACKAGES pandoc"
            fi
            if [ "$NEED_LATEX" = true ]; then
                PACKAGES="$PACKAGES texlive-latex-base texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra"
            fi
            if [ "$NEED_GIT" = true ]; then
                PACKAGES="$PACKAGES git"
            fi
            
            if [ -n "$PACKAGES" ]; then
                echo "Installing: $PACKAGES"
                sudo apt install -y $PACKAGES
            fi
            ;;
            
        fedora|centos|rhel)
            print_info "Using dnf/yum package manager..."
            
            # Determine package manager
            if command_exists dnf; then
                PKG_MGR="dnf"
            elif command_exists yum; then
                PKG_MGR="yum"
            else
                print_error "No compatible package manager found"
                exit 1
            fi
            
            # Install packages
            PACKAGES=""
            if [ "$NEED_PANDOC" = true ]; then
                PACKAGES="$PACKAGES pandoc"
            fi
            if [ "$NEED_LATEX" = true ]; then
                PACKAGES="$PACKAGES texlive-scheme-basic texlive-latex texlive-latex-extra"
            fi
            if [ "$NEED_GIT" = true ]; then
                PACKAGES="$PACKAGES git"
            fi
            
            if [ -n "$PACKAGES" ]; then
                echo "Installing: $PACKAGES"
                sudo $PKG_MGR install -y $PACKAGES
            fi
            ;;
            
        arch)
            print_info "Using pacman package manager..."
            
            # Update package database
            sudo pacman -Sy
            
            # Install packages
            PACKAGES=""
            if [ "$NEED_PANDOC" = true ]; then
                PACKAGES="$PACKAGES pandoc"
            fi
            if [ "$NEED_LATEX" = true ]; then
                PACKAGES="$PACKAGES texlive-core texlive-latexextra"
            fi
            if [ "$NEED_GIT" = true ]; then
                PACKAGES="$PACKAGES git"
            fi
            
            if [ -n "$PACKAGES" ]; then
                echo "Installing: $PACKAGES"
                sudo pacman -S --noconfirm $PACKAGES
            fi
            ;;
            
        opensuse*)
            print_info "Using zypper package manager..."
            
            # Install packages
            PACKAGES=""
            if [ "$NEED_PANDOC" = true ]; then
                PACKAGES="$PACKAGES pandoc"
            fi
            if [ "$NEED_LATEX" = true ]; then
                PACKAGES="$PACKAGES texlive-latex texlive-latex-extra"
            fi
            if [ "$NEED_GIT" = true ]; then
                PACKAGES="$PACKAGES git"
            fi
            
            if [ -n "$PACKAGES" ]; then
                echo "Installing: $PACKAGES"
                sudo zypper install -y $PACKAGES
            fi
            ;;
            
        *)
            print_error "Unsupported distribution: $DISTRO"
            echo
            echo "Please install the following packages manually:"
            if [ "$NEED_PANDOC" = true ]; then
                echo "- pandoc"
            fi
            if [ "$NEED_LATEX" = true ]; then
                echo "- texlive (or equivalent LaTeX distribution)"
            fi
            if [ "$NEED_GIT" = true ]; then
                echo "- git"
            fi
            echo
            echo "You can also download Pandoc from: https://pandoc.org/installing.html"
            return 1
            ;;
    esac
}

# Verify installation
verify_installation() {
    echo
    echo "================================================================"
    echo "                    Verifying Installation"
    echo "================================================================"
    echo

    echo "Testing Pandoc..."
    if command_exists pandoc; then
        print_status "Pandoc installation verified"
        pandoc --version | head -n 1
    else
        print_error "Pandoc verification failed"
        echo "  You may need to restart your terminal or add Pandoc to PATH"
    fi

    echo
    echo "Testing LaTeX..."
    if command_exists pdflatex; then
        print_status "LaTeX installation verified"
        pdflatex --version | head -n 1
    else
        print_error "LaTeX verification failed"
        echo "  You may need to restart your terminal or install additional TeX packages"
    fi

    echo
    echo "Testing the converter with template..."
    if [ -f "template.md" ]; then
        echo "Running test conversion..."
        chmod +x convert.sh 2>/dev/null || true
        
        if [ -f "convert.sh" ]; then
            ./convert.sh template.md test-output.pdf 2>/dev/null
        elif [ -f "convert.bat" ]; then
            # Try to run Windows batch file if available
            bash convert.bat template.md test-output.pdf 2>/dev/null || true
        else
            # Direct pandoc test
            pandoc template.md -o test-output.pdf --pdf-engine=pdflatex 2>/dev/null || true
        fi
        
        if [ -f "test-output.pdf" ]; then
            print_status "Test conversion successful! Created test-output.pdf"
            rm -f test-output.pdf
        else
            print_error "Test conversion failed"
        fi
    else
        print_warning "template.md not found - skipping test conversion"
    fi
}

# Make convert script executable
setup_scripts() {
    echo
    echo "Setting up scripts..."
    
    if [ -f "convert.sh" ]; then
        chmod +x convert.sh
        print_status "Made convert.sh executable"
    fi
    
    if [ -f "setup.sh" ]; then
        chmod +x setup.sh
        print_status "Made setup.sh executable"
    fi
}

# Main installation function
main() {
    print_header
    detect_distro
    check_permissions
    check_installations
    
    # Check if anything needs to be installed
    if [ "$NEED_PANDOC" = false ] && [ "$NEED_LATEX" = false ] && [ "$NEED_GIT" = false ]; then
        echo
        print_status "All dependencies are already installed!"
        verify_installation
        setup_scripts
        return 0
    fi
    
    echo
    echo "================================================================"
    echo "                    Installation Options"
    echo "================================================================"
    echo
    echo "The following packages will be installed:"
    [ "$NEED_PANDOC" = true ] && echo "- Pandoc"
    [ "$NEED_LATEX" = true ] && echo "- TeX Live (LaTeX distribution)"
    [ "$NEED_GIT" = true ] && echo "- Git"
    echo
    
    read -p "Do you want to proceed with installation? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_packages
        verify_installation
        setup_scripts
        
        echo
        echo "================================================================"
        echo "                         Setup Complete"
        echo "================================================================"
        echo
        echo "Your Markdown to PDF converter is ready to use!"
        echo
        echo "Quick start:"
        echo "1. Copy template.md to a new file: cp template.md mydocument.md"
        echo "2. Edit your content in mydocument.md"
        echo "3. Convert to PDF: ./convert.sh mydocument.md"
        echo "   (or: pandoc mydocument.md -o mydocument.pdf --pdf-engine=pdflatex)"
        echo
        echo "For more information, see README.md"
        echo
    else
        echo
        echo "Installation cancelled. You can run this script again anytime."
        echo
        echo "To install manually:"
        [ "$NEED_PANDOC" = true ] && echo "- Install pandoc using your distribution's package manager"
        [ "$NEED_LATEX" = true ] && echo "- Install texlive using your distribution's package manager"
        [ "$NEED_GIT" = true ] && echo "- Install git using your distribution's package manager"
        echo
    fi
}

# Run main function
main "$@"