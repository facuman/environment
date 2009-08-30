;; --------------------------------------------------------- [ Autocomplete ]
(require 'auto-complete)
(global-auto-complete-mode t) ;; Set autocomplete by default

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
