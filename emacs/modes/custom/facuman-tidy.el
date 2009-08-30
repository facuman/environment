;; ---------------------------------------------------- [ Tidy startup ]
;; Tidy mode settings
(autoload 'tidy-buffer "tidy" "Run Tidy HTML parser on current buffer" t)
(autoload 'tidy-parse-config-file "tidy" "Parse the `tidy-config-file'" t)
(autoload 'tidy-save-settings "tidy" "Save settings to `tidy-config-file'" t)
(autoload 'tidy-build-menu  "tidy" "Install an options menu for HTML Tidy." t)

(defun my-tidy-startup ()
  "Tidy temp."
  '(tidy-temp-directory "~/.tidy/temp"))

(add-hook 'tidy-mode-hook 'my-tidy-startup)
