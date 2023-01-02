(doom! :completion
       company
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       (emoji +unicode +github)
       hl-todo
       modeline
       ophints
       (popup +defaults)
       unicode
       vc-gutter
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       fold
       multiple-cursors
       snippets
       format

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       syntax
       (spell +aspell +everywhere)

       :tools
       eval
       lookup
       lsp
       magit

       :lang
       emacs-lisp
       (haskell +lsp)
       (json +lsp)
       (javascript +lsp)
       (markdown +grip)
       nix
       org
       (rust +lsp)
       (sh +lsp)
       web
       (yaml +lsp)

       :app
       everywhere

       :config
       (default +bindings +smartparens))
