;;; -*- lexical-binding: t; -*-

(if (featurep :system 'macos)
    (setq mac-command-modifier 'control
          mac-control-modifier 'meta
          auto-dark-allow-osascript t))

(after! doom-ui
  (setq! custom-safe-themes t
         auto-dark-themes '((doom-one) (doom-one-light)))
  (auto-dark-mode 1))

(setq-default tab-width 2)

(setq display-line-numbers-type 'relative
      doom-font (font-spec :family "JetBrains Mono" :size 22)
      evil-want-minibuffer t
      evil-goggles-duration 0.5
      lsp-restart 'ignore
      projectile-switch-project-action #'projectile-dired
      markdown-gfm-use-electric-backquote nil
      initial-scratch-message nil
      initial-major-mode #'text-mode
      vterm-buffer-name-string "*vterm %s*"
      warning-minimum-level :error)

(after! lsp-ui
  (setq! lsp-ui-doc-show-with-cursor t
         lsp-ui-doc-position 'top
         lsp-ui-doc-max-height 30
         lsp-ui-doc-delay 0.5
         lsp-ui-sideline-show-code-actions t
         lsp-ui-sideline-delay 0.5))

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)

(setq doom-leader-alt-key "C-SPC")
(map! :leader
      "x" #'scratch-buffer
      "v" #'+vterm/here
      "p v" #'projectile-run-vterm
      "c f" #'lsp-format-buffer
      "c d" #'consult-lsp-diagnostics
      "c c" #'copilot-mode
      "TAB" #'completion-at-point
      "RET" #'copilot-accept-completion)
