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
	solc-select install 0.8.19
	solc-select use 0.8.19
	echidna-test  ./src/echidna/EchidnaFuzz.sol  \
			--contract EchidnaFuzz  \
			--corpus-dir ./coverage \
			--config ./echidna.yaml \
			--test-mode assertion

build:
	forge build