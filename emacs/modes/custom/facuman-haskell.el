;; ---------------------------------------------------- [ Haskell startup ]
;; Haskell mode settings

(defun my-haskell-startup ()
  "Haskell standard startup configuration"

  ;; "To show pretty symbols on the file. I'm not using it too much because of the color theme"
  (setq haskell-font-lock-symbols 'unicode)

  ;; "Change ghci path if needed"
  ;;    (setq haskell-program-name "/some/where/ghci")

  (turn-on-haskell-doc-mode)
  (turn-on-haskell-indent))

(add-hook 'haskell-mode-hook 'my-haskell-startup)
