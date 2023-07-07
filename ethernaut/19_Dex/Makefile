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
	solc-select install 0.8.0
	solc-select use 0.8.0
	echidna-test  ./src/echidna/EchidnaDex.sol  \
			--contract EchidnaDex  \
			--corpus-dir ./coverage \
			--config ./echidna.yaml \
			--test-mode assertion

build:
	forge build