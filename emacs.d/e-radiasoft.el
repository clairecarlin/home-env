(require 'cl)

(global-set-key  (kbd "C-c ss") 'start-supervisor-server)
(defun start-supervisor-server ()
  (interactive)
  (let ((config (current-window-configuration)))
    (unwind-protect

    (cl-flet ((shell-name (n)
                       (concatenate 'string "*shell* " n))
           (create-shell (n) ;; TODO(e-carlin): if server started then restart
                         (progn (generate-new-buffer n)
                                ;; TODO(e-carlin): cd and start
                                ;; (insert "sleep 100")
                                ;; (comint-send-input)
                                (shell n)
                                (set-buffer n))))
      (let ((server (shell-name "server"))
            (supervisor (shell-name "supervisor"))) ;; TODO(e-carlin): there must be a better way to do this (create-shell supervisor)
        (create-shell supervisor)
        (create-shell server)
        (delete-other-windows)
        (split-window-below 10)
        (select-window (next-window))
        (set-window-buffer nil supervisor)))
    (window-configuration-to-register ?s)
    ;; (set-window-configuration config)
    )
  )
)
(provide 'e-radiasoft) ;;; e-radiasoft.el ends here
