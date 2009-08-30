;; ------------------------------------------------ [ Emacs Lisp Startup ]
(defun my-elisp-startup ()
  (interactive)
  (start-programing-mode)

  ;; Byte compile this file as soon as its saved.
  (setq byte-compile-warnings nil)
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
        '(lambda () (byte-compile-file buffer-file-name))
        nil t)

  ;; When editing elisp code, we want hippie expand to reference emacs
  ;; lisp symbols. (Note: We are shifting this onto the front of the
  ;; list, so put this so -partially is called first)
  (make-local-variable 'hippie-expand-try-functions-list)
  (add-to-list 'hippie-expand-try-functions-list
               'try-complete-lisp-symbol)
  (add-to-list 'hippie-expand-try-functions-list
               'try-complete-lisp-symbol-partially)
  ;; Define lisp key macros
  (local-set-key "\C-css" 'insert-elisp-seperator-line)
  (local-set-key "\C-csh" 'insert-elisp-section-header)
  (local-set-key "\C-csb" 'insert-elisp-big-header))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-startup)
