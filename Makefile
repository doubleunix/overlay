# overlay

build:
	nix build

check:
	nix flake check --print-build-logs

clean:
	rm -f result
