# kuard

## Description
kuard deployment

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] kuard`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree kuard`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init kuard
kpt live apply kuard --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
