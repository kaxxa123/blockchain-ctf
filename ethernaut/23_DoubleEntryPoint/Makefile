all: build

setup:
	cp ../.env  ./
	forge install

clean:
	forge clean
	rm ./coverage/ -rfv
	rm ./crytic-export/ -rfv

echidna:
	rm ./coverage/ -rfv
	rm ./crytic-export/ -rfv
	solc-select install 0.6.12
	solc-select use 0.6.12
	echidna-test  ./src/echidna/EchidnaFuzz.sol  \
			--contract EchidnaFuzz  \
			--corpus-dir ./coverage \
			--config ./echidna.yaml \
			--test-mode assertion

build:
	forge build