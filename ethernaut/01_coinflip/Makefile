all: build

setup:
	npm install

clean:
	rm ./build/ -rfv
	rm ./node_modules/ -rfv
	rm ./coverage/ -rfv
	rm ./crytic-export/ -rfv

echidna:
	echidna-test  ./contracts/echidna/EchidnaCoinFlip.sol  \
			--contract EchidnaCoinFlip  \
			--corpus-dir ./coverage \
			--test-mode assertion

slither:
	slither ./contracts/CoinFlip.sol  \
	     	--truffle-ignore-compile  \
			--exclude-optimization

build:
	truffle compile