#!/usr/bin/env bash
1password --lock
${HOME}/bin/sp pause

unset __NV_PRIME_RENDER_OFFLOAD # Workaround for hyprlock
hyprlock
