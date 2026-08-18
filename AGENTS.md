# AGENTS.md

## Scope

These rules apply to the entire `iPad1Files` repository.

## Mission

Maintain iPad 1 / iOS 5.1.1 compatibility while evolving iPad1Files into the shared file/storage foundation of the iPad1 application ecosystem.

## Required reading before changes

Read:

```text
SESSION.md
ARCHITECTURE.md
INTEGRATION.md
TESTING.md
TASKS.md
CLAUDE.md
```

## Compatibility rules

- target armv7
- deployment target iOS 5.1
- physical target iOS 5.1.1
- Objective-C only
- manual reference counting
- no Swift
- avoid post-iOS-5 APIs unless optional and guarded
- keep memory usage suitable for iPad 1

## Storage rules

Never casually change:

```text
/var/mobile/Media/iPad1Files
```

App-specific state belongs under:

```text
AppData/<ApplicationName>
```

## Code organization

Reusable filesystem behavior belongs in `IP1*` classes.

Do not duplicate low-level file operations inside view controllers.

## Safety

- never silently overwrite files
- confirm destructive bulk operations
- protect the canonical root from deletion
- prefer explicit errors
- preserve user data on partial failures where possible

## Integration

Do not invent new companion-app contracts without updating `INTEGRATION.md`.

## Build validation

Before a release-related commit:

```bash
git diff --check
make clean
rm -rf .theos
make package FINALPACKAGE=1
```

Then run relevant physical-device checks from `TESTING.md`.

## Git hygiene

Do not commit:

```text
.theos/
packages/
*.deb
obj/
*.dSYM/
```

Update `SESSION.md` whenever:

- device IP changes
- release version changes
- integration contract changes
- current next action changes
- major physical-device test status changes
