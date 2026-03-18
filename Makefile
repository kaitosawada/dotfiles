SOPS_AGE_KEY_FILE := $(HOME)/.config/sops/age/keys.txt
FLAKE_TARGET := .#$(shell whoami)-$(shell uname -m)-$(shell uname | tr '[:upper:]' '[:lower:]')

export SOPS_AGE_KEY_FILE
export NIXPKGS_ALLOW_UNFREE = 1

.PHONY: switch build fmt update check sops-edit

switch:
	home-manager switch --flake "$(FLAKE_TARGET)" --impure
	exec $$SHELL -l

build:
	home-manager build --flake "$(FLAKE_TARGET)"

fmt:
	nixfmt $$(find . -name '*.nix')

update:
	nix flake update

check:
	./check.sh

edit-secrets:
	nix-shell -p sops --run "sops secrets/home.yaml"
