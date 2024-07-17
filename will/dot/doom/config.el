;;; -*- lexical-binding: t; -*-

(if (featurep :system 'macos)
    (setq mac-command-modifier 'control
          mac-control-modifier 'meta
          auto-dark-allow-osascript t))

(setq auto-dark-dark-theme 'doom-one
      auto-dark-light-theme 'doom-one-light)
(auto-dark-mode 1)

(setq-default tab-width 2)

(setq display-line-numbers-type 'relative
      doom-font (font-spec :family "JetBrains Mono" :size 22)
      evil-want-minibuffer t
      evil-goggles-duration 0.5
      js-indent-level 2
      lsp-restart 'ignore
      projectile-switch-project-action #'projectile-dired
      markdown-gfm-use-electric-backquote nil
      initial-scratch-message nil
      initial-major-mode #'text-mode)

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(setq doom-leader-alt-key "C-SPC")
(map! :leader
      "x" #'scratch-buffer
      "v" #'+vterm/here
      "p v" #'projectile-run-vterm
      "c d" #'consult-lsp-diagnostics
      "c c" #'copilot-mode
      "TAB" #'completion-at-point
      "RET" #'copilot-accept-completion)
