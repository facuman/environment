; Emacs side of the testing protocol.

(push ".." load-path)
(load "pymacs.el" nil t)

(defun run-one-request ()
  (let ((buffer (get-buffer-create "*Tests*")))
    (with-current-buffer buffer
      (buffer-disable-undo)
      (set-buffer-multibyte t)
      (set-buffer-file-coding-system 'utf-8-unix)
      (insert-file-contents "_request")
      (let ((lisp-code (read (current-buffer)))
            (standard-output (current-buffer)))
        (delete-region (point-min) (point-max))
        (eval lisp-code))
      (write-region nil nil "_reply" nil 0))))

(defun run-all-requests ()
  (let ((buffer (get-buffer-create "*Tests*")))
    (with-current-buffer buffer
      (buffer-disable-undo)
      (set-buffer-multibyte t)
      (set-buffer-file-coding-system 'utf-8-unix)
      (while t
        (while (file-exists-p "_reply")
          (sleep-for .01))
        (insert-file-contents "_request")
        (let ((lisp-code (read (current-buffer)))
              (standard-output (current-buffer)))
          (delete-region (point-min) (point-max))
          (eval lisp-code))
        (write-region nil nil "_reply" nil 0)
        (delete-region (point-min) (point-max))
        (delete-file "_request")))))
