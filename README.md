# ccl

Categorical Configuration Language

## Development

Initialise the project when building for the first time:

```
opam switch create .
```

Build the project:

```
dune build
```

Run the project:

```
dune exec bin/main.exe -- owner/repo
```

Install dev dependencies:

```
opam install utop ocamlformat ocaml-lsp-server
```
