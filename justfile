# List available recipes
default:
    @just --list

# Bump version and package the chart
# Usage: just release [patch|minor|major|<version>]
release part="patch": (bump part) package

# Internal: Bump the version in Chart.yaml using awk (portable)
[private]
bump part:
    @echo "Updating version..."
    @awk -v part="{{part}}" ' \
        /^version:/ { \
            if (part == "major" || part == "minor" || part == "patch") { \
                gsub(/"/, "", $2); \
                split($2, v, "."); \
                if (part == "major") { v[1]++; v[2]=0; v[3]=0 } \
                else if (part == "minor") { v[2]++; v[3]=0 } \
                else { v[3]++ } \
                printf "version: %d.%d.%d\n", v[1], v[2], v[3]; \
            } else { \
                printf "version: %s\n", part; \
            } \
            next \
        } \
        { print } \
    ' charts/memory-oom/Chart.yaml > charts/memory-oom/Chart.yaml.tmp && mv charts/memory-oom/Chart.yaml.tmp charts/memory-oom/Chart.yaml
    @grep "^version:" charts/memory-oom/Chart.yaml

# Internal: Package the chart and update index
[private]
package:
    helm package charts/memory-oom -d docs
    helm repo index docs
    @echo "Chart packaged and index updated in docs/"
