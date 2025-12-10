# AI Innovation Days - Memory OOM Chart

This repository hosts a Helm chart for testing Kubernetes OOM behavior.

## Repository Structure

- `charts/memory-oom`: Source code for the Helm chart.
- `docs/`: Packaged Helm chart and `index.yaml` for GitHub Pages hosting.

## Hosting on GitHub Pages

To host this chart:

1. Commit and push the `docs/` directory to GitHub.
2. Go to your repository **Settings** > **Pages**.
3. Under **Build and deployment**, select **Source** as `Deploy from a branch`.
4. Select your branch (e.g., `main`) and folder `/docs`.
5. Click **Save**.

Your chart repository URL will be: `https://<your-username>.github.io/<repo-name>/`

## Usage

Once hosted, you can add the repository and install the chart:

```bash
helm repo add oom-test https://<your-username>.github.io/<repo-name>/
helm repo update
helm install my-oom-test oom-test/memory-oom
```

## Development

To update the chart:

1. Modify files in `charts/memory-oom`.
2. Bump the version in `charts/memory-oom/Chart.yaml`.
3. Run the package command:

    ```bash
    helm package charts/memory-oom -d docs
    helm repo index docs
    ```

4. Commit and push the changes.
