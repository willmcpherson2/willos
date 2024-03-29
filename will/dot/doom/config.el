;;; -*- lexical-binding: t; -*-

(if (featurep :system 'macos)
    (setq mac-command-modifier 'control
          mac-control-modifier 'meta
          auto-dark-allow-osascript t))

(setq-default tab-width 2)
(setq display-line-numbers-type 'relative
      doom-font (font-spec :family "JetBrains Mono" :size 22))

(setq aichat-bingai-cookies-file "~/.bingai-cookie.json"
      aichat-bingai-conversation-style 'precise)

(setq auto-dark-dark-theme 'doom-one
      auto-dark-light-theme 'doom-one-light)
(auto-dark-mode 1)

(setq evil-want-minibuffer t
      evil-goggles-duration 0.5)

(setq js-indent-level 2)

(setq projectile-switch-project-action #'projectile-dired)

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(setq doom-leader-alt-key "C-SPC")
(map! :leader
      "p s" #'project-shell
      "p v" #'projectile-run-vterm
      "r" #'consult-history
      "c d" #'consult-lsp-diagnostics
      "c c" #'copilot-mode
      "TAB" #'completion-at-point
      "RET" #'copilot-accept-completion)
