# Secret Contracts Starter Pack

This is a template to build secret contracts in Rust to run in
[Secret Network](https://github.com/enigmampc/SecretNetwork).
To understand the framework better, please read the overview in the
[cosmwasm repo](https://github.com/CosmWasm/cosmwasm/blob/master/README.md),
and dig into the [cosmwasm docs](https://www.cosmwasm.com).
This assumes you understand the theory and just want to get coding.

## Creating a new repo from template

Assuming you have a recent version of rust and cargo installed (via [rustup](https://rustup.rs/)),
then the following should get you a new repo to start a contract:

First, install
[cargo-generate](https://github.com/ashleygwilliams/cargo-generate).
Unless you did that before, run this line now:

```sh
cargo install cargo-generate --features vendored-openssl
```

Now, use it to create your new contract.
Go to the folder in which you want to place it and run:

```sh
cargo generate --git https://github.com/enigmampc/secret-template.git --name YOUR_NAME_HERE
```

You will now have a new folder called `YOUR_NAME_HERE` (I hope you changed that to something else)
containing a simple working contract and build system that you can customize.

## Create a Repo

After generating, you have a initialized local git repo, but no commits, and no remote.
Go to a server (eg. github) and create a new upstream repo (called `YOUR-GIT-URL` below).
Then run the following:

```sh
# this is needed to create a valid Cargo.lock file (see below)
cargo check
git checkout -b master # in case you generate from non-master
git add .
git commit -m 'Initial Commit'
git remote add origin YOUR-GIT-URL
git push -u origin master
```

## Using your project

Once you have your custom repo, you should check out [Developing](./Developing.md) to explain
more on how to run tests and develop code. Or go through the
[online tutorial](https://www.cosmwasm.com/docs/getting-started/intro) to get a better feel
of how to develop.

[Publishing](./Publishing.md) contains useful information on how to publish your contract
to the world, once you are ready to deploy it on a running blockchain. And
[Importing](./Importing.md) contains information about pulling in other contracts or crates
that have been published.

You can also find lots of useful recipes in the `Makefile` which you can use
if you have `make` installed (very recommended. at least check them out).

Please replace this README file with information about your specific project. You can keep
the `Developing.md` and `Publishing.md` files as useful referenced, but please set some
proper description in the README.

### Setup Test Development - Local Secret Network Node

The developer blockchain is configured to run inside a docker container. Install Docker for your environment (Mac, Windows, Linux).  Open a terminal window and change to your project directory. Then start SecretNetwork, labelled secretdev from here on:

`docker run -it --rm -p 26657:26657 -p 26656:26656 -p 1337:1337 --name secretdev enigmampc/secret-network-sw-dev`

### Compile

`cargo wasm`

### Optimized and Store

Before storing the smart contract on the Secret Network, it must first be optimized.  Basically compressed

`docker run --rm -v "$(pwd)":/contract --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry enigmampc/secret-contract-optimizer`

### First lets start it up again, this time mounting our project's code inside the container.

`docker run -it --rm -p 26657:26657 -p 26656:26656 -p 1337:1337 -v $(pwd):/root/code --name secretdev enigmampc/secret-network-sw-dev`

At this point you're running a local SecretNetwork full-node. Let's connect to the container so we can view and manage the secret keys:

Upload optimized contract.wasm.gz

`docker exec -it secretdev /bin/bash`
`cd code`
`secretcli tx compute store contract.wasm.gz --from a --gas 1000000 -y --keyring-backend test`

Query Smart Contract on Network

`secretcli query compute list-code
[
  {
    "id": 1,
    "creator": "secret1zy80x04d4jh4nvcqmamgjqe7whus5tcw406sna",
    "data_hash": "D98F0CA3E8568B6B59772257E07CAC2ED31DD89466BFFAA35B09564B39484D92",
    "source": "",
    "builder": ""
  }
]`

Create instance of uploaded contract from secretcli console

`INIT='{"count": 100000000}'`
`CODE_ID=1`
`secretcli tx compute instantiate $CODE_ID "$INIT" --from a --label "secret loan" -y --keyring-backend test`

The above should output the JSON result, look for the contract address 

To get deployed contract address in order to interact with it
`secretcli q tx [hash]`

Deploy to the Holodeck Testnet.  Holodeck is the official Secret Network testnet. To deploy your contract to the testnet follow these steps:

1. Install and configure the Secret Network Light Client
2. Get some SCRT from the faucet
3. Store the Secret Contract on Holodeck
4. Instantiate your Secret Contract

To get list of prebuilt wallets and keys

`secretcli keys list --keyring-backend test`

`CONTRACT=secret18vd8fpwxzck93qlwghaj6arh4p7c5n8978vsyg`
`secretcli query compute query $CONTRACT '{"get_count": {}}'`
`secretcli tx compute execute $CONTRACT '{"increment":{}}' --from a` where "--from a" is the address.  Can provide an actual address
