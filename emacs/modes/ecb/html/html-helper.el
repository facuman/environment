;;; html-helper.el --- 

;; Copyright (C) 2001 Jesper Nordenberg

;; Author: Jesper Nordenberg <mayhem@home.se>

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 2, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.

;; You should have received a copy of the GNU General Public License along with
;; GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:

;; Functions for generating HTML pages.

;; $Id: html-helper.el,v 1.9 2004/02/24 12:50:56 berndl Exp $

;;; Code:
(defconst h-br "<br>\n")
(defconst h-hr "<hr>")

(defvar h-body-bgcolor)
(setq h-body-bgcolor "white")

(defvar h-link-fgcolor)
(defvar h-vlink-fgcolor)
(defvar h-alink-fgcolor)
(setq h-link-fgcolor "#0000ff")
(setq h-vlink-fgcolor "#008000")
(setq h-alink-fgcolor "#0080ff")

(defvar h-section-title-bgcolor)
(defvar h-section-title-fgcolor)
(defvar h-section-text-bgcolor)
(defvar h-section-text-fgcolor)
(setq h-section-title-bgcolor "#404080")
(setq h-section-title-fgcolor "#ffffff")
(setq h-section-text-bgcolor "#8080a0")
(setq h-section-text-fgcolor "#000000")

(defun h-line (&optional width-percent align)
  (concat "<hr" (h-get-attrs
                 (delete nil
                         (list (if (numberp width-percent)
                                   (cons 'width
                                         (concat (number-to-string width-percent)
                                                 "%")))
                               (if align
                                   (cons 'align
                                         (if (stringp align)
                                             align
                                           (symbol-name align)))))))
          ">"))

(defun h-date()
  (format-time-string "%Y-%m-%d"))

(defun h-element(name items &optional newline)
  (concat "<" name (h-get-attrs items) ">" (h-list-to-str items) "</" name ">" (if newline "\n" "")))

(defun h-list-to-str(items)
  (if (listp items)
      (if (symbolp (car items))
	  ""
	(mapconcat
	 '(lambda (item)
	    (h-list-to-str item))
	  items ""))
    items))

(defun h-filter(items prefix &optional suffix)
  (mapcar
   (lambda (item)
     (concat (if prefix prefix "") (h-list-to-str item) (if suffix suffix "")))
   items))

(defun h-get-attrs(items &optional defaults)
  (let ((attr-str "")
	(l items)
	al)
    (while l
      (when (and (listp (car l)) (symbolp (caar l)))
	(setq al (cons (car l) al))
	(setq attr-str (concat attr-str " " (symbol-name (caar l))
			       (if (cdar l)
				   (concat "='" (cdar l) "'")
				 ""))))
      (setq l (cdr l)))
    (concat
     attr-str
     (mapconcat
      '(lambda (item)
	 (if (not (assoc (car item) al))
	     (concat " " (symbol-name (car item)) (if (cdr item)
						      (concat "='" (cdr item) "'")
						    ""))
	   ""))
      defaults ""))))

(defun h-doc(filename title &rest items)
  (set-buffer (find-file-noselect filename))
  (setq buffer-read-only nil)
  (erase-buffer)
  (insert (concat "<!-- This file was automatically generated by Emacs "
		  emacs-version " at " (current-time-string)
		  ", do not edit! -->\n<html>\n<head>\n<STYLE TYPE=\"text/css\">\nA:hover {background-color: #c0c0c0}\nA:link, A:visited, A:active { text-decoration: none }\n OL,UL,P,BODY,TD,TR,TH,FORM {font-family : verdana,arial,helvetica,sans-serif; } \n</STYLE>\n<title>" title ;;
		  "</title>\n</head>\n\n<body"
		  (h-get-attrs items (list (cons 'bgcolor h-body-bgcolor)
					   (cons 'link h-link-fgcolor)
					   (cons 'vlink h-vlink-fgcolor)
					   (cons 'alink h-alink-fgcolor)))
		  ">\n" (h-list-to-str items) "\n</body>\n</html>\n"))
  (setq buffer-read-only t)
  (save-buffer))

(defun h-center(&rest items)
  (h-element "center" items))

(defun h-h1(&rest items)
  (concat "\n" (h-element "h1" items t)))

(defun h-h2(&rest items)
  (concat "\n" (h-element "h2" items t)))

(defun h-h3(&rest items)
  (concat "\n" (h-element "h3" items t)))

(defun h-h4(&rest items)
  (concat "\n" (h-element "h4" items t)))

(defun h-b(&rest items)
  (h-element "b" items))

(defun h-p(&rest items)
  (h-element "p" items t))

(defun h-i(&rest items)
  (h-element "i" items t))

(defun h-fsize(size &rest items)
  (h-element "font" (cons (cons 'size size) items)))

(defun h-fcolor(color &rest items)
  (h-element "font" (cons (cons 'color color) items)))

(defun h-list(&rest items)
  (h-element "ul" (h-filter (if (listp (car items))
				(car items)
			      items)
			    "<li>" "\n") t))

(defun h-numbered-list(&rest items)
  (h-element "ol" (h-filter (if (listp (car items))
				(car items)
			      items)
			    "<li>" "\n") t))

(defun h-bullet-list(&rest items)
  (h-element "ul" (h-filter (if (listp (car items))
				(car items)
			      items)
			    "<li>" "\n") t))

(defun h-email(email &rest items)
  (concat
   "<a href='mailto:" email "'>"
   (if items
       (h-list-to-str items)
     email)
   "</a>"))

(defun h-link(url &rest items)
  (concat
   "<a href='" url "'" (h-get-attrs items) ">"
   (if items
       (h-list-to-str items)
     url)
   "</a>"))

(defun h-tag(name &rest items)
  (concat
   "<a name='" name "'>"
   (if items
       (h-list-to-str items)
     "")
   "</a>"))

(defun h-img(url &rest items)
  (concat "<img src='" url "' " (h-list-to-str items) ">"))

(defun h-columns(&rest columns)
  (h-element "table" (h-filter columns "<td valign='top'>") t))

(defun h-table(&rest items)
  (h-element "table" (cons "\n" items) t))

(defun h-td(&rest items)
  (h-element "td" items))

(defun h-tr(&rest items)
  (h-element "tr" items t))

(defun h-section(title &rest items)
  (concat
   (h-table '(width . "100%")
	    '(cellspacing . "0")
	    '(cellpadding . "2")
	    (h-tr (cons 'bgcolor h-section-title-bgcolor)
		  (h-td (h-fcolor h-section-title-fgcolor (h-b title))))
	    (h-tr (cons 'bgcolor h-section-text-bgcolor) (h-td (h-fcolor h-section-text-fgcolor items))))
   h-br))

(defun h-sub-section(title &rest items)
  (concat
   (h-table '(width . "100%")
	    '(cellspacing . "0")
	    '(cellpadding . "2")
	    (h-tr (h-td (h-b title))
	    (h-tr (h-td items))))
   h-br))

(defun h-bullet-link-list(bullet items &optional target)
  (h-table
   (mapconcat
    (lambda (item)
      (h-tr '(valign . "top")
            (h-td '(nowrap) (h-img bullet) " "
                  (h-link (car item)
			  (h-b (if (cdr item) (cadr item) (car item)))
			  (cons 'target target)))
	    (h-td (if (and (cdr item) (cddr item)) (caddr item) ""))))
    items "")))



(provide 'html-helper)
