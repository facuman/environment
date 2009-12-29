;; ------------------------------------------------------------- [ org ]

(require 'org-install)
;;(load-library "facuman-org.el")
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cb" 'org-iswitchb)

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-font-lock-mode 1)

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


(defun my-org-startup ()
  "Org mode default settings."
  )

(add-hook 'org-mode-hook 'my-org-startup)
