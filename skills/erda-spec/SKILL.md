---
name: erda-spec
description: Explain, review, and author ERDA specification files based on parser-supported fields. Use when users need help understanding or editing dice.yml and pipeline.yml, want field-level guidance, or need answers grounded in the ERDA parser rather than marketplace summaries.
---

# ERDA Spec

This skill explains ERDA spec files from parser-supported structure first.

Current scope:

- `dice.yml` field index and structure
- `pipeline.yml` field index and structure
- common action capability summaries
- demo-derived best-practice pipeline composition patterns
- parser-grounded guidance for reviewing or authoring these files

Current non-goals:

- live marketplace lookup
- action/addon search
- runtime or pipeline execution guidance

This skill is backed by summarized references derived from ERDA source analysis:

- source mapping: [`references/source-map.md`](references/source-map.md)
- dice fields: [`references/diceyml-fields.md`](references/diceyml-fields.md)
- pipeline fields: [`references/pipelineyml-fields.md`](references/pipelineyml-fields.md)
- semantic notes: [`references/semantic-notes.md`](references/semantic-notes.md)
- action capabilities: [`references/action-capabilities.md`](references/action-capabilities.md)
- best practices: [`references/best-practices.md`](references/best-practices.md)
- `dice.yml` review checklist: [`references/diceyml-review-checklist.md`](references/diceyml-review-checklist.md)
- `pipeline.yml` review checklist: [`references/pipelineyml-review-checklist.md`](references/pipelineyml-review-checklist.md)

## Use This Skill For

- explaining what fields are supported in `dice.yml`
- explaining what fields are supported in `pipeline.yml`
- explaining what parser behavior or validation is implied by a field
- explaining what a common pipeline action supports
- mapping a project stack to a recommended action chain
- reviewing a spec file against parser-supported structure
- reviewing a `dice.yml` systematically
- reviewing a `pipeline.yml` systematically
- drafting a spec file with parser-compatible fields
- answering "is this field supported?" questions

## Workflow

1. Identify whether the request is about `dice.yml`, `pipeline.yml`, action capability, or a combination of them.
2. Decide whether the answer is primarily about:
   - file structure and supported YAML fields
   - action capability and expected params or outputs
   - best-practice composition across multiple actions
3. Ground structure answers in the parser-derived field index, not in guesswork or market descriptions.
4. Ground action answers in the summarized action capability reference, not in generic CI/CD assumptions.
5. Use the semantic notes reference when a field exists but the real question is how merge, validation, upgrade, ref, or default dependency behavior works.
6. When a user asks about support, distinguish clearly between:
   - field exists in the parser structure
   - field may still require semantic validation elsewhere
7. If the request mixes file structure with action capability, answer the structure part first, then map the relevant actions and outputs.
8. Prefer concise field-level answers with exact YAML names.
9. When the user asks for a review, use the relevant review checklist instead of giving loose commentary.
10. When a user asks for a recommended pipeline, prefer the demo-derived patterns in the best-practices reference.
11. Do not expose development-machine paths or tell the user to inspect local source trees that are not part of the distributed skill.

## References

- Source map: [`references/source-map.md`](references/source-map.md)
- `dice.yml` field index: [`references/diceyml-fields.md`](references/diceyml-fields.md)
- `pipeline.yml` field index: [`references/pipelineyml-fields.md`](references/pipelineyml-fields.md)
- Semantic notes: [`references/semantic-notes.md`](references/semantic-notes.md)
- Action capabilities: [`references/action-capabilities.md`](references/action-capabilities.md)
- Best practices: [`references/best-practices.md`](references/best-practices.md)
- `dice.yml` review checklist: [`references/diceyml-review-checklist.md`](references/diceyml-review-checklist.md)
- `pipeline.yml` review checklist: [`references/pipelineyml-review-checklist.md`](references/pipelineyml-review-checklist.md)
