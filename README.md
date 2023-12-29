# gitleaks-pre-commit-hook

## Installation

Use terminal to navigate into the root folder of your repository

Execute command
```shell
curl -o pre-commit https://raw.githubusercontent.com/tavor118sn/gitleaks-pre-commit-hook/main/pre-commit.sh \
    && chmod +x pre-commit \
    && mv pre-commit .git/hooks/
```

## Usage

To check you can use next commands:

Create a new file:
```shell
touch secret.txt
```

Put next content in the file:
```yaml
apiVersion: v1
data:
  token: NjU1Mj2Nz0OTpBQUZHR3k3Wn4REdjlwpRExmdEx5OV85cDF5U0tNSTNkeU00aE==
kind: Secret
metadata:
  creationTimestamp: null
  name: kbot
  namespace: demo
```

And try to commit:

```shell
git add secret.txt
git commit -m "Add secret.txt"
```
You should see gitleaks installed and next warning:

```shell
    ○
    │╲
    │ ○
    ○ ░
    ░    gitleaks

Finding:     token: NjU1Mj2Nz0OTpBQUZHR3k3Wn4REdjlwpRExmdEx5OV85cDF5U0tNSTNkeU00aE==
kind: Secret
Secret:      NjU1Mj2Nz0OTpBQUZHR3k3Wn4REdjlwpRExmdEx5OV85cDF5U0tNSTNkeU00aE==
RuleID:      generic-api-key
Entropy:     5.027115
File:        secret.txt
Line:        3
Fingerprint: secret.txt:generic-api-key:3

12:10AM INF 1 commits scanned.
12:10AM INF scan completed in 14.1ms
12:10AM WRN leaks found: 1
```

To disable check, run:

```shell
git config hooks.gitleaks false
```
