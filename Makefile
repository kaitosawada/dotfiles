SOPS_AGE_KEY_FILE := $(HOME)/.config/sops/age/keys.txt
FLAKE_TARGET := $(addprefix .#,$(shell whoami)-$(shell uname -m | sed 's/arm64/aarch64/')-$(shell uname | tr '[:upper:]' '[:lower:]'))

export SOPS_AGE_KEY_FILE
export NIXPKGS_ALLOW_UNFREE = 1

.PHONY: switch build fmt update check sops-edit

switch:
	home-manager switch --flake "$(FLAKE_TARGET)" --impure
	exec $$SHELL -l

build:
	home-manager build --flake "$(FLAKE_TARGET)" --no-out-link

fmt:
	nixfmt $$(find . -name '*.nix')

update:
	nix flake update

check:
	./check.sh

edit-secrets:
	nix-shell -p sops --run "sops secrets/home.yaml"
