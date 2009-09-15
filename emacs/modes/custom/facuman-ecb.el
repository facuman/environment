;; ------------------------------------------------------ [ ecb ]
(add-to-list 'load-path "~/environment/emacs/modes/ecb")
(add-to-list 'load-path "~/environment/emacs/modes/cedet/eieio")
(add-to-list 'load-path "~/environment/emacs/modes/cedet/semantic")
(add-to-list 'load-path "~/environment/emacs/modes/cedet/speedbar")

(require 'ecb)

;; Deactivate tip of the day
(setq ecb-tip-of-the-day nil)


;; Open files with a mouse click
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))

;; (ecb-activate)

;; Activate Semantic
(setq semantic-load-turn-everything-on t)
(require 'semantic-load)


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
