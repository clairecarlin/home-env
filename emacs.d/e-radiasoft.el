(require 'cl)

(global-set-key  (kbd "C-c ss") 'start-supervisor-server)
(defun start-supervisor-server ()
  (interactive)
  (flet ((shell-name (n) (concatenate 'string "*shell* " n))
         (create-shell (n) (progn
                             (generate-new-buffer n)
                             (shell n)
                             (set-buffer n))))
    (let (
          (server (shell-name "server"))
          (supervisor (shell-name "supervisor")))
      ;; TODO(e-carlin): there must be a better way to do this
        (create-shell supervisor)
        (create-shell server)
        (delete-other-windows)
        (split-window-below 10)
        (select-window (next-window))
        (set-window-buffer nil supervisor)
      )

      )
     )

  ;; (let ((shell-name (lambda (n) (concatenate 'string "*shell* " n))))
  ;;   (shell-name "4"))
  ;; (let ((shell-name (lambda (n) ())))

  ;;   (message (shell-name "foo"))
  ;;   )

;; (let ((config (current-window-configuration)))
;;   (unwind-protect
;;       (dolist (e (list "server" "supervisor" ))
;;         (progn
;;           (let ((n (concatenate 'string "*shell* " e)))
;;             (generate-new-buffer n)
;;             (shell n)
;;             (set-buffer n)
;;             )
;;           (delete-other-windows)
;;           ;; todo insert start supervisor & server
;;        ;; (insert "cd ~/src/radiasoft/sirepo && bash ~/src/radiasoft/sirepo/etc/run-supervisor.sh")
;;        ;; (insert "sleep 100")
;;        ;; (comint-send-input)
;;        ;; (insert "C-c C-c")
;;        ;; (comint-send-input)
;;        )
;;         )
;;     (split-window-below 10)
;;     ;; todo: this is lame
;;     (set-window-buffer nil "*shell* server")
;;     (window-configuration-to-register ?s)
;;     (switch-to-buffer-other-window "*shell* supervisor")
;;     )
;;   ;; TODO(e-carlin): set window config to config
;;   )

(provide 'e-radiasoft)
;;; e-radiasoft.el ends here
