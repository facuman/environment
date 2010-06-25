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
;; Garbage Collector
;; -----------------------------------------------------------------------


;; -----------------------------------------------------------------------
;;  Module Load paths
;; -----------------------------------------------------------------------
(add-to-list 'load-path "~/environment/emacs/modes/")
(add-to-list 'load-path "~/environment/emacs/modes/custom/")
(add-to-list 'load-path "~/environment/emacs/modes/python-mode")
(add-to-list 'load-path "~/environment/emacs/modes/cedet/ede")
(add-to-list 'load-path "~/environment/emacs/modes/haskell-mode")


(setq byte-compile-warnings nil)


;; -----------------------------------------------------------------------
;;  Custom variables
;; -----------------------------------------------------------------------
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-name "left14")
 '(ecb-layout-window-sizes (quote (("test" (ecb-symboldef-buffer-name 0.18471337579617833 . 0.4888888888888889) (ecb-methods-buffer-name 0.18471337579617833 . 0.4888888888888889)))))
 '(ecb-options-version "2.40")
 '(ecb-tip-of-the-day nil)
 '(ecb-windows-width 0.25)
 '(only-global-abbrevs t)
 '(regex-tool-backend (quote perl)))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;; -----------------------------------------------------------------------
;; Autoloads (aka, the way to make emacs fast)
;; -----------------------------------------------------------------------
(autoload 'hide-ifdef-define "hideif" nil t)
(autoload 'hide-ifdef-undef  "hideif" nil t)
(autoload 'make-regexp "make-regexp"
  "Return a regexp to match a string item in STRINGS." t)
(autoload 'make-regexps "make-regexp"  "Return a regexp to REGEXPS." t)
(autoload 'svn-status "psvn" "Psvn.el status mode." t)
(autoload 'vc-git "vc-git" "Autoload vc git handling." t)
(autoload 'magit-status "magit-status" "Autoload magit-status." t)

;; -----------------------------------------------------------------------
;; auto-mode-alist
;; -----------------------------------------------------------------------
(setq auto-mode-alist
      (append '(("\\.[Cc][Xx][Xx]$" . c++-mode)
                ("\\.[Cc][Pp][Pp]$" . c++-mode)
                ("\\.[Hh][Xx][Xx]$" . c++-mode)
                ("\\.[Tt][Cc][Cc]$" . c++-mode)
                ("\\.h$" . c++-mode)
                ("\\.hs$" . haskell-mode)
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
                ("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode)
                ;;("perl" . cperl-mode)
                ;; ("perl5" . cperl-mode)
                ;; ("miniperl" . cperl-mode)
                ) auto-mode-alist))


;; -----------------------------------------------------------------------
;; Startup variables
;; -----------------------------------------------------------------------
(load-library "facuman-startup.el")


;; -----------------------------------------------------------------------
;; Modules loaded at startup (and their configuration)
;; -----------------------------------------------------------------------

;; ------------------------------------------------------------- [ themes ]
(load-library "facuman-themes.el")


;; ------------------------------------------------------------- [ icicles ]
;;(require 'icicles)


;; ------------------------------------------------------------- [ yasnippet ]
(load-library "facuman-yasnippet.el")


;; ------------------------------------------------------------- [ ido-mode ]
(load-library "facuman-ido.el")


;; ------------------------------------------------------------- [ cua ]
(load-library "facuman-cua.el")


;; ------------------------------------------------------------- [ dired ]
(load-library "facuman-dired.el")


;; ------------------------------------------------------------- [ ediff ]
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; ------------------------------------------------------------- [ anything ]
;;(load-library "facuman-anything.el")

;; ------------------------------------------------------------- [ regex ]
;;(load-library "facuman-regex.el")

;; ------------------------------------------------------------- [ supercollider ]


;; ------------------------------------------------------------- [ flymake ]
(load-library "facuman-flymake.el")


;; ------------------------------------------------------------- [ diminish ]
(load-library "facuman-diminish.el")


;; ------------------------------------------------------------- [ pager ]
;;; Excellent package for better scrolling in emacs
;;; should be default package. But now it can be downloaded
;;; from: http://user.it.uu.se/~mic/pager.el
;;(require 'pager)
;;(global-set-key "\C-v"     'pager-page-down)
;;(global-set-key [next]     'pager-page-down)
;;(global-set-key "\ev"      'pager-page-up)
;;(global-set-key [prior]    'pager-page-up)
;;(global-set-key '[M-up]    'pager-row-up)
;;(global-set-key '[M-kp-8]  'pager-row-up)
;;(global-set-key '[M-down]  'pager-row-down)
;;(global-set-key '[M-kp-2]  'pager-row-down)


;; ------------------------------------------------------------- [ cperl ]
(load-library "facuman-cperl.el")


;; ------------------------------------------------------------- [ python ]
(load-library "facuman-python.el")


;; ------------------------------------------------------------- [ ibuffer ]
(load-library "facuman-ibuffer.el")


;; ------------------------------------------------------------- [ cperl ]
(load-library "facuman-cperl.el")


;; ------------------------------------------------------------- [ tidy ]
(load-library "facuman-tidy.el")


;; ------------------------------------------------------------ [ haskell ]
(load-library "facuman-haskell.el")


;; ------------------------------------------------------------- [ cedet ]
(load-library "facuman-cedet.el")


;; ------------------------------------------------------------- [ ecb ]
(load-library "facuman-ecb.el")


;; ------------------------------------------------------------- [ ede ]
(require 'ede)
;;(setq global-ede-mode t)
(global-ede-mode 1)

;; ------------------------------------------------------------- [ eshell ]
(load-library "facuman-eshell.el")


;; ------------------------------------------------------------- [ tempo ]
;;(defun tempo-space ()
;;  (interactive "*")
  ;; (or (tempo-expand-if-complete)
  ;;     (insert " ")))


;; ------------------------------------------------------------- [ saveplace ]
;; instead of save desktop, rather save last editing place in files,
;; as well as minibuffer:
(require 'saveplace)
(setq-default save-place t)
(savehist-mode t)

;; ------------------------------------------------------------- [ desktop ]
;; let's try the desktop feature
;; (desktop-load-default)
;; (desktop-read)


;; ------------------------------------------------------------- [ autocomplete ]
(load-library "facuman-autocomplete.el")


;; ------------------------------------------------------------- [ magit ]
(load-library "facuman-magit.el")


;; ------------------------------------------------------------- [ elisp ]
(load-library "facuman-lisp.el")


;; ------------------------------------------------------------- [ text ]
(load-library "facuman-text.el")


;; ------------------------------------------------------------- [ html]
(load-library "facuman-html.el")


;; ------------------------------------------------------------- [ functions ]
(load-library "facuman-functions.el")


;; ------------------------------------------------------------- [ elpa ]
(load-library "facuman-elpa.el")


;; ------------------------------------------------------------- [ org ]
(load-library "facuman-org.el")


;; ------------------------------------------------------------- [ javascript.el ]
(load-library "facuman-javascript.el")


;; ------------------------------------------------------------- [ shell ]
(eval-after-load "shell"
  '(progn
     (ansi-color-for-comint-mode-on)))

