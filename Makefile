# overlay

build:
	nix build

check:
	nix flake check --print-build-logs --rebuild

clean:
	rm -f result
