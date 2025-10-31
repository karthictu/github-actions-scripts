# github-actions-scripts
Scripts and Workflows for GitHub Actions

### PR Title Validation
- Validates PR title and throws error if not conforming to specified standard
- Can be used in subsequent CI steps in **needs** such that all the other steps/jobs are skipped if title is invalid.
- Can be added as a pre-requisite to merge PR to base branches.
