all: build

setup:
	cp ../.env  ./
	forge install

clean:
	forge clean
	rm ./coverage/ -rfv
	rm ./crytic-export/ -rfv

build:
	forge build