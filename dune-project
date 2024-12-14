(lang dune 3.15)

(name ccl)

(generate_opam_files true)

(source
 (github chshersh/ccl))

(authors "Dmitrii Kovanikov")
(maintainers "Dmitrii Kovanikov")

(license MIT)

(documentation https://github.com/chshersh/ccl)

(package
 (name ccl)
 (synopsis "Categorical Configuration Language")
 (description "A minimalistic yet powerful configuration languaged based on category theory principles")
 (depends
   ocaml
   dune
   angstrom
   (alcotest
     (and
      :with-test
      (>= 1.3.0)))
   (qcheck
     (and
      :with-test
      (>= 0.21)))
   (qcheck-alcotest :with-test)
 )
 (tags
  (config language parser)))
