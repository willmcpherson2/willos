;;; -*- lexical-binding: t; -*-

(setq-default tab-width 2)
(setq display-line-numbers-type 'relative
      doom-font (font-spec :family "JetBrainsMonoNL Nerd Font" :size 24))

(setq aichat-bingai-cookies-file "~/.bingai-cookie.json"
      aichat-bingai-conversation-style 'precise)

(setq auto-dark-dark-theme 'doom-one
      auto-dark-light-theme 'doom-one-light)
(auto-dark-mode 1)

(setq evil-want-minibuffer t)

(setq doom-leader-alt-key "C-SPC")
(map! :leader
      :desc "Open project shell"
      "p s" #'project-shell
      :desc "Open project vterm"
      "p v" #'projectile-run-vterm
      :desc "Search command history"
      "r" #'consult-history
      :desc "Toggle copilot mode"
      "c c" #'copilot-mode
      :desc "Accept copilot completion"
      "RET" #'copilot-accept-completion)
