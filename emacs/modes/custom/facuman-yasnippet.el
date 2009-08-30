;; ------------------------------------------------------------- [ yasnippet ]
(add-to-list 'load-path "~/environment/emacs/modes/yasnippet")

(require 'yasnippet)

;Don't map TAB to yasnippet
;In fact, set it to something we'll never use because
;we'll only ever trigger it indirectly.
;;(setq yas/trigger-key (kbd "C-c <kp-multiply>"))

(yas/initialize)
;;(set-face-background  'yas/field-highlight-face "Grey10")
;;(set-face-background  'yas/mirror-highlight-face "Grey10")
(yas/load-directory "~/environment/emacs/modes/yasnippet/snippets")
