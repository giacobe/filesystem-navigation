---
title: "PolyLinux Pathfinder: Filesystem Navigation"
short_title: "Pathfinder"
panel_title: "Learning Path"
form_url: "https://forms.office.com/Pages/ResponsePage.aspx?id=RY30fNs9iUOpwcEVUm61LvTNagO6dAdDlZnocMnGFFZUMTFBMlVUREtCRFJDWjlWVjdLU1gwMzM3US4u"

---

# PolyLinux Pathfinder: Filesystem Navigation

Learn to move confidently through a Linux filesystem, including absolute and relative paths, hidden entries, directory trees, metadata, symbolic links, and hard links.

## Starting the exercise

Log in as `root`. The VM automatically starts the installer and asks for your email address. Confirm it carefully because your email, the exercise date, and protected exercise passwords determine your unique evidence and answers.

After installation you enter `level1`. Start each level with:

```sh
pwd
ls
cat README.txt
```

Each home directory contains a `data` link to that level's evidence.

## Moving between levels

Levels are independently accessible:

```sh
nextlevel
prevlevel
```

These commands do not require the previous answer. Reloading the browser VM resets the exercise.

## Submitting answers

Every `README.txt` gives the exact answer format. Case, punctuation, separators, filename extensions, and leading slashes matter. Do not add quotation marks or explanatory text. Submit one answer for each level through the exercise form.


## Command reference

| Command | Use |
|---|---|
| `pwd` | Show the current absolute path |
| `cd PATH` | Move to an absolute or relative path |
| `ls -la` | Include hidden entries and long metadata |
| `ls -li` | Include inode numbers |
| `cat FILE` | Read a selected file |
| `find PATH ...` | Search beneath a controlled starting path |
| `file PATH` | Identify an entry's type |
| `readlink PATH` | Display a symbolic link's stored target |
| `readlink -f PATH` | Normalize a resolvable link chain |

Absolute paths begin with `/`. Relative paths begin at the current directory. `.` means the current directory and `..` means its parent. Names beginning with `.` are hidden from ordinary `ls` output.

## Progressive hints

### Level 1

The path in the instructions begins at `/`, so your current directory does not affect it.

### Level 2

Use `pwd` after changing to the stated starting directory. Each `..` removes one path component.

### Level 3

Try `ls -la data`. Repeat the hidden-entry inspection inside any hidden directory you discover.

### Level 4

Read `TASK.txt` first. Explore only the named branch and section, then report the path relative to `data`.

### Level 5

Translate every clue into a `find` predicate. Exact byte sizes use the `c` suffix with `-size`.

### Level 6

Use `find` with exact `-perm` and `-size` predicates. A matching size alone or matching mode alone is insufficient.

### Level 7

`ls -l` distinguishes a symbolic link from a regular file. A relative link target is interpreted from the directory containing the link.

### Level 8

Two independent files can have identical content. Hard links are proven by a shared inode number, and their link count reflects the additional name.

### Level 9

Inspect each stored target with `readlink`, or normalize the working chain with `readlink -f`. Do not follow the deliberate loop.

### Level 10

Resolve the alias first, then use long and inode-oriented `ls` output to check the target's permissions, link count, and inode. Compare its inode with the named recovery file before reading the answer.

## Troubleshooting

- If a path reports “No such file or directory,” run `pwd` and check every component's spelling and case.
- If a directory appears empty, include hidden entries with `ls -la`.
- If `cat` reports that an entry is a directory, inspect it with `ls` instead.
- If a symbolic link fails, inspect its stored target with `readlink` and remember that relative targets start from the link's directory.
- If you leave the intended evidence directory, return home with `cd` and reread `README.txt`.
