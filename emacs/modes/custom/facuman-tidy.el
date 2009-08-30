;; ---------------------------------------------------- [ Tidy startup ]
(defun my-tidy-startup ()
  "Tidy temp."
  '(tidy-temp-directory "~/.tidy/temp"))

(add-hook 'tidy-mode-hook 'my-tidy-startup)
