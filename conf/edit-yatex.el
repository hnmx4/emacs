;;; edit-yatex.el ---                                  -*- lexical-binding: t; -*-
;;; Commentary:
;;
;;; Code:
;; yatex-mode
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(modify-coding-system-alist 'file "\\.tex\\'" 'utf-8)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))
(setq YaTeX-kanji-code nil)
(setq tex-command "platex")
(setq dvi2-command "xdvi")
(setq bibtex-command "pbibtex")
(setq dviprint-command-format "dvipdfmx")
(setq tex-command "~/Library/TeXShop/bin/platex2pdf-utf8")
; (setq YaTeX-kanji-code 4)
(add-hook 'yatex-mode-hook
          '(lambda ()
             (flyspell-mode)
             (setq auto-fill-function nill)
             (bind-key "C-cg" 'goto-line)
             (auto-fill-mode -1)))

; バッファ全体の句読点と読点をコンマとピリオドに変換
(defun replace-commaperiod-buffer ()
  (interactive "r")
  (save-excursion
    (replace-string "、" "，" nil (point-min) (point-max))
    (replace-string "。" "．" nil (point-min) (point-max))))

; 選択範囲内の全角英数字を半角英数字に変換
(defun hankaku-eisuu-region (start end)
  (interactive "r")
  (while (string-match
          "[０-９Ａ-Ｚａ-ｚ]+"
          (buffer-substring start end))
    (save-excursion
      (japanese-hankaku-region
       (+ start (match-beginning 0))
       (+ start (match-end 0))
       ))))

; バッファ全体の全角英数字を半角英数字に変換
(defun hankaku-eisuu-buffer ()
  (interactive)
  (hankaku-eisuu-region (point-min) (point-max)))

; YaTeXモードの時にのみ動作させる用に条件分岐
(defun replace-commaperiod-before-save-if-needed ()
  (when (memq major-mode
              '(yatex-mode))
    (replace-commaperiod-buffer)(hankaku-eisuu-buffer)))

; 保存前フックに追加
(add-hook 'before-save-hook 'replace-commaperiod-before-save-if-needed)

(provide 'edit-yatex)
;;; edit-yatex.el ends here
