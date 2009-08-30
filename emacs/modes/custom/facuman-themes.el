;; ------------------------------------------------------------- [ themes ]
(add-to-list 'load-path "~/environment/emacs/themes/")
(require 'color-theme)
(color-theme-initialize)
(require 'zenburn)
(zenburn)
(setq default-major-mode 'zenburn) ;; autoload zenburn
