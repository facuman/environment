;; -----------------------------------------------------------------------
;; Utility Methods
;; -----------------------------------------------------------------------
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


;; -----------------------------------------------------------------------
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


;; ----------------------------------------- [ SVN Log Edit Mode Startup ]
(defun my-svn-load-edit-mode-startup ()
  (interactive)
  ;;(filladapt-mode t)
  (show-paren-mode t))
  ;;(flyspell-mode t))

(add-hook 'svn-log-edit-mode-hook 'my-svn-load-edit-mode-startup)
