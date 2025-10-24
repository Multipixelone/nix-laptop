############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

deploy:
  nh os switch
  attic push system /run/current-system -j 2

minishb:
  nix build .#nixosConfigurations.minish.config.system.build.toplevel
  attic push system result -j 3
  nix build .#nixosConfigurations.marin.config.system.build.toplevel
  attic push system result -j 3
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
