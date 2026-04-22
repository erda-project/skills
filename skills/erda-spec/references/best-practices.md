# Best Practices

This reference summarizes common pipeline composition patterns for application delivery.

Use this file when the user asks:

- how to design a practical `pipeline.yml`
- which actions should be chained together
- what a Go, Java, Node.js, or Dockerfile-based pipeline usually looks like
- how to connect build outputs to `release` and `dice`
- where quality, test, or manual gates should be inserted

## Default Delivery Pattern

For most application repositories, the recommended high-level pattern is:

1. checkout source with `git-checkout`
2. build and package with a stack-specific action
3. create a release with `release`
4. deploy with `dice`

The hand-off normally looks like this:

- build action reads `${git-checkout}`
- `release` reads `dice.yml` from `${git-checkout}/dice.yml`
- `release` maps a service name to `${build-action:OUTPUT:image}`
- `dice` consumes `${release:OUTPUT:releaseID}`

Optional gates that fit naturally before `release`:

- `unit-test`
- `sonar`
- `manual-review`

Optional verification that can fit after deployment or against a target environment:

- `api-test`

## Go Application Pattern

Recommended action chain:

1. `git-checkout`
2. `golang`
3. `release`
4. `dice`

Recommended focus points:

- set `golang.params.context` to the checked-out source
- define an explicit build command
- set `target` to the built binary path
- keep the `release.image` key aligned with the service name in `dice.yml`

## Java Application Pattern

Recommended action chain:

1. `git-checkout`
2. `java`
3. `release`
4. `dice`

Recommended focus points:

- set `workdir` to the build root
- choose `build_type` explicitly, usually `maven` or `gradle`
- make `target` point to the actual jar or war output
- prefer `service_name` over deprecated `service`
- choose `container_type` based on the artifact form

## Node.js Application Pattern

Recommended action chain:

1. `git-checkout`
2. `js`
3. `release`
4. `dice`

Recommended focus points:

- set `workdir` to the checked-out source path
- keep `dependency_cmd` explicit if the repository requires a non-default install command
- choose `container_type` intentionally
- make `dest_dir` match the actual build output directory

## Custom Dockerfile Pattern

Recommended action chain:

1. `git-checkout`
2. `dockerfile`
3. `release`
4. `dice`

Recommended focus points:

- use this pattern when the repository already defines packaging logic in a Dockerfile
- keep `path` relative to `workdir`
- pass `build_args` only when the Dockerfile expects them
- ensure the `release.image` key still matches the service name in `dice.yml`

## Service Mapping Rule

The most important cross-file convention is:

- the key under `release.params.image`
- should match the target service name in `dice.yml`

If these names drift apart, the release can be structurally valid while still producing the wrong deployment artifact mapping.

## Quality And Gate Pattern

When a pipeline needs stronger delivery confidence, a practical pattern is:

1. `git-checkout`
2. one or more verification actions such as `unit-test` or `sonar`
3. a build action
4. optional `manual-review`
5. `release`
6. `dice`

Practical rule:

- keep code-quality and test actions before `release`, because they validate the source and build intent before artifact publication.

## API Verification Pattern

When a pipeline needs interface-level verification, a practical pattern is:

1. prepare or deploy the target system
2. run one or more `api-test` actions
3. pass values between API steps with `out_params`

Practical rule:

- use `api-test` for orchestration and assertion, not as a replacement for build or packaging actions.

## When To Consider `buildpack`

Prefer `buildpack` when:

- a repository is multi-module
- the platform should own most of the build strategy
- the team wants a unified builder instead of language-specific action selection

Prefer language-specific build actions when:

- the project already has a clear stack-specific pipeline
- the team wants explicit control over build commands and packaging behavior

## When To Use `release`

Use `release` when the pipeline needs to turn source plus built images into a deployable ERDA artifact.

Common responsibilities:

- load `dice.yml`
- inject built images into service definitions
- optionally include workspace-specific spec files
- produce `releaseID` for deployment

## When To Use `dice`

Use `dice` when the pipeline should immediately deploy after artifact creation.

Choose `dice 1.0` when:

- the simple release-to-runtime deployment path is enough

Choose `dice 2.0` when:

- deployment needs artifact type fields such as `type`
- deployment needs application-level artifact naming
- deployment needs `deploy_without_branch`

## Authoring Checklist

When drafting or reviewing a practical application pipeline, check:

- whether each stage has a clear single responsibility
- whether build actions consume the checked-out workspace rather than ad hoc paths
- whether `release` references the correct `dice.yml`
- whether image outputs are wired into `release`
- whether deployment starts from `${release:OUTPUT:releaseID}`
- whether the chosen action chain matches the project stack instead of forcing a generic template
