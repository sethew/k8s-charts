# Development Workflow

## Setting up pre-commit hooks

If you want to automatically generate `README.md` files with a pre-commit hook, make sure you
[install the pre-commit binary](https://pre-commit.com/#install), and add a [.pre-commit-config.yaml file](./.pre-commit-config.yaml)
to your project. Then run:

```bash
pre-commit install
pre-commit install-hooks
```

Future changes to your chart's `requirements.yaml`, `values.yaml`, `Chart.yaml`, or `README.md.gotmpl` files will cause an update to documentation when you commit.

There are several variants of `pre-commit` hooks to choose from depending on your use case.

#### `helm-docs`  Uses `helm-docs` binary located in your `PATH`

```yaml
---
repos:
  - repo: https://github.com/norwoodj/helm-docs
    rev:  ""
    hooks:
      - id: helm-docs
        args:
          # Make the tool search for charts only under the `charts` directory
          - --chart-search-root=charts

```


#### `helm-docs-built` Uses `helm-docs` built from code in git

```yaml
---
repos:
  - repo: https://github.com/norwoodj/helm-docs
    rev:  ""
    hooks:
      - id: helm-docs-built
        args:
          # Make the tool search for charts only under the `charts` directory
          - --chart-search-root=charts

```


#### `helm-docs-container` Uses the container image of `helm-docs:latest`

```yaml
---
repos:
  - repo: https://github.com/norwoodj/helm-docs
    rev:  ""
    hooks:
      - id: helm-docs-container
        args:
          # Make the tool search for charts only under the `charts` directory
          - --chart-search-root=charts

```

#### To pin the `helm-docs` container to a specific tag, follow the example below:


```yaml
---
repos:
  - repo: https://github.com/norwoodj/helm-docs
    rev:  ""
    hooks:
      - id: helm-docs-container
        entry: jnorwood/helm-docs:x.y.z
        args:
          # Make the tool search for charts only under the `charts` directory
          - --chart-search-root=charts

```
