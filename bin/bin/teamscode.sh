#!/usr/bin/env bash

pushd ~/mitt/teamscode
nix-shell --run "uv run python main.py"
popd
