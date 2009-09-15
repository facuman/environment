;; ------------------------------------------------------------- [ org ]

(require 'org-install)
;;(load-library "facuman-org.el")
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cb" 'org-iswitchb)


(global-font-lock-mode 1)

(defun my-auto-complete-startup ()
  "Org mode default settings."
  )

(add-hook 'org-mode-hook 'my-org-startup)
