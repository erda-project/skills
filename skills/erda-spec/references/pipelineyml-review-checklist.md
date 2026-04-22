# `pipeline.yml` Review Checklist

Use this checklist when reviewing an ERDA `pipeline.yml`.

## Review Order

1. confirm the file is authored in the intended version and top-level shape
2. inspect stages, typed action layout, and aliases
3. inspect refs, params, outputs, and namespaces
4. inspect action choice and ordering
5. inspect build-to-release-to-deploy wiring
6. inspect optional quality, test, snippet, or manual-gate behavior

## Top-Level Shape

Check:

- whether `version` is present and whether `1.1` is the intended authored form
- whether root blocks such as `on`, `stages`, `params`, `outputs`, and `envs` are placed correctly
- whether the file is using parser-supported root keys instead of guessed extensions

Common findings:

- legacy `1.0` content still being authored as if it were canonical
- misplaced root blocks

## Stage And Action Layout

Check:

- whether `stages` is a list and each stage contains a `stage` action list
- whether each typed action block uses the action type as the YAML key
- whether aliases are unique
- whether omitted aliases still remain unambiguous after defaulting to action type

Common findings:

- incorrect indentation causing multiple action types in one item
- duplicate alias names
- assuming `type:` is the action selector instead of using the YAML key

## Default Dependency Model

Check:

- whether the stage boundaries reflect the intended execution order
- whether reviewers understand that omitted `needs` means dependency on all previous-stage actions
- whether omitted `needNamespaces` means access to all previous-stage namespaces

Common findings:

- actions placed in the wrong stage and therefore wired to the wrong dependency set
- accidental broad namespace visibility

## Params, Outputs, And Refs

Check:

- whether pipeline-level `params` are used intentionally and named clearly
- whether action params reference prior outputs with valid syntax
- whether `outputs[]` at the root are pipeline outputs, not action-local values
- whether refs point to aliases or namespaces that are available at that stage

Common findings:

- `${...}` or `${{ outputs... }}` referencing an alias not yet available
- confusing root `outputs` with action outputs
- params designed without considering textual replacement behavior

## Envs, Secrets, And Validation

Check:

- whether `envs` keys look like valid environment variable names
- whether secret placeholders use valid format
- whether snippet or config placeholders are being used intentionally

Common findings:

- invalid env key names
- malformed `((secret))` syntax
- missing secret assumptions hidden inside otherwise valid YAML

## Action Choice

Check:

- whether the selected build action matches the repository stack
- whether `buildpack` is being used intentionally instead of a stack-specific action
- whether test, scan, or approval actions are placed where they make workflow sense

Common findings:

- using a generic action where a language-specific action would be clearer
- quality gates placed after artifact publication

## Build And Packaging Wiring

Check:

- whether build actions consume `${git-checkout}` or the correct checked-out workspace
- whether build outputs are passed into `release` through `image` mapping
- whether `release.params.dice_yml` points at the intended spec file
- whether service names in the image map align with `dice.yml`

Common findings:

- build action reading the wrong path
- missing or mismatched image mapping
- `release` pointing at the wrong `dice.yml`

## Deployment Wiring

Check:

- whether `dice` consumes `${release:OUTPUT:releaseID}`
- whether `dice` action version matches the intended deployment mode
- whether `dice 2.0` fields are used only when the pipeline needs them

Common findings:

- deployment action not wired to release output
- `dice 2.0` params used without the corresponding deployment intent

## Quality, Test, And Manual Gates

Check:

- whether `unit-test` or `sonar` occurs before `release`
- whether `manual-review` is used as a true gate rather than as decoration
- whether `api-test` is used for verification rather than packaging

Common findings:

- code quality stages after artifact creation
- API tests inserted without a prepared target environment

## Snippet Usage

Check:

- whether snippet params satisfy required values
- whether snippet param values stay within supported scalar-like shapes
- whether snippet output refs are wired into later actions correctly

Common findings:

- missing required snippet params
- complex param values that do not fit snippet rendering expectations

## Review Output Format

When writing review findings, prefer grouping by:

- structural shape problems
- dependency and ref problems
- build/release/deploy wiring problems
- validation and secret-rendering risks
- maintainability issues
