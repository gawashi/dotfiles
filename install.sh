#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BASEDIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
FORCE=false
INTERACTIVE=true

# Files to ignore
IGNORE_FILES=(
    ".git"
    ".gitignore"
    ".DS_Store"
    "README.md"
    "install.sh"
    "Brewfile"
    # Windows
    "install.ps1"
    "Microsoft.PowerShell_profile.ps1"
)

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -f, --force      Force overwrite existing files without backup"
    echo "  -y, --yes        Skip confirmation prompts"
    echo "  -d, --dry-run    Show what would be done without making changes"
    echo "  -b, --backup     Create backup even in dry-run mode"
    echo ""
    echo "Examples:"
    echo "  $0                 # Interactive mode with backup"
    echo "  $0 -y              # Auto-confirm all actions"
    echo "  $0 -d              # See what would be installed"
    echo "  $0 -f -y           # Force install without prompts"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

is_ignored() {
    local file="$1"
    for ignore in "${IGNORE_FILES[@]}"; do
        if [[ "$file" == "$ignore" ]]; then
            return 0
        fi
    done
    return 1
}

create_backup() {
    local file="$1"
    local target="$HOME/$file"
    
    if [[ -e "$target" && ! -L "$target" ]]; then
        if [[ ! -d "$BACKUP_DIR" ]]; then
            mkdir -p "$BACKUP_DIR"
            log_info "Created backup directory: $BACKUP_DIR"
        fi
        cp -r "$target" "$BACKUP_DIR/"
        log_info "Backed up $file to $BACKUP_DIR/"
    fi
}

