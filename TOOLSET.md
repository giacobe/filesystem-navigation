# Toolset

## Learner-facing commands

| Command | Purpose |
|---|---|
| `pwd` | Print the current absolute path |
| `cd` | Change directories with absolute or relative paths |
| `ls` | List ordinary and hidden entries; inspect long and inode views |
| `cat`, `head` | Read selected evidence |
| `find` | Search by scope, type, name, and exact byte size |
| `file` | Distinguish regular files, directories, and links when needed |
| `readlink` | Inspect and normalize symbolic-link targets |
| `grep`, `sed`, `sort`, `awk` | Select clues and canonicalize multi-field answers |

## Generator and installer dependencies

The installer and reference solvers also require `adduser`, `base64`, `basename`, `chmod`, `chown`, `cp`, `cut`, `date`, `dirname`, `id`, `ln`, `mkdir`, `passwd`, `printf`, `rm`, `sha256sum`, `su`, `touch`, `tr`, and `wc`.

## Baseline status

Use the existing `polylinux-builder/config-sets/basic` profile. Its built rootfs has been inspected and contains `find`, `ls`, `readlink`, `basename`, `dirname`, and `ln`. The exercise does not require `stat`. The installer fails before mutation if a required command is absent.
