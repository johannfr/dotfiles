#!/usr/bin/env bash

packagename="${1}"
sudo sed -i "/#jofinstall/a \ \ \ \ \ \ ${packagename}" /etc/nixos/jof-packages.nix
sudo nixos-rebuild switch
pushd /etc/nixos
git add jof-packages.nix
git commit -m "Added ${packagename}"
git push
popd
