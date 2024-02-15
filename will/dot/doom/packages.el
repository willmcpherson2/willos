;; -*- no-byte-compile: t; -*-

(package! auto-dark)

(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el")))

(package! async-await)
(package! websocket)
(package! aichat
  :recipe (:host github :repo "xhcoding/emacs-aichat" :files ("*")))
