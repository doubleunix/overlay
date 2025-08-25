# overlay

build: clean
	nix build --print-build-logs

check:
	nix flake check --print-build-logs

clean:
	@rm -f result
