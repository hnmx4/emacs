;;; edit-markdown.el ---                             -*- lexical-binding: t; -*-
;;; Commentary:
;;
;;; Code:
;;; markdown-mode
(require 'markdown-mode)
(setq auto-mode-alist
      (append '(("\\.md$" . markdown-mode)) auto-mode-alist))

(defun eww-open-file-other-window (file)
  (if (one-window-p)(split-window))
  (other-window 1)
  (eww-open-file file))

(defun markdown-render-eww ()
  (interactive)
  (message (buffer-file-name))
  (call-process "/usr/local/bin/grip" nil nil nil
                "--export" (buffer-file-name) "/tmp/grip.html")
  (eww-open-file-other-window "/tmp/grip.html"))

(define-key markdown-mode-map (kbd "\C-c c") 'markdown-render-eww)

(provide 'edit-markdown)
;;; edit-markdown.el ends here
