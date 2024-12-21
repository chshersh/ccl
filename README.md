# CCL: The most elegant configuration language

CCL stands for **Categorical Configuration Language**.

Example:

```
/= This is a CCL document
title = CCL Example

database =
  enabled = true
  ports =
    = 8000
    = 8001
    = 8002
  limits =
    cpu = 1500mi
    memory = 10Gb

user =
  guestId = 42

user =
  login = chshersh
  createdAt = 2024-12-31
```

CCL is just a key-value mapping. Yet, it's powerful enough to support:

1. Key-value mappings (obviously)
1. Lists
1. Strings
1. Dates
1. Algebraic Data Types
1. Comments
1. Sections
1. Nested records

## Development

Initialise the project when building for the first time:

```
opam switch create .
```

Build the project:

```
dune build
```

Install dev dependencies:

```
opam install utop ocamlformat ocaml-lsp-server
```
