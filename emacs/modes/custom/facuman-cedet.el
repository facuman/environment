;; ------------------------------------------------------------- [ cedet ]
(add-to-list 'load-path "~/environment/emacs/modes/cedet/common")

;; require the main cedet mode
(require 'cedet)

(require 'ede)
(setq global-ede-mode t)

(require 'semantic-ia)

;;make all the 'semantic.cache' files go somewhere sane
(setq semanticdb-default-save-directory "~/.emacs.d/semantic.cache/")
