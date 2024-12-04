(lang dune 3.15)

(name ccl)

(generate_opam_files true)

(source
 (github chshersh/ccl))

(authors "Dmitrii Kovanikov")
(maintainers "Dmitrii Kovanikov")

(license MIT)

(documentation https://github.com/chshersh/ccl)

(using menhir 3.0)

(package
 (name ccl)
 (synopsis "Categorical Configuration Language")
 (description "A minimalistic yet powerful configuration languaged based on category theory principles")
 (depends ocaml dune menhir)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
