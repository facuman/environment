;; ---------------------------------------------------- [ dired startup ]
;; alias rn to be able to edit a dired buffer as a normal text buffer
(defalias 'rn 'wdired-change-to-wdired-mode)

(defun my-dired-startup ()
  ;; Enable the dired-find-alternate-file command
  (put 'dired-find-alternate-file 'disabled nil)

  ;; Allow 'Enter' and '^' to use the same buffer
  (define-key dired-mode-map (kbd "<return>")
    'dired-find-alternate-file) ; was dired-advertised-find-file
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file ".."))))
  ; was dired-up-directory

(add-hook 'dired-mode-hook 'my-dired-startup)
