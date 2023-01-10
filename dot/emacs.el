;; TODO
;; fix window placement and temporary buffer stuff
;; too many buffers on startup
;; projects
;; company not showing icons
;; add company backends
;; evil mode feels anti-emacs -- try god mode, meow, etc.
;; editing & pasting in any input (command input)
;; copying any text
;; eventually start mapping keys
;; need good shell/term solution (i want shell to be text buffer)
;; treesitter, lsp, language modes (flycheck?)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 4)
(pixel-scroll-precision-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 160)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t
      display-line-numbers-type 'relative
      ring-bell-function 'ignore
      warning-minimum-level :error
      enable-recursive-minibuffers t)

(setq use-package-always-ensure t)

(use-package no-littering
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package all-the-icons
  :if
  (display-graphic-p))

(use-package all-the-icons-completion
  :after
  (marginalia all-the-icons)
  :hook
  (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(use-package auto-dark
  :custom
  (auto-dark-dark-theme 'doom-one)
  (auto-dark-light-theme 'doom-one-light)
  :init
  (require 'dbus)
  (auto-dark-mode t))

(use-package which-key
  :init
  (which-key-mode))

(use-package undo-tree
  :init
  (global-undo-tree-mode))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :custom
  (evil-want-C-u-scroll t)  
  :config
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1))

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (completion-in-region-function 'consult-completion-in-region))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark
  :custom
  embark-prompter 'embark-completing-read-prompter)

(use-package consult)

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package company
  :custom
  (company-selection-wrap-around t)
  :config
  (global-company-mode t))

(use-package magit)

(use-package diff-hl
  :init
  (global-diff-hl-mode))
