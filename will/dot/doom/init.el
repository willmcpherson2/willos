;;; -*- lexical-binding: t; -*-

(doom! :completion
       (vertico +icons)
       (company +childframe)

       :ui
       doom
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
       (syntax +childframe)
       (spell +aspell +flyspell)
       grammar

       :tools
       direnv
       (docker +lsp)
       (eval +overlay)
       lookup
       lsp
       magit
       pdf
       (terraform +lsp)
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (agda +local)
       (cc +lsp)
       (clojure +lsp)
       data
       emacs-lisp
       (gdscript +lsp)
       (go +lsp)
       (haskell +lsp)
       (json +lsp)
       (javascript +lsp)
       (markdown +grip)
       (nix +lsp)
       (org +pandoc)
       (ruby +lsp +rails)
       (rust +lsp)
       scala
       (sh +lsp)
       web
       (yaml +lsp)

       :config
       (default +bindings))
