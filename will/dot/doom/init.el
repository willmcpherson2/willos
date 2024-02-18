;;; -*- lexical-binding: t; -*-

(doom! :completion
       company
       (vertico +icons)

       :ui
       doom
       indent-guides
       modeline
       ophints
       vc-gutter

       :editor
       (evil +everywhere)
       snippets

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       (undo +tree)
       vc

       :term
       shell
       vterm

       :checkers
       syntax
       (spell +hunspell)
       grammar

       :tools
       direnv
       (docker +lsp)
       (eval +overlay)
       lookup
       lsp
       magit
       pdf
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (cc +lsp)
       (clojure +lsp)
       data
       emacs-lisp
       (haskell +lsp)
       (json +lsp)
       (javascript +lsp)
       (markdown +grip)
       nix
       (org +pandoc)
       (ruby +lsp +rails)
       (rust +lsp)
       (sh +lsp)
       web
       (yaml +lsp)

       :config
       (default +bindings))
