(defun create-shell (name command)
  (let ((s (concat "*shell* " name)))
    (progn
      (shell (set-buffer (get-buffer-create s)))
      ;; TODO(e-carlin): this makes sure that the bashrc is sourced before
      ;; (comint-interrupt-subjob) which would kill it. Sleeping is lame
      ;; but meh, can't find a better option
      (sleep-for 1)
      (comint-interrupt-subjob)
      (erase-buffer)
      ;; TODO(e-carlin): the (erase-buffer) seems to delete the first char of
      ;; the insert so add " " and that will get deleted
      (insert (concat " " command))
      (comint-send-input)
      ;; TODO(e-carlin): I don't message here, I just want to return a string.
      ;; I don't know elisp, help!
      (message s))))

(defun supervisor-server-command (is-supervisor)
  (concat "cd ~/src/radiasoft/sirepo"
          " && "
          " bash etc/run-"
          (if is-supervisor "supervisor" "server")
          ".sh sbatch"))
(global-set-key (kbd "C-c sb")
                'start-supervisor-server)
(defun start-supervisor-server ()
  (interactive)
  (let ((config (current-window-configuration)))
    (let ((supervisor (create-shell "supervisor"
                                    (supervisor-server-command t))))
      (create-shell "server"
                    (supervisor-server-command nil))
      (delete-other-windows)
      (split-window-below 10)
      (select-window (next-window))
      (set-window-buffer nil supervisor))
    (window-configuration-to-register ?s)
    (set-window-configuration config)))

;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c ss")
                'sirepo-service-http)
(defun sirepo-service-http ()
  (interactive)
  (let ((config (current-window-configuration)))
    ;; TODO(e-carlin): new machine need to install flash commented out until then
    ;; (create-shell "server" "cd ~/src/radiasoft/sirepo &&  SIREPO_FEATURE_CONFIG_PROPRIETARY_SIM_TYPES=flash sirepo service http")
    (create-shell "server" "cd ~/src/radiasoft/sirepo &&  sirepo service http")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))


;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c se")
                'sirepo-email)
(defun sirepo-email ()
  (interactive)
  (let ((config (current-window-configuration)))
    (create-shell "server" "cd ~/src/radiasoft/sirepo && bash  etc/run-auth-email.sh")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))

;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c sj")
                'jupyterhub-test)
(defun jupyterhub-test ()
  (interactive)
  (let ((config (current-window-configuration)))
    (create-shell "jupyterhub" "cd ~/src/radiasoft/container-jupyterhub/container-conf && bash test.sh")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))
(provide 'e-radiasoft) ;;; e-radiasoft.el ends here
