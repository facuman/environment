;; ------------------------------------------------------ [ ecb ]
(add-to-list 'load-path "~/environment/emacs/modes/ecb")

(require 'ecb)

(defun my-ecb-startup ()
  "Ecb startup."
  (setq semantic-load-turn-useful-things-on t)
  (setq global-semantic-show-tag-boundaries-mode nil)
  (setq global-semantic-show-parser-state-mode nil)
  (setq semanticdb-default-save-directory "/tmp")
  (setq semanticdb-global-mode nil)
  (setq semanticdb-persistent-path (quote (never)))
  (semantic-load-enable-code-helpers)
  (global-semantic-auto-parse-mode -1)
  (global-semantic-show-unmatched-syntax-mode -1)
  (setq truncate-partial-width-windows nil))

(add-hook 'ecb-mode-hook 'my-ecb-startup)
