# PolyLinux Pathfinder: Filesystem Navigation

This repository builds a deterministic ten-level Linux filesystem-navigation exercise for PolyLinux on Buildroot and v86.

Each learner and date receives different answers, layouts, names, sizes, and one of sixteen coherent data themes. The teaching objective and answer shape of each level remain stable.

## Seed contract

For level `N`, the generator hashes the exact UTF-8 concatenation:

```text
USER_ID + YYYY-MM-DD + SYSTEM_PASSWORD + LEVEL_PASSWORD_ROOT + N
```

There are no separators and no trailing newline. Independent fixture values use `SHA256(level_seed + ":" + label)`.

## Guest installation

Run as root from this directory:

```sh
./install.sh
```

For automated deployment:

```sh
USER_ID=student@example.edu CURRENT_DATE=2026-07-31 ./install.sh --non-interactive --no-login
```

The installer creates `level1` through `level10`, evidence under `/srv/filesystem-navigation/cases`, and root-only expected answers under `/var/lib/filesystem-navigation/answers`.

## Validation

Run deterministic tests without creating accounts:

```sh
./test.sh
```

After a guest installation, validate all generated evidence through the intended investigation paths:

```sh
./verify.sh
```

See `LEVELS.md` for curriculum invariants and `TOOLSET.md` for baseline requirements.
