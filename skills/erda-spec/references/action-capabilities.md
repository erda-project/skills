# Action Capabilities

This reference summarizes common ERDA pipeline actions and the capability surface they expose.

Use this file when the user asks:

- which action should be used for a language stack
- what params an action supports
- what outputs can be consumed by later actions
- how actions chain together in `pipeline.yml`
- what test, scan, or review actions exist beyond build and deploy

## Common Delivery Chain

The most common application delivery chain is:

1. `git-checkout`
2. a build action such as `golang`, `java`, `js`, or `dockerfile`
3. `release`
4. `dice`

In this chain:

- `git-checkout` provides source context
- the build action produces an `image` output
- `release` binds `dice.yml` with built images and outputs `releaseID`
- `dice` deploys the released artifact and outputs `runtimeID`

## `git-checkout`

Purpose:

- clone the source repository into a new workspace
- expose commit and branch metadata to later stages

Common params:

- `uri`
- `branch`
- `username`
- `password`
- `depth`

Outputs:

- `commit`
- `author`
- `author_date`
- `committer`
- `committer_date`
- `branch`
- `message`

Practical notes:

- `branch` supports branch, tag, or commit-SHA style references.
- `depth` enables shallow clone behavior.
- Later actions usually consume the checked-out path with `${git-checkout}` or the action alias.

## `golang`

Purpose:

- build a Go project and package it into a runnable image

Common params:

- `context`
- `service`
- `command`
- `target`
- `assets`
- `package`

Outputs:

- `image`

Practical notes:

- `context` is the code path, commonly `${git-checkout}`.
- `service` should align with the service name expected by later release mapping.
- `target` is the built binary path.

## `java`

Purpose:

- build a Java project and package it into a runnable image

Common params:

- `jdk_version`
- `build_type`
- `build_cmd`
- `target`
- `container_type`
- `container_version`
- `workdir`
- `swagger_path`
- `service_name`
- `copy_assets`
- `service`

Outputs:

- `image`

Practical notes:

- `workdir` is typically `${git-checkout}` or a subdirectory with the build root.
- `target` is the jar or war artifact path relative to `workdir`.
- `service_name` is the non-deprecated field for matching a `dice.yml` service.
- `service` exists but is explicitly marked deprecated in action metadata.
- `container_type` and `container_version` determine the runtime image packaging strategy.

## `js`

Purpose:

- build a Node.js application and package it into an image

Common params:

- `workdir`
- `dependency_cmd`
- `build_cmd`
- `container_type`
- `dest_dir`
- `registry`

Outputs:

- `image`

Practical notes:

- `workdir` is required and commonly points to `${git-checkout}`.
- `dependency_cmd` defaults to `npm ci`.
- `container_type` distinguishes packaging modes.
- `dest_dir` is the build artifact directory consumed for packaging.

## `dockerfile`

Purpose:

- build an image from a custom `Dockerfile`

Common params:

- `workdir`
- `path`
- `build_args`
- `image`
- `registry`

Outputs:

- `image`

Practical notes:

- `path` is the Dockerfile path relative to `workdir`.
- `build_args` is a map that becomes Docker `ARG` values.
- `image` and `registry` are structured maps, not plain strings.

## `release`

Purpose:

- create a deployable release artifact by combining `dice.yml` with built image outputs

Common params:

- `dice_yml`
- `cross_cluster`
- `replacement_images`
- `init_sql`
- `dice_development_yml`
- `dice_test_yml`
- `dice_staging_yml`
- `dice_production_yml`
- `check_diceyml`
- `image`
- `services`
- `aab_info`
- `tag_version`
- `release_mobile`

Outputs:

- `releaseID`

Practical notes:

- `dice_yml` is usually `${git-checkout}/dice.yml`.
- `image` is the main mapping from service name to build-action image output.
- `check_diceyml` can be turned off in special template-heavy cases, but the default behavior assumes validation should happen.
- Workspace-specific `dice_*_yml` files allow per-environment release material.
- `release_mobile` is a structured object, not a scalar field.

## `dice`

Purpose:

- deploy a release artifact onto the ERDA platform

Common params in `1.0`:

- `release_id`
- `time_out`
- `workspace`
- `callback`
- `release_id_path`

Additional params in `2.0`:

- `release_name`
- `type`
- `application_name`
- `deploy_without_branch`

Outputs:

- `runtimeID`

Practical notes:

- `release_id` usually comes from `${release:OUTPUT:releaseID}`.
- `dice 2.0` adds artifact-type oriented deployment fields.
- `release_id_path` exists for compatibility but is marked deprecated in action metadata.
- `runtimeID` is the key bridge into runtime-oriented diagnosis after deployment.

## `sonar`

Purpose:

- run code quality analysis and optionally enforce quality-gate status

Common params:

- `code_dir`
- `must_gate_status_ok`
- `sonar_host_url`
- `sonar_login`
- `sonar_password`
- `sonar_project_key`

Practical notes:

- `code_dir` is the analysis root.
- this action is a quality stage, not a packaging stage.
- `must_gate_status_ok` controls whether gate result should block the pipeline.

## `unit-test`

Purpose:

- run unit tests as a dedicated test-management action

Common params:

- `context`
- `name`
- `command`
- `go_dir`

Practical notes:

- `context` usually points at the checked-out repository.
- `go_dir` is particularly relevant for Go test layouts.
- this action fits before packaging and release, not after deployment.

## `manual-review`

Purpose:

- insert a human approval step into the pipeline

Common params:

- `processor`
- `wain_time_interval_sec`

Practical notes:

- `processor` is a string array of reviewer identifiers.
- use this action as a delivery gate rather than a build step.

## `api-test`

Purpose:

- execute a single API test with request definition, extracted outputs, and assertions

Common params:

- `name`
- `url`
- `method`
- `params`
- `headers`
- `body`
- `out_params`
- `asserts`

Outputs:

- outputs can be derived dynamically from `out_params`

Practical notes:

- `out_params` makes this action useful in multi-step API test orchestration.
- `asserts` can fail the action even when the HTTP call itself succeeds.
- this action is more suited to verification flows than build flows.

## `buildpack`

Purpose:

- provide a unified builder abstraction for supported stacks and multi-module applications

Common params:

- `context`
- `modules`
- `bp_repo`
- `bp_ver`
- `bp_args`
- `http_proxy`
- `https_proxy`
- `only_build`
- `language`
- `build_type`
- `container_type`

Practical notes:

- this action is useful when the platform should auto-detect or centrally manage build behavior.
- `modules` is structured and important for multi-module repositories.
- `only_build` separates compilation from image creation.

## Output Hand-Off Rules

When chaining actions, these outputs are the most important:

- `${git-checkout}` or `${alias}` for workspace hand-off
- `${build-action:OUTPUT:image}` for image hand-off into `release`
- `${release:OUTPUT:releaseID}` for release hand-off into `dice`
- `${dice:OUTPUT:runtimeID}` for post-deployment runtime investigation
- `api-test` can expose later-consumable values through `out_params`

## Review Checklist

When reviewing a pipeline that uses these actions, check:

- whether the chosen build action matches the project stack
- whether required workspace or context params point to the checked-out source
- whether service-to-image mapping in `release` matches `dice.yml` service names
- whether outputs are referenced with the correct expression syntax
- whether `dice` action version and params match the intended deployment mode
- whether quality, test, or approval actions are placed before release and deployment
