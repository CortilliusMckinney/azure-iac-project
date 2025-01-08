# Version Control Procedures

## Versioning Strategy

Our project follows Semantic Versioning (SemVer):

- MAJOR version for incompatible API changes
- MINOR version for backward-compatible functionality
- PATCH version for backward-compatible bug fixes

## Changelog Management

1. Before each release:

   - Run ./scripts/version/update-changelog.sh
   - Review and organize changes
   - Update version number
   - Commit changes

2. After major infrastructure changes:
   - Document changes immediately
   - Include any security implications
   - Note any required follow-up actions
