# ERDA Runtime Prerequisites

This skill must not depend on repository-level shared files to remain usable.

## Required Discovery Order

When the skill needs to verify CLI availability:

1. check `command -v erda-cli`
2. if `erda-cli` is missing, run the skill-local installer: `bash scripts/install-erda-cli.sh`
3. if installation cannot make `erda-cli` available but `command -v erda` succeeds, use `erda` as a fallback executable

When `erda-cli` is present, check for updates before continuing:

```bash
erda-cli update set-default alpha
erda-cli update
```

The installer is idempotent. It installs with:

```bash
curl -fsSL https://erda-release.oss-cn-hangzhou.aliyuncs.com/cli/scripts/install.sh | bash -s -- alpha
```

## Required Verification Commands

Prefer this minimal sequence:

```bash
erda-cli version
erda-cli whoami
erda-cli runtime --help
```

If the local executable is `erda` rather than `erda-cli`, use the same commands with `erda`.

## Failure Note

If `whoami` fails, do not immediately assume the user is logged out.

Possible causes include:

- missing authentication
- network reachability problems
- proxy or gateway restrictions

Confirm the failure mode before concluding that the local login state is invalid.

## Fallback Rule

If any helper file is unavailable, do not block on the missing file. Fall back to direct CLI probing and continue with the diagnosis.
