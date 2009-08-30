;; ------------------------------------------------------ [ eshell ]
;; eshell C-a to jump to command start only:
(defun eshell-maybe-bol ()
  "C-a goes to the beginning of command, not beginning of line."
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
      (beginning-of-line))))

(defun my-eshell-startup ()
  (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)

  ;; eshell to launch certain apps in ansi-term:
  (require 'em-term)
  (add-to-list 'eshell-visual-commands "vim")

  ;; eshell completion to behave like bash:
  (setq eshell-cmpl-cycle-completions nil))

(add-hook 'eshell-mode-hook 'my-eshell-startup)
