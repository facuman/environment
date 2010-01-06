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

;; (add-to-list 'iimage-mode-image-regex-alist
;;              (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex
;;                            "\\)\\]")  1))

;; (defun org-toggle-iimage-in-org ()
;;   "display images in your org file"
;;   (interactive)
;;   (if (face-underline-p 'org-link)
;;       (set-face-underline-p 'org-link nil)
;;     (set-face-underline-p 'org-link t))
;;   (iimage-mode))


(defun my-org-startup ()
  "Org mode default settings."
  (local-set-key "\M-n" 'outline-next-visible-heading)
  (local-set-key "\M-p" 'outline-previous-visible-heading)
  ;; table
  (local-set-key "\M-\C-w" 'org-table-copy-region)
  (local-set-key "\M-\C-y" 'org-table-paste-rectangle)
  (local-set-key "\M-\C-l" 'org-table-sort-lines)
  ;; display images
;;  (local-set-key "\M-I" 'org-toggle-iimage-in-org)
  ;; fix tab
  (local-set-key "\C-y" 'yank)
  ;; yasnippet (allow yasnippet to do it's thing in org files)
  ;; (make-variable-buffer-local 'yas/trigger-key)
  ;; (setq yas/trigger-key [tab])
  ;; (define-key yas/keymap [tab] 'yas/next-field-group)
  )

(add-hook 'org-mode-hook 'my-org-startup)
