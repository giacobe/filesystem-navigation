# Level design

All semantic answers, target names, layouts, sizes, and theme choices are deterministic functions of labeled SHA-256 derivations. Correct targets are created before distractors.

| Level | Stable evidence | Primary learner task | Exact answer shape |
|---|---|---|---|
| 1 | File at a disclosed absolute path | Read evidence independently of the current directory | 12-character Base64url token |
| 2 | Sibling work and archive directories | Navigate with `.` and `..` relative components | 12-character Base64url token |
| 3 | Hidden directory, hidden target, and hidden decoys | Include dot-prefixed entries during inspection | 12-character Base64url token |
| 4 | Three-level branching directory tree | Follow tree clues and report a relative path | `branch/section/filename` |
| 5 | Regular files, directory decoy, and out-of-scope copy | Combine `find` scope, type, name, and exact size | 12-character Base64url token |
| 6 | Four candidate files with controlled modes and sizes | Search exact permission and size metadata with `find` | Filename stem without `.dat` |
| 7 | Relative symlink, path-text decoy, and target | Inspect and follow a symbolic link | 14-character Base64url token |
| 8 | Hard-linked pair, equal-content copy, and unrelated file | Compare inode numbers and link counts with `ls -li` | `name1|name2` in lexical order |
| 9 | Relative link chain, absolute link, broken link, and loop | Resolve a chain and normalize its destination | Absolute `/srv/...` path |
| 10 | Hidden target, symlink alias, hard-link recovery copy, metadata and archive decoy | Correlate path, link, inode, and mode evidence | 16-character Base64url token |

## Collision controls

- Level 3 creates exactly one hidden regular file ending in `-key`.
- Level 4 places its content marker in exactly one file within the selected branch and section.
- Level 5 near-matches each fail at least one of scope, type, name, or size.
- Level 6 only the target combines the requested mode and size.
- Level 8 the equal-content decoy is created independently and therefore has a different inode.
- Level 9 the intended chain is separate from the broken link and link loop.
- Level 10 the archive copy uses a separate inode, while only the target and recovery name share an inode.

## Grader interface

Expected answers are stored root-only at:

```text
/var/lib/filesystem-navigation/answers/level1
...
/var/lib/filesystem-navigation/answers/level10
```
