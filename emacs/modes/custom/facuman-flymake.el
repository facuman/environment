;; ---------------------------------------------------------- [ flymake ]
;; When turning on flyspell-mode, automatically check the entire buffer.
;; Why this isn't the default baffles me.
(defadvice flyspell-mode (after advice-flyspell-check-buffer-on-start activate)
  (flyspell-buffer))

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
       (local-file (file-relative-name
                    temp-file
                    (file-name-directory buffer-file-name))))
       (list "~/environment/emacs/modes/epylint.py" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
           '("\\.py\\'" flymake-pylint-init)))
