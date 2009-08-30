;; ------------------------------------------------------ [ CPerl Startup ]
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
  (setq indent-tabs-mode nil)  ; Autoconvert tabs to spaces
  ;(setq perl-indent-level 4)
  ;(setq perl-tab-always-indent nil) ; Indent if at left margin, else tab
  ;(setq perl-continued-statement-offset 2)
  ;(setq perl-continued-brace-offset -2)

  (linum-mode)

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
