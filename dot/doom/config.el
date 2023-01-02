(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16.0))
(setq emojify-display-style 'unicode)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(use-package! auto-dark
  :init
  (require 'dbus)
  (setq auto-dark-dark-theme 'doom-one)
  (setq auto-dark-light-theme 'doom-one-light)
  (auto-dark-mode t))
