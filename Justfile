############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy:
	nixos-rebuild switch --flake . --use-remote-sudo

zeldab:
  nix build .#nixosConfigurations.zelda.config.system.build.toplevel
  attic push system result
  unlink result

debug:
	nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	# remove all generations older than 7 days
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	# garbage collect all unused nix store entries
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old
