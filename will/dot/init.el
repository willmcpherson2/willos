;;; -*- lexical-binding: t -*-

;; straight

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; emacs

(use-package emacs
  :custom
  (ring-bell-function 'ignore)
  (enable-recursive-minibuffers t)
  (initial-major-mode 'text-mode)
  (initial-scratch-message "")
  (indent-tabs-mode nil)
  (tab-width 2)
  :config
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (menu-bar-mode -1)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-14"))
  (set-fringe-mode 4)
  (column-number-mode 1)
  (fset 'yes-or-no-p 'y-or-n-p))

;; load first

(use-package no-littering
  :demand t
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  :config
  (no-littering-theme-backups))

;; ui

(use-package modus-themes)

(use-package mood-line
  :config
  (mood-line-mode))

(use-package auto-dark
  :custom
  (auto-dark-dark-theme 'modus-vivendi)
  (auto-dark-light-theme 'modus-operandi)
  :config
  (auto-dark-mode t))

;; misc

(use-package warnings
  :custom
  (warning-minimum-level :error))

(use-package autorevert
  :custom
  (global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode 1))

(defun make-transient-project (dir)
  (cons 'transient (expand-file-name dir)))

(use-package project
  :custom
  (project-switch-commands 'project-dired)
  :config
  (setq project-find-functions '(project-try-vc make-transient-project)))

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
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package cape)

(use-package magit)

(use-package git-gutter
  :custom
  (git-gutter:modified-sign " ")
  (git-gutter:added-sign " ")
  (git-gutter:deleted-sign " ")
  :config
  (global-git-gutter-mode +1))

(use-package coterm
  :config
  (coterm-mode))

;; languages

(use-package eldoc
  :custom
  (eldoc-echo-area-prefer-doc-buffer t))

(use-package flymake
  :custom
  (flymake-fringe-indicator-position nil)
  :hook
  (prog-mode . flymake-mode))

(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package copilot
  :straight
  (copilot :host github
           :repo "zerolfx/copilot.el"
           :files ("dist" "*.el")))

(use-package org
  :custom
  (org-latex-compiler "lualatex")
  (org-preview-latex-default-process 'dvisvgm)
  :hook
  (org-mode . org-indent-mode))

(use-package markdown-mode)

(use-package js
  :custom
  (js-indent-level 2))

(use-package css-mode
  :custom
  (css-indent-offset 2))

(use-package nix-mode)

(use-package haskell-mode
  :custom
  (haskell-hoogle-command "hoogle -l"))

(use-package cider)

(use-package scala-mode
  :interpreter
  ("scala" . scala-mode))

(use-package jinja2-mode)

(use-package proof-general)

;; evil

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

(use-package evil-org
  :hook
  (org-mode . evil-org-mode))

;; leader key

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
   "s" 'project-shell
   "r" 'cape-history
   "n" 'evil-ex-nohighlight

   "<return>" 'copilot-accept-completion
   "cs" 'eglot
   "cg" 'copilot-mode
   "ca" 'eglot-code-actions
   "cr" 'eglot-rename
   "cf" 'eglot-format
   "cd" 'flymake-show-buffer-diagnostics))
