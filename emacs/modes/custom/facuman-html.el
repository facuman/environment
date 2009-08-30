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
