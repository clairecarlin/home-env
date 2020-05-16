(global-set-key  (kbd "C-c ss") 'start-supervisor-server)
(defun start-supervisor-server ()
(interactive)
(let ((config (current-window-configuration)))
  (unwind-protect
      (dolist (e (list "server" "supervisor" ))
        (progn
          (let ((n (concatenate 'string "*shell* " e)))
            (generate-new-buffer n)
            (shell n)
            (set-buffer n)
            )
          (delete-other-windows)
          ;; todo insert start supervisor & server
       ;; (insert "cd ~/src/radiasoft/sirepo && bash ~/src/radiasoft/sirepo/etc/run-supervisor.sh")
       ;; (insert "sleep 100")
       ;; (comint-send-input)
       ;; (insert "C-c C-c")
       ;; (comint-send-input)
       )
        )
    (split-window-below 10)
    ;; todo: this is lame
    (set-window-buffer nil "*shell* server")
    (window-configuration-to-register ?s)
    (switch-to-buffer-other-window "*shell* supervisor")
  ))
)

(provide 'e-radiasoft)
;;; e-radiasoft.el ends here
