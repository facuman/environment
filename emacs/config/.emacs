;; -----------------------------------------------------------------------
;; Facuman's .emacs
;; -----------------------------------------------------------------------

;; -----------------------------------------------------------------------
;; Sources:
;;   + Structure and some of the settings:
;;        --> http://www.elliotglaysher.org/emacs.html
;;   + Python settings mostly from:
;;        --> http://www.enigmacurry.com/
;;   + Some dired tips and useful keybindings
;;        --> http://xahlee.org/emacs/effective_emacs.html
;;   + Several other sources... credit were it's due. Thx ^_^
;; -----------------------------------------------------------------------

;; -----------------------------------------------------------------------
;; Garbage Collector
;; -----------------------------------------------------------------------
;; We have extra ram these days. Use 3 megs of memory to speed up
;; runtime a bit. This shaves off about 1/10 of a second on startup.
(setq gc-cons-threshold (max 3000000 gc-cons-threshold))


;; -----------------------------------------------------------------------
;;  Module Load paths
;; -----------------------------------------------------------------------
(add-to-list 'load-path "~/environment/emacs/modes/")
(add-to-list 'load-path "~/environment/emacs/modes/anything-config")
(add-to-list 'load-path "~/environment/emacs/modes/cperl-mode")
;;(add-to-list 'load-path "~/environment/emacs/modes/python-mode")
(add-to-list 'load-path "~/environment/emacs/modes/yasnippet")
(add-to-list 'load-path "~/environment/emacs/modes/ecb")
(add-to-list 'load-path "~/environment/emacs/modes/cedet/common")
(add-to-list 'load-path "~/environment/emacs/modes/magit")

(setq byte-compile-warnings nil)

;;(load-file "~/environment/emacs/modes/cedet/common/cedet.el") ;; load cedet


;; -----------------------------------------------------------------------
;; Themes
;; -----------------------------------------------------------------------
(add-to-list 'load-path "~/environment/emacs/themes/")
(require 'color-theme)
(color-theme-initialize)
(require 'zenburn)
(zenburn)
(setq default-major-mode 'zenburn) ;; autoload zenburn


(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))

(add-hook 'c-mode-hook          'my-tab-fix)
(add-hook 'sh-mode-hook         'my-tab-fix)
(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(only-global-abbrevs t))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; Reload the file without moving the cursor
(defun reload-file ()
  (interactive)
  (let ((curr-scroll (window-vscroll)))
    (find-file (buffer-name))
    (set-window-vscroll nil curr-scroll)
    (message "Reloaded file")))

(global-set-key "\C-c\C-r" 'reload-file)

;; Auto revert external modified files
(global-auto-revert-mode 1)

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
            ("pl" . "~/environment/binaries/ActivePerl-5.8/bin/perl")
;;            ("py" . "python")
            ("sh" . "bash")
            ("java" . "javac")
            )
          )
    (setq file-name (buffer-file-name))
    (setq file-ext (file-name-extension file-name))
    (setq prog-name (cdr (assoc file-ext ext-map)))
    (setq cmd-str (concat prog-name " " file-name))
    (shell-command cmd-str)))

(global-set-key (kbd "<f7>") 'run-current-file)


;; -----------------------------------------------------------------------
;; Autoloads (aka, the way to make emacs fast)
;; -----------------------------------------------------------------------
(autoload 'hide-ifdef-define "hideif" nil t)
(autoload 'hide-ifdef-undef  "hideif" nil t)
(autoload 'make-regexp "make-regexp"
  "Return a regexp to match a string item in STRINGS." t)
(autoload 'make-regexps "make-regexp"  "Return a regexp to REGEXPS." t)
(autoload 'magit-status "magit" "Git status mode" t)
;;(autoload 'git-status "git" "Git status mode." t)
(autoload 'svn-status "psvn" "Psvn.el status mode." t)

;; Tidy mode settings
(autoload 'tidy-buffer "tidy" "Run Tidy HTML parser on current buffer" t)
(autoload 'tidy-parse-config-file "tidy" "Parse the `tidy-config-file'" t)
(autoload 'tidy-save-settings "tidy" "Save settings to `tidy-config-file'" t)
(autoload 'tidy-build-menu  "tidy" "Install an options menu for HTML Tidy." t)


;; -----------------------------------------------------------------------
;; Set up coding system.
;; -----------------------------------------------------------------------
(prefer-coding-system 'utf-8)


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
;;                ("SCons\\(cript\\|truct\\)" . python-mode)                ("\\.gclient$" . python-mode)
                ("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode)
                ("perl" . cperl-mode)
                ("perl5" . cperl-mode)
                ("miniperl" . cperl-mode)
                ) auto-mode-alist))


;; -----------------------------------------------------------------------
;; Startup variables
;; -----------------------------------------------------------------------
(setq user-full-name "Facundo de Guzmán"
	  user-mail-address "facudeguzman@gmail.com"

      enable-local-variables :safe
      inhibit-startup-message t
      default-major-mode 'text-mode
      require-final-newline t
      default-tab-width 4
      default-fill-column 79
      frame-title-format (concat user-login-name "@" system-name))

;; display time in status bar:
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)

(add-hook 'suspend-hook 'do-auto-save) ;; Auto-Save on ^Z

(setq-default echo-keystrokes 2
              next-screen-context-lines 4
              compilation-scroll-output t
			  indent-tabs-mode nil
              tags-revert-without-query t)

(put 'eval-expression 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p) ;; Make all yes-or-no questions as y-or-n

;; delete trailing whitespace before saving:
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; bind Caps-Lock to M-x
;; http://sachachua.com/wp/2008/08/04/emacs-caps-lock-as-m-x/
;; of course, this disables normal Caps-Lock for *all* apps...
(if (eq window-system 'x)
    (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
(global-set-key [f13] 'execute-extended-command)

;; use ergonomic key shortcuts
(load-file "~/environment/emacs/modes/ergonomic_keybinding_qwerty.el")

;; bind goto line to M-x g
(global-set-key "\M-g" 'goto-line)

;;; window splitting keybindings
(global-set-key (kbd "M-2") 'split-window-vertically) ; was digit-argument
(global-set-key (kbd "M-1") 'delete-other-windows) ; was digit-argument
(global-set-key (kbd "M-s") 'other-window) ; was center-line



;; -----------------------------------------------------------------------
;; Modules loaded at startup (and their configuration)
;; -----------------------------------------------------------------------
;; ---------------------------------------------------------- [ ido-mode ]
(require 'ido)
(ido-mode t)


;; ---------------------------------------------------------- [ dired ]
;; alias rn to be able to edit a dired buffer as a normal text buffer
(defalias 'rn 'wdired-change-to-wdired-mode)


;; ---------------------------------------------------------- [ ediff ]
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; ---------------------------------------------------------- [ anything ]
(require 'anything-config)
(require 'anything-ipython)
(require 'anything-show-completion)
(require 'anything)


;; ---------------------------------------------------------- [ supercollider ]
(require 'sclang)


;; ---------------------------------------------------------- [ flymake ]
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


;; ---------------------------------------------------------- [ diminish ]
;; Makes minor mode names in the modeline shorter.
(require 'diminish)

;;(eval-after-load "filladapt"
;;  '(diminish 'filladapt-mode "Fill"))
(eval-after-load "abbrev"
  '(diminish 'abbrev-mode "Abv"))
(eval-after-load "doxymacs"
  '(diminish 'doxymacs-mode "dox"))


;; ------------------------------------------------------------- [ backup-dir ]
;; Changes the location where backup files are placed. Instead of
;; being spread out all over the filesystem, they're now placed in one
;; location.
(if (file-accessible-directory-p (expand-file-name "~/.Trash"))
    (add-to-list 'backup-directory-alist
                 (cons "." (expand-file-name "~/.Trash/emacs-backups/")))
    (add-to-list 'auto-save-file-name-transforms
                 (cons "." (expand-file-name "~/.Trash/emacs-autosaves/"))))



;; ------------------------------------------------------------- [ pager ]
;;; Excellent package for better scrolling in emacs
;;; should be default package. But now it can be downloaded
;;; from: http://user.it.uu.se/~mic/pager.el
(require 'pager)
(global-set-key "\C-v"     'pager-page-down)
(global-set-key [next]     'pager-page-down)
(global-set-key "\ev"      'pager-page-up)
(global-set-key [prior]    'pager-page-up)
(global-set-key '[M-up]    'pager-row-up)
(global-set-key '[M-kp-8]  'pager-row-up)
(global-set-key '[M-down]  'pager-row-down)
(global-set-key '[M-kp-2]  'pager-row-down)


;; ------------------------------------------------------------- [ browse-kill-ring ]
;; Select something that you put in the kill ring ages ago.
(autoload 'browse-kill-ring "browse-kill-ring" "Browse the kill ring." t)
(global-set-key (kbd "C-c k") 'browse-kill-ring)
(eval-after-load "browse-kill-ring"
  '(progn
     (setq browse-kill-ring-quit-action 'save-and-restore)))


;; ------------------------------------------------------------- [ shell ]
(eval-after-load "shell"
  '(progn
     (ansi-color-for-comint-mode-on)))


;; ------------------------------------------------------------- [ cperl ]
;;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)

(eval-after-load "cperl"
  '(progn
     (setq cperl-hairy t)))


;; ------------------------------------------------------------- [ autocomplete ]
(require 'auto-complete)
(global-auto-complete-mode t) ;; Set autocomplete by default


;; ------------------------------------------------------------- [ yasnippet ]
(require 'yasnippet)
(yas/initialize)
;;(set-face-background  'yas/field-highlight-face "Grey10")
;;(set-face-background  'yas/mirror-highlight-face "Grey10")
(yas/load-directory "~/environment/emacs/modes/yasnippet/snippets")


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

(require 'ipython)
(setq py-python-command "~/environment/python/2.5/bin/ipython")
(setq py-python-command-args '( "-colors" "Linux"))


;; ----------------------------------------------------------- [ ibuffer ]
;; *Nice* buffer switching
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-saved-filter-groups
      '(("default"
         ("version control" (or (mode . svn-status-mode)
                    (mode . svn-log-edit-mode)
                    (name . "^\\*svn-")
                    (name . "^\\*vc\\*$")
                    (name . "^\\*Annotate")
                    (name . "^\\*git-")
                    (name . "^\\*vc-")))
         ("emacs" (or (name . "^\\*scratch\\*$")
                      (name . "^\\*Messages\\*$")
                      (name . "^TAGS\\(<[0-9]+>\\)?$")
                      (name . "^\\*Help\\*$")
					  (name . "^\\*info\\*$")
					  (name . "^\\*Occur\\*$")
                      (name . "^\\*grep\\*$")
                      (name . "^\\*Compile-Log\\*$")
                      (name . "^\\*Backtrace\\*$")
					  (name . "^\\*Process List\\*$")
					  (name . "^\\*gud\\*$")
					  (name . "^\\*Man")
					  (name . "^\\*WoMan")
                      (name . "^\\*Kill Ring\\*$")
                      (name . "^\\*Completions\\*$")
                      (name . "^\\*tramp")
                      (name . "^\\*shell\\*$")
                      (name . "^\\*compilation\\*$")))
         ("emacs source" (or (mode . emacs-lisp-mode)
							 (filename . "/Applications/Emacs.app")
                             (filename . "/bin/emacs")))
         ("agenda" (or (name . "^\\*Calendar\\*$")
                       (name . "^diary$")
                       (name . "^\\*Agenda")
                       (name . "^\\*org-")
                       (name . "^\\*Org")
                       (mode . org-mode)
                       (mode . muse-mode)))
         ("latex" (or (mode . latex-mode)
                      (mode . LaTeX-mode)
                      (mode . bibtex-mode)
                      (mode . reftex-mode)))
         ("dired" (or (mode . dired-mode))))))



(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; Order the groups so the order is : [Default], [agenda], [emacs]
(defadvice ibuffer-generate-filter-groups (after reverse-ibuffer-groups ()
                                                 activate)
  (setq ad-return-value (nreverse ad-return-value)))


;; ------------------------------------------------------------- [ tempo ]
(defun tempo-space ()
  (interactive "*")
  (or (tempo-expand-if-complete)
	  (insert " ")))


;; ------------------------------------------------------------- [ cedet ]
;; require the main cedet mode
(require 'cedet)
(global-ede-mode t)
(require 'semantic-ia)


;; ------------------------------------------------------------- [ ecb ]
(require 'ecb)


;; ------------------------------------------------------------- [ saveplace ]
;; instead of save desktop, rather save last editing place in files,
;; as well as minibuffer:
(require 'saveplace)
(setq-default save-place t)
(savehist-mode t)


;; -----------------------------------------------------------------------
;; Utility Methods
;; -----------------------------------------------------------------------
;; Taken from O'Reilly Writing Emacs Extensions p 30-31

;; Restrict buffer movement to existing buffers
(defadvice switch-to-buffer (before existing-buffer activate compile)
  "When interactive, switch to existing buffers only, unless given a
prefix argument"
  (interactive
   (list (read-buffer "Switch to buffer: "
              (other-buffer)
              (null current-prefix-arg)))))

;; -----------------------------------------------------------------------

(defadvice switch-to-buffer-other-window (before existing-buffer
                         activate compile)
  "When interactive, switch to existing buffers only, unless given a
prefix argument"
  (interactive
   (list (read-buffer "Switch to buffer: "
              (other-buffer)
              (null current-prefix-arg)))))

;; -----------------------------------------------------------------------

(defadvice switch-to-buffer-other-frame (before existing-buffer activate
                        compile)
  "When interactive, switch to existing buffers only, unless given a
prefix argument"
  (interactive
   (list (read-buffer "Switch to buffer: "
              (other-buffer)
              (null current-prefix-arg)))))


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


;; -----------------------------------------------------------------------
;; Helper Functions (used in mode startup)
;; -----------------------------------------------------------------------

;; --------------------------------------------- [ start-programing-mode ]
(defun start-programing-mode()
  (interactive)

  ;; Display column numbers only in code.
  (column-number-mode t)

  ;; Setup flyspell to make me not look like an idiot to my coworkers
  ;; and Haeleth and whoever else reads my code.
  ;;(flyspell-prog-mode)

  ;; From the 'project-root library.
  ;;(project-root-fetch)

  ;; All trailing whitespace needs to be highlighted so it can die.
  (setq show-trailing-whitespace t)

  ;; Highlight matching parenthesis (and other bracket likes)
  (show-paren-mode t))


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


;; ------------------------------------------------------ [ Perl Startup ]
(defun my-perl-startup ()
  "Setup perl."
  (interactive)
  (local-set-key '[pause] 'perldb)
  (setq gud-perldb-command-name "~/environment/binaries/ActivePerl-5.8/bin/perl -w ") ; For warnings
  (setq tab-width 8)
  (setq indent-tabs-mode nil)  ; Autoconvert tabs to spaces
  (setq perl-indent-level 2)
  (setq perl-tab-always-indent nil) ; Indent if at left margin, else tab
  (setq perl-continued-statement-offset 2)
  (setq perl-continued-brace-offset -2))
  ;;(my-start-scripting-mode "pl" "#!/usr/bin/perl"))

(add-hook 'cperl-mode-hook 'my-perl-startup)


;; ---------------------------------------------------- [ Python startup ]
(defun my-python-startup ()
  "Setup Python style."
  (interactive)
  (local-set-key '[f4] 'pdb)
  (setq tab-width 2)
  ;;(define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)
  (setq indent-tabs-mode nil)  ; Autoconvert tabs to spaces
  (setq python-indent 2)
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


;; ---------------------------------------------------- [ dired startup ]
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


;; ---------------------------------------------------- [ IPython startup ]
(defun my-ipython-startup ()
  "Setup IPython shell hook."

  ;; comint mode:
  (require 'comint)
  (define-key comint-mode-map [(control p)]
    'comint-previous-matching-input-from-input)
  (define-key comint-mode-map [(control n)]
    'comint-next-matching-input-from-input)
  (define-key comint-mode-map [(control meta n)]
    'comint-next-input)
  (define-key comint-mode-map [(control meta p)]
    'comint-previous-input)
  )

  ;(define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete))

(add-hook 'ipython-shell-hook 'my-ipython-startup)


;; ---------------------------------------------------- [ Tidy startup ]
(defun my-tidy-startup ()
  "Tidy temp."
  '(tidy-temp-directory "~/.tidy/temp"))

(add-hook 'tidy-mode-hook 'my-tidy-startup)


;; ---------------------------------------------------- [ Ecb startup ]
(defun my-ecb-startup ()
  "Ecb startup."
  (setq semantic-load-turn-useful-things-on t)
  (setq global-semantic-show-tag-boundaries-mode nil)
  (setq global-semantic-show-parser-state-mode nil)
  (setq semanticdb-default-save-directory "/tmp")
  (setq semanticdb-global-mode nil)
  (setq semanticdb-persistent-path (quote (never)))
  (semantic-load-enable-code-helpers)
  (global-semantic-auto-parse-mode -1)
  (global-semantic-show-unmatched-syntax-mode -1)
  (setq truncate-partial-width-windows nil))

(add-hook 'ecb-mode-hook 'my-ecb-startup)


;; ---------------------------------------------------- [ Eshell startup ]
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


;; ---------------------------------------------------- [ Html startup ]
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


;; --------------------------------------------------------- [ C startup ]
(defun my-c-startup ()
  "Change C C++ and Obj-C indents."
  (interactive)

  (local-set-key "\C-css" 'insert-c-seperator-line)
  (local-set-key "\C-csh" 'insert-c-section-header)
  (local-set-key "\C-o" 'ff-get-other-file))

(add-hook 'c-mode-hook 'my-c-startup)


;; --------------------------------------------------------- [ Autocomplete ]
(defun my-auto-complete-startup ()
  "Autcomplete default settings."
  (setq-default ac-sources '(ac-source-abbrev ac-source-words-in-buffer))
  (require 'auto-complete-yasnippet)
  (require 'auto-complete-semantic)
  (require 'auto-complete-css)
  (require 'auto-complete-python)

  ;;(set-face-foreground 'ac-menu-face "wheat")
  ;;(set-face-background 'ac-menu-face "darkslategrey")
  ;;(set-face-underline 'ac-menu-face "wheat")
  ;;(set-face-foreground 'ac-selection-face "white")
  ;;(set-face-background 'ac-selection-face "darkolivegreen")
  (setq ac-auto-start 2) ; start auto-completion after 4 chars only
  (global-set-key "\C-c1" 'auto-complete-mode) ; easy key to toggle AC on/off
  (define-key ac-complete-mode-map "\t" 'ac-complete)
  (define-key ac-complete-mode-map "\r" nil)

  ;; Use C-n/C-p to select candidates
  (define-key ac-complete-mode-map "\C-n" 'ac-next)
  (define-key ac-complete-mode-map "\C-p" 'ac-previous))

(add-hook 'auto-complete-mode-hook 'my-auto-complete-startup)


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


;; ------------------------------------------------- [ Text Mode Startup ]
(defun my-textmode-startup ()
  (interactive)
  ;;(filladapt-mode t)
  ;;(flyspell-mode t)
  (local-set-key "\C-css" 'insert-text-seperator-line))

(add-hook 'text-mode-hook 'my-textmode-startup)


;; ----------------------------------------- [ SVN Log Edit Mode Startup ]
(defun my-svn-load-edit-mode-startup ()
  (interactive)
  ;;(filladapt-mode t)
  (show-paren-mode t))
  ;;(flyspell-mode t))

(add-hook 'svn-log-edit-mode-hook 'my-svn-load-edit-mode-startup)

