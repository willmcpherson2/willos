(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(pixel-scroll-precision-mode 1)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 160)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq inhibit-startup-message t
      display-line-numbers-type 'relative
      ring-bell-function 'ignore
      warning-minimum-level :error)

(setq use-package-always-ensure t)

(use-package auto-dark
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
  :init
  (setq evil-want-C-u-scroll t)  
  :config
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1))

(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t)
  (setq completion-in-region-function 'consult-completion-in-region))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark)

(use-package consult)

(use-package embark-consult)

(use-package company
  :init
  (setq company-selection-wrap-around t)
  (global-company-mode))
