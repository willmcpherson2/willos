;;; -*- lexical-binding: t -*-

;; builtin settings

(setq inhibit-x-resources t
      ring-bell-function 'ignore
      warning-minimum-level :error
      enable-recursive-minibuffers t
      eldoc-echo-area-prefer-doc-buffer t
      dired-listing-switches "-DAhl"
      global-auto-revert-non-file-buffers t
      flymake-fringe-indicator-position nil
      initial-scratch-message ""
      project-find-functions '(project-try-vc
                               (lambda (dir)
                                 (cons 'transient (expand-file-name dir))))
      project-switch-commands '((consult-project-buffer "buffer" "b")
                                (project-find-file "file" "f")
                                (project-eshell "shell" "s")
                                (project-dired "dired" "d")))

(setq-default indent-tabs-mode nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(pixel-scroll-precision-mode 1)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(set-fringe-mode 4)
(column-number-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode 1)

;; builtin hooks

(defun errors-then-docs ()
  (setq eldoc-documentation-functions
        (cons #'flymake-eldoc-function
              (remove #'flymake-eldoc-function eldoc-documentation-functions)))
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose))

(defun relative-line-numbers ()
  (setq display-line-numbers 'relative))

(add-hook 'prog-mode-hook 'flymake-mode)
(add-hook 'eldoc-mode-hook 'errors-then-docs)
(add-hook 'text-mode-hook 'relative-line-numbers)
(add-hook 'prog-mode-hook 'relative-line-numbers)
(add-hook 'org-mode-hook 'org-indent-mode)

;; eshell

(defalias 'eshell/v 'eshell-exec-visual)

(defun eshell/l (&rest args)
  (apply #'eshell/ls (cons "-Ahl" args)))

;; packages

(setq use-package-always-ensure t)

;; load first

(use-package no-littering
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; icons

(use-package all-the-icons)

(use-package all-the-icons-completion
  :after
  (marginalia all-the-icons)
  :hook
  (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :config
  (all-the-icons-completion-mode))

(use-package all-the-icons-ibuffer
  :hook
  (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

;; theme

(use-package doom-themes
  :config
  (doom-themes-org-config))

(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  :config
  (doom-modeline-mode 1))

(use-package auto-dark
  :custom
  (auto-dark-dark-theme 'doom-one)
  (auto-dark-light-theme 'doom-one-light)
  :config
  (auto-dark-mode t))

;; core

(use-package which-key
  :config
  (which-key-mode))

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package vertico
  :custom
  (vertico-cycle t)
  (completion-in-region-function 'consult-completion-in-region)
  :config
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode))

(use-package embark)

(use-package consult)

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect-first nil)
  (corfu-auto-delay 0)
  (corfu-popupinfo-delay t)
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package cape)

;; applications

(use-package magit)

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-dired-mode)
  (diff-hl-flydiff-mode))

(use-package vterm)

(use-package eshell-vterm
  :config
  (eshell-vterm-mode))

(use-package eshell-syntax-highlighting
  :config
  (eshell-syntax-highlighting-global-mode +1))

;; languages

(use-package markdown-mode)

(use-package nix-mode)

(use-package haskell-mode)

(use-package cider)

;; editing

(use-package evil
  :custom
  (evil-search-module 'evil-search)
  (evil-want-keybinding nil)
  (evil-want-minibuffer t)
  (evil-want-C-u-scroll t)
  (evil-want-Y-yank-to-eol t)
  :config
  (evil-select-search-module 'evil-search-module 'evil-search)
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1))

(use-package evil-collection
  :config
  (evil-collection-init))

(use-package evil-mc
  :config
  (global-evil-mc-mode 1))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :hook
  (org-mode . evil-org-mode))

;; keybindings

(use-package general
  :config
  (general-define-key
   :keymaps 'override
   :states '(normal visual insert)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   "a" 'embark-act
   "e" 'embark-export
   "i" 'ibuffer
   "k" 'kill-this-buffer
   "q" 'evil-quit
   "w" 'save-buffer
   "b" 'consult-project-buffer
   "f" 'project-find-file
   "d" 'project-dired
   "/" 'consult-ripgrep
   "p" 'project-switch-project
   "s" 'project-eshell
   "r" 'cape-history

   "cs" 'eglot
   "ca" 'eglot-code-actions
   "cr" 'eglot-rename
   "cf" 'eglot-format
   "cd" 'flymake-show-buffer-diagnostics))
