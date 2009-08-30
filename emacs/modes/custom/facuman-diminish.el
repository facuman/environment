;; ---------------------------------------------------------- [ diminish ]
;; Makes minor mode names in the modeline shorter.
(require 'diminish)

;;(eval-after-load "filladapt"
;;  '(diminish 'filladapt-mode "Fill"))
(eval-after-load "abbrev"
  '(diminish 'abbrev-mode "Abv"))
(eval-after-load "doxymacs"
  '(diminish 'doxymacs-mode "dox"))
