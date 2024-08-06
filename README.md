# Script Description

The `manage_jars.sh` script provides functionality to manage specific JAR files in a directory. It supports backing up existing JAR files, replacing them with a new JAR file, and restoring them from a backup. The script ensures that file ownership and permissions are preserved during these operations. The JAR files are handled in the directory `/usr/hdf/3.3.1.0-10/`, and the backup is stored in `/tmp/jar_backup`.

## Features

1. **Backup**: Creates backups of specified JAR files, preserving their directory structure and file attributes.
2. **Replace**: Replaces specified JAR files with a new JAR file. It supports a dry-run option to preview the changes without actually performing them.
3. **Restore**: Restores JAR files from the backup directory to their original locations, preserving ownership and permissions.

## Usage

### 1. Backup JAR Files

To create backups of the specified JAR files, run:

```
./manage_jars.sh backup
```

This command will create a backup of the JAR files in the `/tmp/jar_backup` directory, preserving their directory structure and file attributes.

### 2. Replace JAR Files

To replace the existing JAR files with a new JAR file:

- **Dry Run**: Preview the replacement changes without actually performing them:

```
./manage_jars.sh replace --dry-run
```

- **Actual Replacement**: Replace the JAR files with the new JAR file:

```
./manage_jars.sh replace
```

This command will replace the JAR files with the file specified by `REPLACEMENT_JAR` and preserve the original file ownership and permissions.

### 3. Restore JAR Files

To restore JAR files from the backup:

```
./manage_jars.sh restore
```

This command will restore the JAR files from the `/tmp/jar_backup` directory to their original locations, maintaining the file ownership and permissions.

## Script File

Ensure the script has executable permissions before running it:

```
chmod +x manage_jars.sh
```

## Script Content

The script contains three main functions for backing up, replacing, and restoring JAR files. It uses `find` to locate the specified JAR files in the target directory and handles file attributes and ownership during backup and restoration processes. The backup directory is created if it does not exist, and the ownership of the replaced or restored files is maintained.


## Backup
<img width="1510" alt="image" src="https://github.com/user-attachments/assets/1c4a2936-9bc4-43d5-b704-cc98effbc7af">

## Replace + Dryrun
<img width="1509" alt="image" src="https://github.com/user-attachments/assets/d0228f9c-6b18-409a-ae84-296c7fe286d7">

