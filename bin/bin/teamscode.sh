#!/usr/bin/env bash

pushd ~/mitt/teamscode
nix-shell --run "python main.py"
popd
