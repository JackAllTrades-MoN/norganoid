(lang dune 3.7)

(name organoids)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Jack Alltrades")

(maintainers "Jack Alltrades")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (allow_empty)
 (name organoids)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
