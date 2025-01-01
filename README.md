# CCL: Categorical Configuration Language

Read the language description with key feature highlights in the following tutorial:

- [chshersh: The Most Elegant Configuration Language](https://chshersh.com/blog/2025-01-06-the-most-elegant-configuration-language.html)

<p align="center">
  <img alt="CCL Example" src="https://github.com/chshersh/chshersh.github.io/blob/develop/images/ccl/ccl.jpg?raw=true">
</p>

> [!IMPORTANT]
> `ccl` is developed and maintained in free time
> by volunteers. The development may continue for decades or may stop
> tomorrow. You can use
> [GitHub Sponsorship](https://github.com/sponsors/chshersh) to support
> the development of this project.

## Features

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
