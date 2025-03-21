#!/usr/bin/env bash

sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old
sudo nix-collect-garbage --delete-old
