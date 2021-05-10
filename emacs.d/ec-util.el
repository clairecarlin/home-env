;; Utility functions


(global-set-key (kbd "C-c gp")
                'ec-util-git-parent-branch)
(defun ec-util-git-parent-branch ()
  "Inserts g_parent (name of parent branch) at current cursor point"
  (interactive)
  (insert (shell-command-to-string "g_parent")))

(provide 'ec-util)
;;; ec-util.el ends here
