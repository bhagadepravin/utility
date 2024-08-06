#!/bin/bash

# Constants
SEARCH_DIR="/usr/hdf/3.3.1.0-10/"
BACKUP_DIR="/tmp/jar_backup"
# wget https://repo1.maven.org/maven2/ch/qos/reload4j/reload4j/1.2.19/reload4j-1.2.19.jar
REPLACEMENT_JAR="/root/reload4j-1.2.19.jar"
JAR_FILES=("log4j-1.2.16.jar" "log4j-1.2.17.jar")

# Functions

print_info() {
    echo -e "\033[36m>> INFO: $1\033[0m"
}

print_success() {
    echo -e "\033[32m✔ SUCCESS: $1\033[0m"
}

print_warning() {
    echo -e "\033[33m⚠ WARNING: $1\033[0m"
}

print_error() {
    echo -e "\033[31m✘ ERROR: $1\033[0m"
}

backup_files() {
    print_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    for jar in "${JAR_FILES[@]}"; do
        find "$SEARCH_DIR" -type f -name "$jar" | while read -r file; do
            local backup_file="$BACKUP_DIR/$(realpath --relative-to="$SEARCH_DIR" "$file")"
            mkdir -p "$(dirname "$backup_file")"
            cp --preserve=mode,timestamps "$file" "$backup_file"
            print_success "Backed up: $file to $backup_file"
        done
    done
}

replace_files() {
    local dry_run=0
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            --dry-run) dry_run=1 ;;
            *) print_error "Invalid option: $1"; exit 1 ;;
        esac
        shift
    done

    print_info "Replacing jar files..."
    for jar in "${JAR_FILES[@]}"; do
        find "$SEARCH_DIR" -type f -name "$jar" | while read -r file; do
            if (( dry_run )); then
                print_info "Would replace: $file with $REPLACEMENT_JAR"
            else
                if [[ -f "$REPLACEMENT_JAR" ]]; then
                    local old_ownership
                    old_ownership=$(stat -c "%U:%G" "$file")
                    cp --preserve=mode,timestamps "$REPLACEMENT_JAR" "$file"
                    chown "$old_ownership" "$file"
                    print_success "Replaced: $file with $REPLACEMENT_JAR"
                else
                    print_error "Replacement jar file $REPLACEMENT_JAR not found!"
                    exit 1
                fi
            fi
        done
    done
}

restore_files() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        print_error "Backup directory $BACKUP_DIR does not exist!"
        exit 1
    fi

    print_info "Restoring files from backup..."
    find "$BACKUP_DIR" -type f | while read -r backup_file; do
        local relative_path
        relative_path=$(realpath --relative-to="$BACKUP_DIR" "$backup_file")
        local target_file="$SEARCH_DIR/$relative_path"
        if [[ -f "$target_file" ]]; then
            local backup_owner
            backup_owner=$(stat -c "%U:%G" "$backup_file")
            cp --preserve=mode,timestamps "$backup_file" "$target_file"
            chown "$backup_owner" "$target_file"
            print_success "Restored: $target_file from $backup_file"
        else
            print_warning "Target file $target_file does not exist. Skipping restore."
        fi
    done
}

# Main script
case "$1" in
    backup)
        backup_files
        ;;
    replace)
        replace_files "$@"
        ;;
    restore)
        restore_files
        ;;
    *)
        print_error "Usage: $0 {backup|replace|restore} [options]"
        exit 1
        ;;
esac