install_file() {
    local file="$1"
    local source="$(realpath "$PWD/$file" 2>/dev/null || echo "$PWD/$file")"
    local target="$HOME/$file"
    
    # Check if target exists and is not a symlink to our file
    if [[ -e "$target" ]]; then
        if [[ -L "$target" ]]; then
            local current_target="$(readlink "$target" 2>/dev/null || echo "")"
            if [[ -n "$current_target" ]]; then
                # Convert to absolute path if it's relative
                if [[ "$current_target" != /* ]]; then
                    current_target="$(realpath "$(dirname "$target")/$current_target" 2>/dev/null || echo "$current_target")"
                fi
                
                if [[ "$current_target" == "$source" ]]; then
                    log_info "$file is already correctly linked"
                    return 0
                else
                    log_warning "$file is linked to $current_target (expected: $source)"
                fi
            fi
        else
            log_warning "$file exists but is not a symlink"
        fi
        
        if [[ "$FORCE" == false ]]; then
            create_backup "$file"
        fi
    fi
    
    # Create parent directory if needed
    local parent_dir="$(dirname "$target")"
    if [[ ! -d "$parent_dir" && "$DRY_RUN" == false ]]; then
        mkdir -p "$parent_dir"
    fi
    
    # Create symlink
    if [[ "$DRY_RUN" == false ]]; then
        ln -sf "$source" "$target"
        if [[ -d "$source" ]]; then
            log_success "Linked directory $file"
        else
            log_success "Linked $file"
        fi
    else
        if [[ -d "$source" ]]; then
            log_info "Would link directory $file -> $source"
        else
            log_info "Would link $file -> $source"
        fi
    fi
}

install_claude_symlink() {
    local source="$1"
    local target="$2"
    local label="$3"

    local parent_dir
    parent_dir="$(dirname "$target")"
    if [[ ! -d "$parent_dir" && "$DRY_RUN" == false ]]; then
        mkdir -p "$parent_dir"
    fi

    # Check if symlink already exists and points to correct source
    if [[ -L "$target" ]]; then
        local current_target
        current_target="$(readlink "$target" 2>/dev/null || echo "")"
        if [[ "$current_target" != /* ]]; then
            current_target="$(realpath "$(dirname "$target")/$current_target" 2>/dev/null || echo "$current_target")"
        fi
        if [[ "$current_target" == "$source" ]]; then
            log_info "$label is already correctly linked"
            return 0
        else
            log_warning "$label is linked to $current_target (expected: $source)"
        fi
    fi

    if [[ "$DRY_RUN" == false ]]; then
        ln -sf "$source" "$target"
        log_success "Linked $label"
    else
        log_info "Would link $label -> $source"
    fi
}

install_claude_skills() {
    local skills_source="$BASEDIR/.claude/skills"
    local skills_target="$HOME/.claude/skills"

    if [[ ! -d "$skills_source" ]]; then
        return 0
    fi

    for file in "$skills_source"/*.md; do
        [[ -f "$file" ]] || continue
        local filename
        filename="$(basename "$file")"
        install_claude_symlink "$(realpath "$file" 2>/dev/null || echo "$file")" "$skills_target/$filename" ".claude/skills/$filename"
    done
}

install_claude_rules() {
    local rules_source="$BASEDIR/.claude/rules"
    local rules_target="$HOME/.claude/rules"

    if [[ ! -d "$rules_source" ]]; then
        return 0
    fi

    for file in "$rules_source"/*.md; do
        [[ -f "$file" ]] || continue
        local filename
        filename="$(basename "$file")"
        install_claude_symlink "$(realpath "$file" 2>/dev/null || echo "$file")" "$rules_target/$filename" ".claude/rules/$filename"
    done
}

install_tools() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would install Claude Code plugins (superpowers, context7, serena)"
        log_info "Would install GSD via npx get-shit-done-cc@latest"
        return 0
    fi

    log_info "Installing Claude Code plugins..."
    # Note: verify exact syntax with 'claude plugin --help' if this fails
    if command -v claude &>/dev/null; then
        claude plugin install superpowers@claude-plugins-official || true
        claude plugin install context7@claude-plugins-official || true
        claude plugin install serena@claude-plugins-official || true
        log_success "Claude plugins installed"
    else
        log_warning "claude CLI not found — skipping plugin installs"
    fi

    log_info "Installing GSD..."
    if command -v npx &>/dev/null; then
        npx get-shit-done-cc@latest
        log_success "GSD installed"
    else
        log_warning "npx not found — skipping GSD install"
    fi
}

confirm() {
    local message="$1"
    if [[ "$INTERACTIVE" == false ]]; then
        return 0
    fi
    
    echo -n -e "${YELLOW}$message [y/N]: ${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -y|--yes)
                INTERACTIVE=false
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -b|--backup)
                # Force backup creation even in dry-run
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    cd "$BASEDIR"
    
    log_info "Starting dotfiles installation..."
    log_info "Base directory: $PWD"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi
    
    # Handle .claude skills and rules
    if [[ -d ".claude" ]]; then
        if confirm "Install Claude Code skills and rules?"; then
            if [[ "$DRY_RUN" == false ]]; then
                mkdir -p "$HOME/.claude/skills" "$HOME/.claude/rules"
            fi
            install_claude_skills
            install_claude_rules
        else
            log_info "Skipping Claude Code skills and rules"
        fi
    fi
    
    # Find all dotfiles and directories (excluding .claude)
    local dotfiles=()
    for file in .??*; do
        if ([[ -f "$file" ]] || [[ -d "$file" ]]) && ! is_ignored "$file" && [[ "$file" != ".claude" ]]; then
            dotfiles+=("$file")
        fi
    done
    
    if [[ ${#dotfiles[@]} -eq 0 ]]; then
        log_warning "No dotfiles found to install"
        exit 0
    fi
    
    # Show what will be installed
    log_info "Found ${#dotfiles[@]} dotfiles to install:"
    for file in "${dotfiles[@]}"; do
        echo "  - $file"
    done
    echo
    
    # Confirm installation
    if ! confirm "Continue with installation?"; then
        log_info "Installation cancelled"
        exit 0
    fi
    
    # Install files
    local installed=0
    for file in "${dotfiles[@]}"; do
        install_file "$file"
        ((installed++))
    done
    
    echo
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Dry run complete. $installed files would be processed"
    else
        log_success "Installation complete! $installed files processed"
        if [[ -d "$BACKUP_DIR" ]]; then
            log_info "Backups saved to: $BACKUP_DIR"
        fi
    fi
    
    # Install tools
    if confirm "Install Claude Code plugins and GSD?"; then
        install_tools
    else
        log_info "Skipping tool installs"
    fi

    # Show next steps
    echo
    log_info "Next steps:"
    echo "  - Restart your shell or run: source ~/.bashrc"
    echo "  - Check your configurations and customize as needed"
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "  - Review backups in: $BACKUP_DIR"
    fi
}

# Run main function
main "$@"
