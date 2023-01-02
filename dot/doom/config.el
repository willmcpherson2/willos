(let ((font "JetBrainsMono Nerd Font 16"))
  (setq doom-font font
        doom-variable-pitch-font font
        doom-serif-font font
        doom-unicode-font font
        doom-big-font font))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(use-package! auto-dark
  :init
  (require 'dbus)
  (setq auto-dark-dark-theme 'doom-one)
  (setq auto-dark-light-theme 'doom-one-light)
  (auto-dark-mode t))
