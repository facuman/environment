;; -----------------------------------------------------------------------
;; Facuman's .emacs
;; -----------------------------------------------------------------------

;; -----------------------------------------------------------------------
;; Sources:
;;   + Structure and some of the settings:
;;        --> http://www.elliotglaysher.org/emacs.html
;;   + Python, misc settings and multiple file layout from:
;;        --> http://www.enigmacurry.com/
;;   + Some dired tips and useful keybindings
;;        --> http://xahlee.org/emacs/effective_emacs.html
;;   + Several other sources... credit were it's due. Thx ^_^
;; -----------------------------------------------------------------------


;; -----------------------------------------------------------------------
;;  Module Load paths
;; -----------------------------------------------------------------------
(add-to-list 'load-path "~/environment/emacs/modes/")
(add-to-list 'load-path "~/environment/emacs/modes/custom/")
(add-to-list 'load-path "~/environment/emacs/modes/yasnippet-repo/")
(add-to-list 'load-path "~/environment/emacs/modes/anything-config/")
(add-to-list 'load-path "~/environment/emacs/modes/testing/")
(add-to-list 'load-path "~/environment/emacs/modes/geben/")
(setq byte-compile-warnings nil)

;; -----------------------------------------------------------------------
;;  Custom variables
;; -----------------------------------------------------------------------

;; -----------------------------------------------------------------------
;; Autoloads (aka, the way to make emacs fast)
;; -----------------------------------------------------------------------
(autoload 'hide-ifdef-define "hideif" nil t)
(autoload 'geben "geben" "DBGp protocol front-end" t)
(autoload 'hide-ifdef-undef  "hideif" nil t)
(autoload 'make-regexp "make-regexp"
  "Return a regexp to match a string item in STRINGS." t)
(autoload 'make-regexps "make-regexp"  "Return a regexp to REGEXPS." t)
(autoload 'svn-status "psvn" "Psvn.el status mode." t)
(autoload 'vc-git "vc-git" "Autoload vc git handling." t)
(autoload 'magit-status "magit-status" "Autoload magit-status." t)
(autoload 'iswitch-default-keybindings "iswitch-buffer"
  "Switch buffer by susbtring" t)





;; -----------------------------------------------------------------------
;; auto-mode-alist
;; -----------------------------------------------------------------------
(setq auto-mode-alist
      (append '(("\\.[Cc][Xx][Xx]$" . c++-mode)
                ("\\.[Cc][Pp][Pp]$" . c++-mode)
                ("\\.[Hh][Xx][Xx]$" . c++-mode)
                ("\\.[Tt][Cc][Cc]$" . c++-mode)
                ("\\.h$" . c++-mode)
                ("\\.i$" . c++-mode)    ; SWIG
                ("\\.mm?$" . objc-mode)
                ("_emacs" . lisp-mode)
                ("\\.el\\.gz$" . lisp-mode)
                ("\\.mak$" . makefile-mode)
                ("\\.conf$" . conf-mode)
                ("Doxyfile.tmpl$" . makefile-mode)
                ("Doxyfile$" . makefile-mode)
                ("\\.ke$" . kepago-mode)
                ("\\.kfn$" . kfn-mode)
                ("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode)
                ("\\.rb$" . ruby-mode)
                ("\\.cml$" . xml-mode)
                ("\\.cg$" . cg-mode)
                ("\\.y$" . bison-mode)
                ("\\.yy$" . bison-mode)
                ("\\.l$" . flex-mode)
                ("\\.ll$" . flex-mode)
                ("\\.lua$" . lua-mode)
                ("\\.org$" . org-mode)
                ("\\.py$" . python-mode)
                ("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode)
                ) auto-mode-alist))

(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; -----------------------------------------------------------------------
;; Startup variables
;; -----------------------------------------------------------------------

;; ------------------------------------------------------------- [ startup ]
;; We have extra ram these days. Use 3 megs of memory to speed up
;; runtime a bit. This shaves off about 1/10 of a second on startup.
(setq gc-cons-threshold (max 3000000 gc-cons-threshold))

;; Set up coding system.
(prefer-coding-system 'utf-8)

(setq user-full-name "Facundo de Guzmán"
	  user-mail-address "facudeguzman@gmail.com"

      enable-local-variables :safe
      inhibit-startup-message t
      default-major-mode 'text-mode
      require-final-newline t
      default-fill-column 80
      frame-title-format (concat user-login-name "@" system-name))


;;(set-default-font "Bitstream Vera Sans Mono-10")

;; disable toolbars
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; display time in status bar:
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

(add-hook 'suspend-hook 'do-auto-save) ;; Auto-Save on ^Z

(setq-default echo-keystrokes 2
              next-screen-context-lines 4
              compilation-scroll-output t
              tags-revert-without-query t)

(put 'eval-expression 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p) ;; Make all yes-or-no questions as y-or-n

;; delete trailing whitespace before saving:
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Increase the maximum size on buffers that should be fontified
(setq font-lock-maximum-size 1256000)

(global-font-lock-mode 1)
;; (setq font-lock-maximum-decoration t)    ; maximizing font coloration
(global-hl-line-mode t)                  ; highlight the current line

;; (pending-delete-mode)        ;; replace the selection when typing
(transient-mark-mode t)      ;; funky X selection highlighting thing

;; Highlight matching parenthesis (and other bracket likes)
(show-paren-mode t)

;; Shut off message buffer.  To debug Emacs, comment these out so you can see
;; what's going on.
(setq message-log-max nil)
;; Check if message buffer exists before killing (not doing so errors
;; eval-buffers of .emacs file).
(cond ((not (eq (get-buffer "*Messages*") nil))
      (kill-buffer "*Messages*")))

;; Provide a useful error trace if loading this .emacs fails.
(setq debug-on-error t)

;; Specify UTF-8 for a few addons that are too dumb to default to it.
(set-default-coding-systems 'utf-8)
(prefer-coding-system       'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Keeps the cursor in the same relative row during pgups and downs.
(setq scroll-preserve-screen-position t)

;; Prevent windows from getting too small.
(setq window-min-height 2)

;; Show column number in mode line.
(setq column-number-mode t)

;; Line numbers, vim style
(require 'linum)
(global-linum-mode 1)

;; Ignore case when looking for a file
(setq read-file-name-completion-ignore-case t)

;; Use spaces instead of tab
(setq-default indent-tabs-mode nil)

;; Set tab width
(setq default-tab-width 4)

;; Makes final line always be a return
(setq require-final-newline t)

;; Disable tooltips
(tooltip-mode nil)

;; This causes emacs to replace the current selection with a character
;; typed, similar to what most other programs do
;; NOTE: Does not work with autopair's word wrap
;; (delete-selection-mode 1)


;; ------------------------------------------------------------- [ keybindings]
;; use ergonomic key shortcuts
(load-file "~/environment/emacs/modes/ergonomic_keybinding_qwerty_4.3.13.el")

(global-set-key [f6] '(lambda () (interactive) (point-to-register ?1)))    ; F6 stores a position in a file
(global-set-key [f7] '(lambda () (interactive) (register-to-point ?1)))    ; F7 brings you back to this position
(global-set-key [f3] 'undo)
(global-set-key [(control shift e)] 'comment-or-uncomment-region)
(global-set-key "\M-3" 'split-window-horizontally)
(global-set-key "\M-g" 'goto-line) ;; bind goto line to M-x g

;; open keyboard shortcut image with F8 key
(global-set-key (kbd "<f8>")
  (lambda ()
    (interactive)
    (find-file "~/environment/emacs/modes/ergonomic_emacs_layout_qwerty.png")))

;; Indents the entire buffer according to whatever indenting rules are present.
(defun bcm-indent ()
  "Indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))
;; This is so commonly used, binding to F4.
(global-set-key (kbd "<f4>") 'bcm-indent)


;; ------------------------------------------------------------- [ backup-dir ]
;; Changes the location where backup files are placed. Instead of
;; being spread out all over the filesystem, they're now placed in one
;; location.
(setq temporary-backup-directory "~/.Trash/emacs-backups")
(setq backup-by-copying t)
(setq backup-directory-alist
	`((".*" . ,temporary-backup-directory)))

(setq temporary-autosave-directory "~/.Trash/emacs-autosaves")
(setq auto-save-file-name-transforms
        `((".*" ,temporary-autosave-directory t)))


;; ------------------------------------------------------------ [ smooth-scrolling ]
(setq scroll-step 1)
(setq scroll-conservatively 5)

;; -----------------------------------------------------------------------
;; Modules loaded at startup (and their configuration)
;; -----------------------------------------------------------------------

;; ------------------------------------------------------------- [ cedet ]
;;(add-to-list 'load-path "~/environment/emacs/modes/cedet/common")
;;(add-to-list 'load-path "~/environment/emacs/modes/cedet/semantic")

;; require the main cedet mode
;;(require 'cedet)

;; (require 'ede)
;; (setq global-ede-mode t)
;; (global-ede-mode 1)

;;(require 'semantic-ia)

;;make all the 'semantic.cache' files go somewhere sane
;;(setq semanticdb-default-save-directory "~/.emacs.d/semantic.cache ")
;;(semantic-load-enable-gaudy-code-helpers)  ; enable syntax highlighting with semantic


;; ------------------------------------------------------------- [ ecb ]
;;(add-to-list 'load-path "~/environment/emacs/modes/ecb")
;;(add-to-list 'load-path "~/environment/emacs/modes/cedet/eieio")
;;(add-to-list 'load-path "~/environment/emacs/modes/cedet/semantic")
;;(add-to-list 'load-path "~/environment/emacs/modes/cedet/speedbar")

;; (require 'ecb)


;; ;; Deactivate tip of the day
;; (setq ecb-tip-of-the-day nil)

;; ;; Open files with a mouse click
;; (setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))

;; ;; (ecb-activate)

;; ;; Activate Semantic
;; (setq semantic-load-turn-everything-on t)
;; (require 'semantic-load)


;; (defun my-ecb-startup ()
;;   "Ecb startup."
;;   (setq semantic-load-turn-useful-things-on t)
;;   (setq global-semantic-show-tag-boundaries-mode nil)
;;   (setq global-semantic-show-parser-state-mode nil)
;;   (setq semanticdb-default-save-directory "/tmp")
;;   (setq semanticdb-global-mode nil)
;;   (setq semanticdb-persistent-path (quote (never)))
;;   (semantic-load-enable-code-helpers)
;;   (global-semantic-auto-parse-mode -1)
;;   (global-semantic-show-unmatched-syntax-mode -1)
;;   (setq truncate-partial-width-windows nil))

;; (add-hook 'ecb-mode-hook 'my-ecb-startup)


;; ------------------------------------------------------------- [ yasnippet ]
(require 'yasnippet)

;Don't map TAB to yasnippet
;In fact, set it to something we'll never use because
;we'll only ever trigger it indirectly.
(setq yas/trigger-key (kbd "C-c <kp-multiply>"))

(yas/initialize)
;;(set-face-background  'yas/field-highlight-face "Grey10")
;;(set-face-background  'yas/mirror-highlight-face "Grey10")
(yas/load-directory "~/environment/emacs/modes/yasnippet-repo/snippets")

(setq yas/prompt-functions '(yas/ido-prompt yas/dropdown-prompt))


;; ------------------------------------------------------------- [ autopair ]
;; Autoclose parenthesis

(require 'auto-complete)
(require 'auto-complete-python)
(require 'auto-complete-yasnippet)
;;(require 'auto-complete-css)

(add-to-list 'ac-dictionary-directories "~/environment/emacs/modes/testing/")
;;(ac-config-default)
;;(require 'auto-complete-config)

(global-auto-complete-mode t) ;; Set autocomplete by default

(defun my-auto-complete-startup ()
  "Autcomplete default settings."
  (setq-default ac-sources '(ac-source-abbrev ac-source-words-in-buffer))

  ;;(set-face-foreground 'ac-menu-face "wheat")
  ;;(set-face-background 'ac-menu-face "darkslategrey")
  ;;(set-face-underline 'ac-menu-face "wheat")
  ;;(set-face-foreground 'ac-selection-face "white")
  ;;(set-face-background 'ac-selection-face "darkolivegreen")
  (setq ac-auto-start 4) ; start auto-completion after 4 chars only
  (global-set-key "\C-c1" 'auto-complete-mode) ; easy key to toggle AC on/off

  (define-key ac-complete-mode-map (kbd "M-TAB") 'ac-complete)
  (define-key ac-complete-mode-map "\r" nil))

  ;; Use C-n/C-p to select candidates
  ;; (define-key ac-complete-mode-map "\C-n" 'ac-next)
  ;; (define-key ac-complete-mode-map "\C-p" 'ac-previous))

(add-hook 'auto-complete-mode-hook 'my-auto-complete-startup)


;; ------------------------------------------------------------- [ sr-speedbar ]
;; (require 'sr-speedbar)


;; ------------------------------------------------------------- [ uniquify ]
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")


;; ------------------------------------------------------------- [ themes ]
(add-to-list 'load-path "~/environment/emacs/themes/")
(require 'color-theme)
(color-theme-initialize)
(require 'zenburn)
(zenburn)
(setq default-major-mode 'zenburn) ;; autoload zenburn


;; ------------------------------------------------------------- [ ido-mode ]
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)


(defadvice completing-read
  (around foo activate)
  (if (boundp 'ido-cur-list)
      ad-do-it
    (setq ad-return-value
          (ido-completing-read
           prompt
           (all-completions "" collection predicate)
           nil require-match initial-input hist def))))

(setq ido-execute-command-cache nil)

(defun ido-execute-command ()
  (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-a "
      (progn
        (unless ido-execute-command-cache
          (mapatoms (lambda (s)
                      (when (commandp s)
                        (setq ido-execute-command-cache
                              (cons (format "%S" s) ido-execute-command-cache))))))
        ido-execute-command-cache)))))
(global-set-key "\M-a" 'ido-execute-command)

;;(add-hook 'ido-setup-hook
;;          (lambda ()
;;            (setq ido-enable-flex-matching t)
;;            (global-set-key "\M-a" 'ido-execute-command)
;;            ))


;; ------------------------------------------------------------- [ cua ]
;CUA Mode is awesome, if for nothing else than it's super easy rectangular selections.

;I really don't care to emulate windows keybindings, so lets turn those off.
(setq cua-enable-cua-keys nil)
(cua-mode t)

;I don't want shift+arrow style marking either.
(cua-selection-mode nil)


;; ------------------------------------------------------------- [ dired ]
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


;; ------------------------------------------------------------- [ ediff ]
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; ------------------------------------------------------------- [ anything ]
(require 'anything-config)
(require 'anything-show-completion)
(require 'anything)
(require 'anything-match-plugin)
(require 'ac-anything)
(require 'anything-c-yasnippet)
(require 'anything-ipython)

;; (defun facuman-autocomplete-anything ()
;;   (interactive)
;;   (anything-other-buffer
;;    '(anything-c-source-auto-complete-candidates)
;; ;;     anything-c-source-yasnippet)
;;    " *facuman-autocomplete-anything*"))
;; (global-set-key "\M-u" 'facuman-autocomplete-anything)

;; (defun facuman-emacs-anything ()
;;   (interactive)
;;   (anything-other-buffer
;;    '(anything-c-source-buffers+
;;      anything-c-source-emacs-commands)
;;    " *facuman-emacs-anything*"))
;; (global-set-key "\M-a" 'facuman-emacs-anything)

(defun facuman-files-anything ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-ffap-guesser
     anything-c-source-ffap-line
     anything-c-source-locate
     anything-c-source-recentf)
   " *facuman-files-anything*"))
(global-set-key "\C-o" 'facuman-files-anything)

(defun facuman-current-buffer-anything ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-fixme
     anything-c-source-semantic
     anything-c-source-occur)
   " *facuman-current-buffer-anything*"))
(global-set-key "\C-u" 'facuman-current-buffer-anything)


;; Select something that you put in the kill ring ages ago.
(global-set-key "\C-k" 'anything-show-kill-ring)

;; Drop-in replacement of `query-replace-regexp' with building regexp visually.
(global-set-key "\M-5" 'anything-query-replace-regexp)



;; ------------------------------------------------------------- [ flymake ]
;; When turning on flyspell-mode, automatically check the entire buffer.
;; Why this isn't the default baffles me.
(defadvice flyspell-mode (after advice-flyspell-check-buffer-on-start activate)
  (flyspell-buffer))

(setq pycodechecker "~/environment/python/pylint_etc_wrapper.py/pylint_etc_wrapper.py")
(when (load "flymake" t)
  (load-library "flymake-cursor")
  (defun dss/flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" dss/flymake-pycodecheck-init)))

(defun dss/pylint-msgid-at-point ()
  (interactive)
  (let (msgid
        (line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info msgid)
      (if (eq (car elem) line-no)
            (let ((err (car (second elem))))
              (setq msgid (second (split-string (flymake-ler-text err)))))))))

(defun dss/pylint-silence (msgid)
  "Add a special pylint comment to silence a particular warning."
  (interactive (list (read-from-minibuffer "msgid: " (dss/pylint-msgid-at-point))))
  (save-excursion
    (comment-dwim nil)
    (if (looking-at "pylint:")
        (progn (end-of-line)
               (insert ","))
        (insert "pylint: disable-msg="))
    (insert msgid)))


;; ------------------------------------------------------------- [ recent ]
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 50)
(setq recentf-exclude (append recentf-exclude '("/usr*")))
(setq bookmark-save-flag 1)


;; ------------------------------------------------------------- [ diminish ]
;; Makes minor mode names in the modeline shorter.
(require 'diminish)

(eval-after-load "flymake"
  '(diminish 'flymake-mode "Fly"))
;; (eval-after-load "Python"
;;   '(diminish 'python-mode "Py"))
(eval-after-load "abbrev"
  '(diminish 'abbrev-mode "Abv"))
(eval-after-load "doxymacs"
  '(diminish 'doxymacs-mode "dox"))
;; (eval-after-load "Emacs-Lisp"
;;   '(diminish 'emacs-lisp-mode "Elisp"))


;; ------------------------------------------------------------- [ pager ]
;;; Excellent package for better scrolling in emacs
;;; should be default package. But now it can be downloaded
;;; from: http://user.it.uu.se/~mic/pager.el
(require 'pager)
(global-set-key (kbd "<Next>")    'pager-page-down)
(global-set-key (kbd "<Prior>")     'pager-page-up)
(global-set-key '[M-up]    'pager-row-up)
(global-set-key '[M-down]  'pager-row-down)


;; ------------------------------------------------------------- [ cperl ]
;;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)

(eval-after-load "cperl"
  '(progn
     (setq cperl-hairy t)))

(defun my-cperl-startup ()
  "Setup cperl."
  (interactive)
  (local-set-key '[pause] 'perldb)
  (setq gud-perldb-command-name "~/environment/binaries/ActivePerl-5.8/bin/perl -w ") ; For warnings
  (setq tab-width 8)

  (setq
   cperl-close-paren-offset -4
   cperl-continued-statement-offset 4
   cperl-indent-level 4
   cperl-indent-parens-as-block t
   cperl-tabs-always-indent t)

  ;; enable completiton
  (setq plcmp-use-keymap nil) ; disable key completiton keybindings
  (require 'perl-completion)
  (perl-completion-mode t)

  (when (require 'auto-complete nil t) ; no error whatever auto-complete.el is not installed.
    (auto-complete-mode t)
    (make-variable-buffer-local 'ac-sources)
    (setq ac-sources
          '(ac-source-perl-completion))))
  ;;(my-start-scripting-mode "pl" "#!/usr/bin/perl"))

(add-hook 'cperl-mode-hook 'my-cperl-startup)


;; ------------------------------------------------------------- [ column-marker ]
(require 'column-marker)


;; ------------------------------------------------------------- [ python ]
(require 'python)
;; (require 'dbgr)

;;(require 'pydbgr)

;;(setq ipython-command "~/environment/python/2.5/bin/ipython")
(setq ipython-command "/usr/bin/ipython")
(require 'ipython)
;;(setq py-python-command "~/environment/python/2.5/bin/ipython")
(setq py-python-command "/usr/bin/ipython")
(setq py-python-command-args '( "-colors" "Linux"))
;;(setq py-python-command-args '("-pylab" "-colors" "Linux"))

(defadvice py-execute-buffer (around python-keep-focus activate)
  "return focus to python code buffer"
  (save-excursion ad-do-it))

;; Initialize Pymacs
;;
(when (require 'pymacs)
  (setenv "PYMACS_PYTHON" "~/environment/python/2.5/bin/python")

  (load "~/environment/emacs/modes/testing/ac-ropemacs-config.el")

  (add-hook 'rope-open-project-hook 'ac-nropemacs-setup)

  ;; Initialize Rope
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-guess-project t)
  (setq ropemacs-enable-autoimport t)
  (setq ropemacs-codeassist-maxfixes 3)


  ;; Adding hook to automatically open a rope project if there is one
  ;; in the current or in the upper level directory
  (add-hook 'python-mode-hook
            (lambda ()
              (cond ((file-exists-p ".ropeproject")
                     (rope-open-project default-directory))
                    ((file-exists-p "../.ropeproject")
                     (rope-open-project (concat default-directory "..")))
                    )))

  (define-key ropemacs-local-keymap [(meta /)] 'dabbrev-expand)
  (define-key ropemacs-local-keymap [(control /)] 'hippie-expand)
  (define-key ropemacs-local-keymap [(control c) (control /)] 'rope-code-assist))

(provide 'python-programming)

;;(require 'pycomplete)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)

(setq pylookup-dir "/home/fdeguzman/environment/emacs/modes")
(add-to-list 'load-path pylookup-dir)

;; load pylookup when compile time
(eval-when-compile (require 'pylookup))
(require 'pylookup)
;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)


(defadvice py-execute-buffer (after advice-delete-output-window activate)
  (delete-windows-on "*Python Output*"))

;; EnigmaCurry's excellent Auto-completion
;; Integrates:
;; 1) Rope
;; 2) Yasnippet
;; all with AutoComplete.el
(defun prefix-list-elements (list prefix)
  (let (value)
    (nreverse
     (dolist (element list value)
      (setq value (cons (format "%s%s" prefix element) value))))))

(defvar ac-source-rope
  '((candidates
     . (lambda ()
         (prefix-list-elements (rope-completions) ac-target))))
  "Source for Rope")

(defun ac-python-find ()
  "Python `ac-find-function'."
  (require 'thingatpt)
  (let ((symbol (car-safe (bounds-of-thing-at-point 'symbol))))
    (if (null symbol)
        (if (string= "." (buffer-substring (- (point) 1) (point)))
            (point)
          nil)
      symbol)))

(defun ac-python-candidate ()
  "Python `ac-candidates-function'"
  (let (candidates)
    (dolist (source ac-sources)
      (if (symbolp source)
          (setq source (symbol-value source)))
      (let* ((ac-limit (or (cdr-safe (assq 'limit source)) ac-limit))
             (requires (cdr-safe (assq 'requires source)))
             cand)
        (if (or (null requires)
                (>= (length ac-target) requires))
            (setq cand
                  (delq nil
                        (mapcar (lambda (candidate)
                                  (propertize candidate 'source source))
                                (funcall (cdr (assq 'candidates source)))))))
        (if (and (> ac-limit 1)
                 (> (length cand) ac-limit))
            (setcdr (nthcdr (1- ac-limit) cand) nil))
        (setq candidates (append candidates cand))))
    (delete-dups candidates)))

(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "pdb.set_trace()"))

(defun python-add-breakpoint ()
  (interactive)
  (py-newline-and-indent)
  (insert "import ipdb; ipdb.set_trace()")
  (highlight-lines-matching-regexp "^[ 	]*import ipdb; ipdb.set_trace()"))

(defun my-python-mode-startup ()
  "Setup Python style."
  (interactive)

  ;;(flymake-mode 1)

  (annotate-pdb)
  (local-set-key '[f4] 'pdb)
  (define-key python-mode-map (kbd "C-c C-t") 'python-add-breakpoint)

  (setq tab-width 4)
  ;;(define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)
  (setq indent-tabs-mode nil)  ; Autoconvert tabs to spaces
  (setq python-indent 4)
  (setq python-continuation-offset 2)
  ;;(eldoc-mode 1)

  (set-variable 'py-indent-offset 4)
  (set-variable 'py-smart-indentation nil)
  (set-variable 'indent-tabs-mode nil)
  ;;(highlight-beyond-fill-column)

  ;; 80 column rule
  (column-marker-1 80)

  ;; remove trailing whitespace
  (setq show-trailing-whitespace t)

  ;; python mode combined with outline minor mode:
  (outline-minor-mode 1)
  (setq outline-regexp "def\\|class ")
  (setq coding-system-for-write 'utf-8)

  (local-set-key "\C-c C-a" 'show-all)
  (local-set-key "\C-c C-t" 'hide-body)
  (local-set-key "\C-c C-s" 'outline-toggle-children)

  (setq py-block-comment-prefix "#")
  (setq py-ask-about-save nil)

  (global-set-key "\M-p" 'anything-ipython-complete)
  (define-key python-mode-map "\C-m" 'newline-and-indent)
  (define-key python-mode-map (kbd "|") 'py-shell)
  (define-key python-mode-map (kbd "<f12>") 'py-execute-buffer)
  (define-key python-mode-map "\C-e" 'py-comment-region)
  (define-key python-mode-map "\C-r" 'rope-rename)
;;  (define-key python-mode-map "\C-\-" 'flymake-goto-next-error)
  (define-key python-mode-map "\C-d" 'rope-show-doc)
;;  (define-key python-mode-map "\C--d" 'rope-goto-definition)

  ;; which function am I editing?
  (when (>= emacs-major-version 23)
    (which-function-mode t))

  ;; autocomplete in python
  ;; (auto-complete-mode)
  ;;(auto-complete-mode 1)

  (set (make-local-variable 'ac-sources)
       (append ac-sources '(ac-source-rope)))
  (set (make-local-variable 'ac-find-function) 'ac-python-find)
  (set (make-local-variable 'ac-candidate-function) 'ac-python-candidate)
  (set (make-local-variable 'ac-auto-start) nil))

(add-hook 'python-mode-hook 'my-python-mode-startup)


;; ---------------------------------------------------- [ commint ]
(require 'comint)
(define-key comint-mode-map [(control p)]
  'comint-previous-matching-input-from-input)
(define-key comint-mode-map [(control n)]
  'comint-next-matching-input-from-input)
(define-key comint-mode-map [(control meta n)]
  'comint-next-input)
(define-key comint-mode-map [(control meta p)]
  'comint-previous-input)


;; ---------------------------------------------------- [ ipython ]
;;(setq ipython-command "~/environment/python/2.5/bin/ipython")
;;(setq py-python-command "~/environment/python/2.5/bin/ipython")
;;(setq py-python-command-args '("-pylab" "-colors" "Linux"))


;;(require 'ipython)

;;(defun my-ipython-startup ()
;;  "Setup IPython shell hook."
;;  (interactive)

  ;; comint mode:
  ;;(require 'comint)
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

;;  (define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete))

;;(add-hook 'ipython-shell-hook 'my-ipython-startup)


;; ------------------------------------------------------------- [ tidy ]
;; Tidy mode settings
(autoload 'tidy-buffer "tidy" "Run Tidy HTML parser on current buffer" t)
(autoload 'tidy-parse-config-file "tidy" "Parse the `tidy-config-file'" t)
(autoload 'tidy-save-settings "tidy" "Save settings to `tidy-config-file'" t)
(autoload 'tidy-build-menu  "tidy" "Install an options menu for HTML Tidy." t)

(defun my-tidy-startup ()
  "Tidy temp."
  '(tidy-temp-directory "~/.tidy/temp"))

(add-hook 'tidy-mode-hook 'my-tidy-startup)


;; ------------------------------------------------------------ [ haskell ]
;; Haskell mode settings
(require 'haskell-mode)

(defun my-haskell-startup ()
  "Haskell standard startup configuration"

  ;; "To show pretty symbols on the file. I'm not using it too much because of the color theme"
  (setq haskell-font-lock-symbols 'unicode)

  ;; "Change ghci path if needed"
  ;;    (setq haskell-program-name "/some/where/ghci")

  (turn-on-haskell-doc-mode)
  (turn-on-haskell-decl-scan)
  (turn-on-haskell-ghci)
  (turn-on-font-lock)
  (turn-on-haskell-simple-indent))

(add-hook 'haskell-mode-hook 'my-haskell-startup)


;; ;; ------------------------------------------------------------- [ eshell ]
;; ;; eshell C-a to jump to command start only:
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


;; ------------------------------------------------------------- [ saveplace ]
;; instead of save desktop, rather save last editing place in files,
;; as well as minibuffer:
(require 'saveplace)
(setq-default save-place t)
(savehist-mode t)


;; ------------------------------------------------------------- [ magit ]
;; (add-to-list 'load-path "~/environment/emacs/modes/magit")
;; (autoload 'magit-status "magit" "Git status mode" t)


;; ------------------------------------------------------------- [ elisp ]
(defun my-elisp-startup ()
  (interactive)
;;-  (start-programing-mode)

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


;; ------------------------------------------------------------- [ html ]
(defun my-html-mode-hook () "Customize my html-mode."
   (tidy-build-menu html-mode-map)
   (local-set-key [(control c) (control c)] 'tidy-buffer)
   (setq sgml-validate-command "tidy"))

(add-hook 'html-mode-hook 'my-html-mode-hook)

;; For other modes (like html-helper-mode) simple change the variables
;; `html-mode-hook' and `html-mode-map' to whatever is appropriate e.g.

(defun my-html-helper-mode-hook () "Customize my html-helper-mode."
   (tidy-build-menu html-helper-mode-map)
   (local-set-key [(control c) (control c)] 'tidy-buffer)
   (setq sgml-validate-command "tidy"))

(add-hook 'html-helper-mode-hook 'my-html-helper-mode-hook)

;; ------------------------------------------------------------- [ tabbar ]
;;(require 'tabbar)
(dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
  (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))

(defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
  `(defun ,name (arg)
     (interactive "P")
     ,do-always
     (if (equal nil arg)
         ,on-no-prefix
       ,on-prefix)))

(defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))
(defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) (tabbar-mode 1))

(global-set-key [(control tab)] 'shk-tabbar-next)
(global-set-key [(control shift tab)] 'shk-tabbar-prev)

(when (require 'tabbar)
      (set-face-attribute 'tabbar-default nil :background "gray60")
      (set-face-attribute 'tabbar-unselected nil
                          :background "gray85"
                          :foreground "gray30"
                          :box nil)
      (set-face-attribute 'tabbar-selected nil
                          :background "#f2f2f6"
                          :foreground "black"
                          :box nil)
      (set-face-attribute 'tabbar-button nil
                          :box '(:line-width 1 :color "gray72" :style released-button))
      (set-face-attribute 'tabbar-separator nil
                          :height 0.7))


;; ------------------------------------------------------------- [ iswitch-buffer ]
(require 'iswitch-buffer)
(setq iswitch-mode-hook nil)
(global-set-key (kbd "C-}") 'iswitch-buffer)


;; ------------------------------------------------------------- [ psvn ]
(require 'psvn)
(setq svn-status-verbose nil)

;; ------------------------------------------------------------- [ org ]
;;(require 'org-install)
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cb" 'org-iswitchb)

;; Org-mode settings
;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)

;;(setq org-clock-persist 'history)
;;(org-clock-persistence-insinuate)

;;(defun my-org-startup ()
;;  "Org mode default settings."
;;  (local-set-key "\M-n" 'outline-next-visible-heading)
;;  (local-set-key "\M-p" 'outline-previous-visible-heading)
;; table
;;  (local-set-key "\M-\C-w" 'org-table-copy-region)
;;  (local-set-key "\M-\C-y" 'org-table-paste-rectangle)
;;  (local-set-key "\M-\C-l" 'org-table-sort-lines)
  ;; display images
;;  (local-set-key "\M-I" 'org-toggle-iimage-in-org)
  ;; fix tab
;;  (local-set-key "\C-y" 'yank)
  ;; yasnippet (allow yasnippet to do it's thing in org files)
  ;; (make-variable-buffer-local 'yas/trigger-key)
  ;; (setq yas/trigger-key [tab])
  ;; (define-key yas/keymap [tab] 'yas/next-field-group)
;;  )

;;(add-hook 'org-mode-hook 'my-org-startup)


;; ------------------------------------------------------------- [ shell ]
(eval-after-load "shell"
  '(progn
     (ansi-color-for-comint-mode-on)))


;; -----------------------------------------------------------------------
;; Utility Methods
;; -----------------------------------------------------------------------
;; Reload the file without moving the cursor
(defun reload-file ()
  (interactive)
  (let ((curr-scroll (window-vscroll)))
    (find-file (buffer-name))
    (set-window-vscroll nil curr-scroll)
    (message "Reloaded file")))

;;(global-set-key "\C-r\C-r" 'reload-file)

;; Auto revert external modified files
(global-auto-revert-mode 1)


;; -----------------------------------------------------------------------
(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be php, perl, python, bash, java.
File suffix is used to determine what program to run."
(interactive)
  (let (ext-map file-name file-ext prog-name cmd-str)
; get the file name
; get the program name
; run it
    (setq ext-map
          '(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("sh" . "bash")
            ("java" . "javac")
            )
          )
    (setq file-name (buffer-file-name))
    (setq file-ext (file-name-extension file-name))
    (setq prog-name (cdr (assoc file-ext ext-map)))
    (setq cmd-str (concat prog-name " " file-name))
    (shell-command cmd-str)))
(global-set-key (kbd "<f12>") 'run-current-file)


;; ------------------------------------------------- [ intelligent-close ]
(defun intelligent-close ()
  "quit a frame the same way no matter what kind of frame you are on.

This method, when bound to C-x C-c, allows you to close an emacs frame the
same way, whether it's the sole window you have open, or whether it's
a \"child\" frame of a \"parent\" frame.  If you're like me, and use emacs in
a windowing environment, you probably have lots of frames open at any given
time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
frame, and to remember to do C-x C-x to close the main frame (and if you're
not careful, doing so will take all the child frames away with it).  This
is my solution to that: an intelligent close-frame operation that works in
all cases (even in an emacs -nw session).

Stolen from http://www.dotemacs.de/dotfiles/BenjaminRutt.emacs.html."
  (interactive)
  (if (eq (car (visible-frame-list)) (selected-frame))
      ;;for parent/master frame...
      (if (> (length (visible-frame-list)) 1)
          ;;close a parent with children present
          (delete-frame (selected-frame))
        ;;close a parent with no children present
        (save-buffers-kill-emacs))
    ;;close a child frame
    (delete-frame (selected-frame))))

(global-set-key "\C-x\C-c" 'intelligent-close) ;forward reference


;; ------------------------------------------------- [ close-compilation ]
;; Helper for compilation. Close the compilation window if
;; there was no error at all.
(defun compilation-exit-autoclose (status code msg)
;; If M-x compile exists with a 0
(when (and (eq status 'exit) (zerop code))
;; then bury the *compilation* buffer, so that C-x b doesn't go there
(bury-buffer)
;; and delete the *compilation* window
(delete-window (get-buffer-window (get-buffer "*compilation*"))))
;; Always return the anticipated result of compilation-exit-message-function
(cons msg code))
;; Specify my function (maybe I should have done a lambda function)
(setq compilation-exit-message-function 'compilation-exit-autoclose)

(setq compilation-scroll-output 1) ;; automatically scroll the compilation window
(setq compilation-window-height 7) ;; Set the compilation window height...


;; -----------------------------------------------------------------------
;; Helper Functions (used in mode startup)
;; -----------------------------------------------------------------------

;; --------------------------------------------- [ start-programing-mode ]
;;(defun start-programing-mode()
;;  (interactive)

  ;; Display column numbers only in code.
;;  (column-number-mode t)

  ;; Setup flyspell to make me not look like an idiot to my coworkers
  ;; and Haeleth and whoever else reads my code.
  ;;(flyspell-prog-mode)

  ;; From the 'project-root library.
  ;;(project-root-fetch)

  ;; All trailing whitespace needs to be highlighted so it can die.
;;  (setq show-trailing-whitespace t)

  ;; Highlight matching parenthesis (and other bracket likes)
;;  (show-paren-mode t))


;; -------------------------------------------------- [ select-vc-status ]
(defun select-vc-status ()
  "Calls for a directory and calls `svn-status' or `git-status' depending on what
type of version control found in that directory"
  (interactive)
  (let* ((local-default-dir
          (if (project-root-p) (cdr project-details) default-directory))
         (targetDir
          (read-directory-name "Status of directory: "
                               local-default-dir
                               local-default-dir
                               nil)))
    (cond ((file-exists-p (concat targetDir "/.git"))
           (git-status targetDir))
          ((file-exists-p (concat targetDir "/.svn"))
           (svn-status targetDir))
          ((file-exists-p (concat targetDir "/CVS"))
           (cvs-status targetDir)))))


;; ----------------------------------------- [ SVN Log Edit Mode Startup ]
(defun my-svn-load-edit-mode-startup ()
  (interactive)
  ;;(filladapt-mode t)
  (show-paren-mode t))
  ;;(flyspell-mode t))

(add-hook 'svn-log-edit-mode-hook 'my-svn-load-edit-mode-startup)


;; ----------------------------------------- [ Djcb's multi cursor color ]
;; Change cursor color according to mode; inspired by
;; http://www.emacswiki.org/emacs/ChangingCursorDynamically
;;(setq djcb-read-only-color       "gray")
;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar. HEIGHT); see the docs for set-cursor-type

;;(setq djcb-read-only-cursor-type 'hbar)
;;(setq djcb-overwrite-color       "red")
;;(setq djcb-overwrite-cursor-type 'box)
;;(setq djcb-normal-color          "white")
;;(setq djcb-normal-cursor-type    'bar)

;;(defun djcb-set-cursor-according-to-mode ()
;;  "change cursor color and type according to some minor modes."

;;  (cond
;;    (buffer-read-only
;;      (set-cursor-color djcb-read-only-color)
;;      (setq cursor-type djcb-read-only-cursor-type))
;;    (overwrite-mode
;;      (set-cursor-color djcb-overwrite-color)
;;      (setq cursor-type djcb-overwrite-cursor-type))
;;    (t
;;      (set-cursor-color djcb-normal-color)
;;      (setq cursor-type djcb-normal-cursor-type))))

;;(add-hook 'post-command-hook 'djcb-set-cursor-according-to-mode)


