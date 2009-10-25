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
      default-tab-width 4
      default-fill-column 79
      frame-title-format (concat user-login-name "@" system-name))

;; set font
;; (set-default-font "Bitstream Vera Sans Mono-10")
(set-default-font "Bitstream Vera Sans Mono-10")
;;(set-fontset-font (frame-parameter nil 'font)
;;	'han '("cwTeXHeiBold" . "unicode-bmp"))

;; disable toolbars
(menu-bar-mode nil)
(tool-bar-mode nil)
;; (scroll-bar-mode nil)

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
;;(if (eq window-system 'x)
;;    (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))

(global-set-key [f13] 'execute-extended-command)

;; use ergonomic key shortcuts
(load-file "~/environment/emacs/modes/ergonomic_keybinding_qwerty_4.3.13.el")

;; bind goto line to M-x g
;;(global-set-key "\M-g" 'goto-line)

;; open keyboard shortcut image with F8 key
(global-set-key (kbd "<f8>")
  (lambda ()
    (interactive)
    (find-file "~/environment/emacs/modes/ergonomic_emacs_layout_qwerty.png")))

;; ------------------------------------------------------------- [ backup-dir ]
;; Changes the location where backup files are placed. Instead of
;; being spread out all over the filesystem, they're now placed in one
;; location.
;;(if (file-accessible-directory-p (expand-file-name "~/.Trash"))
;;    (add-to-list 'backup-directory-alist
;;                 (cons "." (expand-file-name "~/.Trash/emacs-backups/"))))

;;(if (file-accessible-directory-p (expand-file-name "~/.Trash"))
;;    (add-to-list 'auto-save-file-name-transforms
;;                 (cons "." (expand-file-name "~/.Trash/emacs-autosaves/"))))

(setq temporary-backup-directory "~/.Trash/emacs-backups")
(setq backup-directory-alist
	`((".*" . ,temporary-backup-directory)))

(setq temporary-autosave-directory "~/.Trash/emacs-autosaves")
(setq auto-save-file-name-transforms
        `((".*" ,temporary-autosave-directory t)))

;; ------------------------------------------------------------- [ browse-kill-ring ]
;; Select something that you put in the kill ring ages ago.
(autoload 'browse-kill-ring "browse-kill-ring" "Browse the kill ring." t)
(global-set-key (kbd "C-c k") 'browse-kill-ring)
(eval-after-load "browse-kill-ring"
  '(progn
     (setq browse-kill-ring-quit-action 'save-and-restore)))
