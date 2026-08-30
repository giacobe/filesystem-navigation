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

## Build the browser VM

Use the `basic` configuration from
[`giacobe/buildroot-builder2`](https://github.com/giacobe/buildroot-builder2),
validated with Buildroot `2025.02.15`:

```sh
git clone https://github.com/giacobe/buildroot-builder2.git
cd buildroot-builder2
BUILDROOT_VERSION=2025.02.15 scripts/01-setup-buildroot.sh
scripts/02-build-baseline.sh --config basic
scripts/03-package-payload.sh \
  --repo https://github.com/giacobe/filesystem-navigation.git \
  --ref main \
  --baseline artifacts/basic-<timestamp> \
  --output artifacts/filesystem-navigation \
  --output-prefix filesystem-navigation
```

Replace `<timestamp>` with the stage-2 artifact directory. Review the manifest
and boot-test the exact generated `.bzImage` and `.rootfs.cpio.gz` pair in v86.

## Standard runtime contract

The current release uses the reversible PolyBandit exercise code, the versioned `seed-v1` deterministic seed, ten concurrent level generators, staged `README.txt` readiness, unrestricted `nextlevel`/`prevlevel` navigation, and no client-side answer store or checker. See `lab.json` for the authoritative level count, theme policy, Buildroot configuration, and browser artifact names.

Do not rebuild the assigned Buildroot baseline merely to package this lab. Package the repository payload into the configuration named by `buildroot_configuration`, preserve the baseline kernel, and publish the resulting `packaged.bzImage` and `packaged.rootfs.cpio.gz`.
