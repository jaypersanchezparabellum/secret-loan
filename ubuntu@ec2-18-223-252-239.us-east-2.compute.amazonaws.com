# Overview

Notes on dev environment setup.  

## Steps

Create new Rust project: `cargo new appName` where 'appName' is the name of the app
 Build Cargo project: `cargo build` equivalent to `nmp install` or `npm start`
 