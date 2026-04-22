# `pipeline.yml` Field Index

This index is summarized from the ERDA `pipeline.yml` parser structures.

## Root Fields

- `version`
- `name`
- `on`
- `triggers`
- `storage`
- `envs`
- `cron`
- `cron_compensator`
- `stages`
- `params`
- `outputs`
- `lifecycle`
- `breakpoint`

## `on`

Supported trigger blocks:

- `push`
- `merge`

### `on.push`

- `branches`
- `tags`

### `on.merge`

- `branches`

## `storage`

Supported fields:

- `context`

## `cron_compensator`

Supported fields:

- `enable`
- `latest_first`
- `stop_if_latter_executed`

## `stages`

`stages` is a list. Each stage contains:

- `stage`

`stage` is a list of typed action blocks, where the key is the action type and the value is the action body.

## Action Body Fields

Each action body may contain:

- `alias`
- `description`
- `version`
- `params`
- `labels`
- `workspace`
- `image`
- `shell`
- `commands`
- `loop`
- `timeout`
- `resources`
- `caches`
- `policy`
- `snippet_config`
- `if`
- `disable`
- `namespaces`
- `breakpoint`

## `resources`

Supported fields:

- `cpu`
- `max_cpu`
- `mem`
- `disk`
- `network`

## `caches[]`

Supported fields:

- `key`
- `path`

## `policy`

Supported fields:

- `type`

## `snippet_config`

Supported fields:

- `source`
- `name`
- `labels`

## `params[]`

Pipeline input parameters support:

- `name`
- `required`
- `default`
- `desc`
- `type`

## `outputs[]`

Pipeline outputs support:

- `name`
- `desc`
- `ref`

## `lifecycle[]`

Each lifecycle hook entry supports:

- `hook`
- `client`
- `labels`

## `breakpoint`

The parser exposes a root `breakpoint` field and action-level `breakpoint` field. The concrete shape comes from protobuf types used by the pipeline system.

## Practical Notes

- `version` supports `1.1` and the parser also handles older `1.0`/`1` content through upgrade logic.
- `stages` execute in series, while actions inside one stage are modeled as parallel peers.
- action type is not a fixed field name like `type`; it is the YAML key of each typed action block.
- `params` and `outputs` at the root are pipeline-level inputs and outputs, not action-level `params`.
- some internal parser fields such as `needs` are not user-authored YAML in this structure and are not part of this public field index.
