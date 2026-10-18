---
name: GitLab CI and GitHub Actions
description: Write or fix CI pipelines - .gitlab-ci.yml for GitLab, .github/workflows/*.yml for GitHub Actions.
---

Pipelines cannot run here: no internet and no runner. Check the YAML with `yamllint -d relaxed FILE`, then run each job's commands locally to check them.

## Rules

- Jobs run the same commands as a developer: `cmake -S . -B build -G Ninja`, `cmake --build build`, `ctest --test-dir build --output-on-failure`. If the project has `CMakePresets.json`, use its presets: `cmake --workflow --preset <name>`.
- Pin versions: Docker images with a tag (`debian:trixie-slim`, not `latest`), GitHub actions with a major version.
- Test reports: `ctest --test-dir build --output-junit junit.xml` writes `build/junit.xml`.
- Secrets come from CI variables, never from the file.

## GitLab

```yaml
stages: [build, test]

default:
  image: debian:trixie-slim
  before_script:
    - apt-get update && apt-get install -y --no-install-recommends build-essential cmake ninja-build

build:
  stage: build
  script:
    - cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
    - cmake --build build
  artifacts:
    paths: [build/]

test:
  stage: test
  script:
    - ctest --test-dir build --output-on-failure --output-junit junit.xml  # writes build/junit.xml
  artifacts:
    when: always
    reports:
      junit: build/junit.xml
```

- Conditions with `rules:` (not `only`/`except`). Order jobs with `needs:`.
- Keyword reference: `/docs/gitlab-ci/yaml/_index.md`.

## GitHub Actions

```yaml
name: CI
on: [push, pull_request]
permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v7
      - run: sudo apt-get update && sudo apt-get install -y ninja-build
      - run: cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
      - run: cmake --build build
      - run: ctest --test-dir build --output-on-failure
```

- Several compilers or versions: `strategy: matrix: compiler: [gcc, clang]`.
- Syntax reference: `/docs/github-actions/reference/workflows-and-actions/workflow-syntax.md`.
