;;; -*- lexical-binding: t -*-

;; builtin settings

(setq inhibit-x-resources t
      ring-bell-function 'ignore
      warning-minimum-level :error
      enable-recursive-minibuffers t
      eldoc-echo-area-prefer-doc-buffer t
      dired-listing-switches "-DAhl"
      project-switch-commands '((consult-project-buffer "buffer" "b")
                                (project-find-file "file" "f")
                                (project-eshell "shell" "s")))

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

;; eshell

(defalias 'eshell/h 'consult-history)

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

(use-package company
  :custom
  (company-selection-wrap-around t)
  :config
  (global-company-mode t))

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

;; editing

(use-package evil
  :custom
  (evil-want-keybinding nil)
  (evil-want-minibuffer t)
  (evil-want-C-u-scroll t)
  :config
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

;; keybindings

(use-package general)

(general-create-definer my-leader-def
  :prefix "SPC")

(defun insert-history ()
  (interactive)
  (evil-insert 0)
  (consult-history))

(my-leader-def 'normal 'override
  "a" 'embark-act
  "i" 'ibuffer
  "k" 'kill-this-buffer
  "q" 'evil-quit
  "w" 'save-buffer
  "b" 'consult-project-buffer
  "f" 'project-find-file
  "d" 'project-dired
  "/" 'consult-ripgrep
  "p" 'project-switch-project

  "ss" 'project-eshell
  "sh" 'insert-history

  "cs" 'eglot
  "ca" 'eglot-code-actions
  "cr" 'eglot-rename
  "cf" 'eglot-format
  "cd" 'flymake-show-buffer-diagnostics)
