# ERDA Spec Source Map

This skill is intentionally grounded in ERDA source analysis, not in marketplace data.

## Current Source Of Truth

### `dice.yml`

The current field index is summarized from the ERDA `diceyml` parser structures and parser behavior.

Coverage basis:

- root object structure
- service, job, addon, endpoint, resource, and health-check structures
- environment and values-related structures
- custom parsing behavior for ports and volumes

### `pipeline.yml`

The current field index is summarized from the ERDA `pipelineyml` parser structures and parser behavior.

Coverage basis:

- root spec structure
- trigger, cron, storage, params, outputs, and lifecycle structures
- stage and typed action structures
- action-level resources, caches, policies, snippet config, and breakpoint-related fields

## What This Reference Means

The field indexes in this skill are derived from parser structs and parser-facing YAML tags.

They answer:

- what field names are recognized by the parser structure
- how fields are nested
- which blocks belong under which parent

They do not, by themselves, guarantee:

- business-level validity
- action marketplace availability
- platform permission compatibility
- runtime success

## Distribution Rule

The distributed skill must contain summarized conclusions, not workstation-specific paths.

If the skill is updated in the future, refresh the summaries from parser source again, but keep the shipped references path-free.

## Future Expansion

This skill now includes:

- parser-derived field references
- action capability summaries for common delivery actions
- demo-derived best-practice composition patterns
