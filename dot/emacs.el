;;; -*- lexical-binding: t -*-

(setq inhibit-x-resources t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(pixel-scroll-precision-mode 1)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 140)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(set-fringe-mode 4)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq
 display-line-numbers-type 'relative
 ring-bell-function 'ignore
 warning-minimum-level :error
 enable-recursive-minibuffers t
 eldoc-echo-area-prefer-doc-buffer t)

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

(use-package all-the-icons-ibuffer
  :hook
  (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package doom-themes
  :config
  (doom-themes-org-config))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(use-package auto-dark
  :custom
  (auto-dark-dark-theme 'doom-one)
  (auto-dark-light-theme 'doom-one-light)
  :init
  (auto-dark-mode t))

(use-package which-key
  :init
  (which-key-mode))

(use-package undo-tree
  :init
  (global-undo-tree-mode))

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

(use-package magit)

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-dired-mode)
  (diff-hl-flydiff-mode))

(use-package vterm)

(use-package nix-mode)

(use-package haskell-mode)

(use-package evil
  :custom
  (evil-want-keybinding nil)
  (evil-want-minibuffer t)
  (evil-want-C-u-scroll t)
  :config
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1))

(use-package evil-collection
  :init
  (evil-collection-init))

(use-package evil-mc
  :init
  (global-evil-mc-mode 1))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package general)

(general-create-definer my-leader-def
  :prefix "SPC")

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
  "s" 'project-shell
  "p" 'project-switch-project)
