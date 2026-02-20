# Documentation Index

## Current (stable filenames)
Use these links for the latest maintained documentation:

- [GDD (FR-QC)](./GDD_FR_QC.md)
- [GDD (EN-GB)](./GDD_EN_GB.md)
- [Patch Notes](./PATCH_NOTES.md)
- [Versioning](./VERSIONING.md)
- [MVP Checklist](./MVP_CHECKLIST.md)
- [PR Milestones](./PR_MILESTONES.md)

## Release archives
Versioned snapshots are archived under `docs/releases/<tag>/`.

- [v0.1.1 archive](./releases/v0.1.1/)
- [v0.1.2 archive](./releases/v0.1.2/)
- [v0.1.3 archive](./releases/v0.1.3/)
- [v0.1.4 archive](./releases/v0.1.4/)

Each release folder keeps a snapshot of the docs as published for that tag.

## How to release (maintainer checklist)
1. Commit documentation updates.
2. Tag the release commit (example: `git tag -a v0.1.4 -m "v0.1.4"` then `git push origin v0.1.4`).
3. Create a GitHub Release for `v0.1.4` and use `docs/PATCH_NOTES.md` as the release notes body.
