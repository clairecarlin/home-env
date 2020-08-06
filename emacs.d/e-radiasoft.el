(require 'cl)

(global-set-key (kbd "C-c sb")
                'start-supervisor-server)
(defun start-supervisor-server ()
  (interactive)
  (let ((config (current-window-configuration)))
    (unwind-protect
        (cl-flet ((create-shell (n)
                                (let ((s (concat "*shell* " n)))
                                  (progn
                                    (shell (set-buffer (get-buffer-create s)))
                                    (comint-interrupt-subjob)
                                    (erase-buffer)
                                    (insert (concat "cd ~/src/radiasoft/sirepo" " && "
                                                    " bash etc/run-" n ".sh sbatch"))
                                    (comint-send-input)
                                    ;; TODO(e-carlin): I don't message here, I just want to return a string
                                    (message s)))))
          (let ((supervisor (create-shell "supervisor")))
            (create-shell "server")
            (delete-other-windows)
            (split-window-below 10)
            (select-window (next-window))
            (set-window-buffer nil supervisor)))
      (set-window-configuration config))))


;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c ss")
                'sirepo-service-http)
(defun sirepo-service-http ()
  (interactive)
  (let ((config (current-window-configuration)))
    (progn
      (shell (set-buffer (get-buffer-create "* shell* server")))
      (comint-interrupt-subjob)
      (erase-buffer)
      (insert (concat "cd ~/src/radiasoft/sirepo &&" " SIREPO_FEATURE_CONFIG_PROPRIETARY_SIM_TYPES=flash"
                      " sirepo service http"))
      (comint-send-input))
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))


;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c se")
                'sirepo-email)
(defun sirepo-email ()
  (interactive)
  (let ((config (current-window-configuration)))
    (progn
      (shell (set-buffer (get-buffer-create "* shell* server")))
      (comint-interrupt-subjob)
      (erase-buffer)
      (insert "cd ~/src/radiasoft/sirepo && bash  etc/run-auth-email.sh")
    (comint-send-input))
  (delete-other-windows)
  (window-configuration-to-register ?s)
  (set-window-configuration config)))
(provide 'e-radiasoft) ;;; e-radiasoft.el ends here
