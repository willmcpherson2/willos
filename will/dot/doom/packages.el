;; -*- no-byte-compile: t; -*-

(package! auto-dark)

(package! copilot
  :pin "fd4d7e8c1e95aa9d3967b19905c9b8c3e03f6a5c"
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el" "dist")))

(package! async-await)
(package! websocket)
(package! aichat
  :pin "1b3270c96080a67389f6089d489e883c8367e6f8"
  :recipe (:host github :repo "xhcoding/emacs-aichat" :files ("*")))
