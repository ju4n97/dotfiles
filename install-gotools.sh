#!/usr/bin/env bash

GOBIN=$(go env GOBIN)
export GOBIN
mkdir -p "$GOBIN"

echo "Installing Go tools..."

TOOLS=(
    "golang.org/x/tools/gopls"
    "github.com/cweill/gotests/gotests"
    "github.com/fatih/gomodifytags"
    "github.com/josharian/impl"
    "github.com/haya14busa/goplay/cmd/goplay"
    "github.com/go-delve/delve/cmd/dlv"
    "github.com/golangci/golangci-lint/cmd/golangci-lint"
    "github.com/go-task/task/v3/cmd/task"
)

for tool in "${TOOLS[@]}"; do
    binary_name=$(basename "$tool")
    echo "Installing $binary_name..."
    go install "$tool@latest" &
done

wait

echo "Go tools installation complete."
