# ERDA Skills

ERDA skill collection for GitHub-based distribution.

This repository is organized as a multi-skill repo compatible with path-based installation. Each skill lives under `skills/<skill-name>/` and uses `SKILL.md` as its entry point.

The repository currently centers on two operational domains in ERDA:

- `erda-cicd`: CI/CD workflows driven by `erda-cli`, especially pipeline run, history, status, logs, and delivery-oriented troubleshooting
- `erda-runtime`: runtime status, instances, logs, and runtime health operations driven by `erda-cli`

Skills are intentionally backed by more than a single markdown file:

- `references/` captures command and workflow knowledge
- `assets/templates/` provides reusable workflow starters where useful
- `scripts/install-erda-cli.sh` installs or updates `erda-cli` from the alpha channel
- `scripts/doctor.sh` performs deterministic `erda-cli` prerequisite checks and runs the installer/updater

## Included Skills

- `erda-cicd`: operate and troubleshoot ERDA CI/CD workflows through `erda-cli`
- `erda-runtime`: inspect and operate ERDA runtimes via `erda-cli`

## Install From GitHub

This repository is intended to be distributed from GitHub, for example:

```bash
npx skills add tailabs/erda-skills
```

## Validate Installed Skills

After installation, validate the two skills with realistic prompts instead of generic questions.

For `erda-cicd`:

- ask how to run a pipeline from the current repository
- ask how to inspect pipeline status, history, and failed task logs
- ask for the correct troubleshooting order when a delivery flow fails

For `erda-runtime`:

- ask how to list runtimes for a workspace
- ask how to inspect runtime status for a specific runtime ID
- ask how to view service logs or instance logs with `--watch`

The concrete validation prompts are bundled in:

- `skills/erda-cicd/references/cli-capabilities.md`
- `skills/erda-runtime/references/operations.md`

## erda-cli Requirement

The operational skills depend on `erda-cli`. During package installation, `postinstall` runs the skill-local installer when available. If a user installs a skill by copying or path-based GitHub install, run the doctor script once; it installs `erda-cli` if missing and checks for updates if it is already installed.

Quick checks:

```bash
bash skills/erda-cicd/scripts/install-erda-cli.sh
bash skills/erda-cicd/scripts/doctor.sh
bash skills/erda-runtime/scripts/doctor.sh
```

## Repository Layout

```text
skills/
  erda-cicd/
    assets/
    references/
    scripts/
      install-erda-cli.sh
      doctor.sh
    SKILL.md
  erda-runtime/
    references/
    scripts/
      install-erda-cli.sh
      doctor.sh
    SKILL.md
```
