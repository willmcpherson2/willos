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
(column-number-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq
 ring-bell-function 'ignore
 warning-minimum-level :error
 enable-recursive-minibuffers t
 eldoc-echo-area-prefer-doc-buffer t
 project-switch-commands '((consult-project-buffer "buffer" "b")
			   (project-find-file "file" "f")
			   (project-shell "shell" "s")))

(add-hook 'emacs-lisp-mode-hook 'flymake-mode)
(add-hook 'eglot-managed-mode-hook
	  (lambda ()
	    (setq eldoc-documentation-functions
		  (cons #'flymake-eldoc-function
			(remove #'flymake-eldoc-function eldoc-documentation-functions)))
	    (setq eldoc-documentation-strategy #'eldoc-documentation-compose)))
(add-hook 'prog-mode-hook
	  (lambda ()
	    (setq display-line-numbers 'relative)))

(setq use-package-always-ensure t)

(use-package no-littering
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

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

(use-package which-key
  :config
  (which-key-mode))

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package vertico
  :config
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (completion-in-region-function 'consult-completion-in-region))

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

(use-package magit)

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-dired-mode)
  (diff-hl-flydiff-mode))

(use-package vterm)

(use-package markdown-mode)

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
  :config
  (evil-collection-init))

(use-package evil-mc
  :config
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
  "p" 'project-switch-project

  "cs" 'eglot
  "ca" 'eglot-code-actions
  "cr" 'eglot-rename
  "cf" 'eglot-format
  "cd" 'flymake-show-buffer-diagnostics)
