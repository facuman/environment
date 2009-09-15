;; ------------------------------------------------------------- [ python ]
(defadvice py-execute-buffer (around python-keep-focus activate)
  "return focus to python code buffer"
  (save-excursion ad-do-it))

(require 'python)

;; Initialize Pymacs
(require 'pymacs)
(setenv "PYMACS_PYTHON" "~/environment/python/2.5/bin/python")

;; Initialize Rope
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(define-key ropemacs-local-keymap [(meta /)] 'dabbrev-expand)
(define-key ropemacs-local-keymap [(control /)] 'hippie-expand)
(define-key ropemacs-local-keymap [(control c) (control /)] 'rope-code-assist)

(provide 'python-programming)

;;(require 'pycomplete)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)


(defadvice py-execute-buffer (around python-keep-focus activate)
  "Thie advice to make focus python source code after execute command `py-execute-buffer'."
  (let ((remember-window (selected-window))
        (remember-point (point)))
    ad-do-it
    (select-window remember-window)
    (goto-char remember-point)))


(defun my-python-startup ()
  "Setup Python style."
  (interactive)
  (local-set-key '[f4] 'pdb)
  (setq tab-width 4)
  ;;(define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)
  (setq indent-tabs-mode nil)  ; Autoconvert tabs to spaces
  (setq python-indent 4)
  (setq python-continuation-offset 2)
  ;;(eldoc-mode 1)

  ;; remove trailing whitespace
  (setq show-trailing-whitespace t)

  ;; python mode combined with outline minor mode:
  (outline-minor-mode 1)
  (setq outline-regexp "def\\|class ")
  (setq coding-system-for-write 'utf-8)
  (local-set-key "\C-c\C-a" 'show-all)
  (local-set-key "\C-c\C-t" 'hide-body)
  (local-set-key "\C-c\C-s" 'outline-toggle-children)

  ;; which function am I editing?
  (when (>= emacs-major-version 23)
    (which-function-mode t))

  ;; autocomplete in python
  (auto-complete-mode)
;;  (auto-complete-mode 1)

  ;;(add-to-list 'ac-omni-completion-sources
  ;;  (cons "\\." '(ac-source-semantic)))
  ;;(add-to-list 'ac-omni-completion-sources
  ;;  (cons "->" '(ac-source-semantic)))
  (setq ac-sources '(ac-source-semantic
                     ac-source-words-in-buffer
                     ac-source-ropemacs))
;;                     ac-source-yasnippet))


  (setq py-smart-indentation nil))
  ;;(my-start-scripting-mode "py" "#!/usr/bin/python"))

(add-hook 'python-mode-hook 'my-python-startup)


;; ---------------------------------------------------- [ ipython ]
(setq ipython-command "~/environment/python/2.5/bin/ipython")
(setq py-python-command "~/environment/python/2.5/bin/ipython")
(setq py-python-command-args '("-pylab" "-colors" "Linux"))

(require 'ipython)

(defun my-ipython-startup ()
  "Setup IPython shell hook."
  (interactive))

  ;; comint mode:
  ;;(require 'comint))
  ;; (define-key comint-mode-map [(control p)]
  ;;   'comint-previous-matching-input-from-input)
  ;; (define-key comint-mode-map [(control n)]
  ;;   'comint-next-matching-input-from-input)
  ;; (define-key comint-mode-map [(control meta n)]
  ;;   'comint-next-input)
  ;; (define-key comint-mode-map [(control meta p)]
  ;;   'comint-previous-input)
  ;; (local-unset-key (kbd "<tab>"))
  ;; (local-set-key (kbd "s") 'other-window))

  ;(define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete))

(add-hook 'ipython-shell-hook 'my-ipython-startup)

