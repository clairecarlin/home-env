;; TODO(e-carlin): move to ec-base
;; TODO(e-carlin): default name to server
(defun ec-create-shell (name command)
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

;; TODO(e-carlin): move to ec-base
(global-set-key (kbd "C-c sc")
                'ec-erase-shell-buffers)
(defun ec-erase-shell-buffers ()
  (interactive)
  (mapc (lambda (buffer)
          (if (string-match-p (regexp-quote "*shell*")
                              (buffer-name buffer))
              (with-current-buffer buffer
                (erase-buffer))))
        (buffer-list)))

(defun ec-supervisor-server-command (is-supervisor)
  (concat "cd ~/src/radiasoft/sirepo"
          " && "
          " bash etc/run-"
          (if is-supervisor "supervisor" "server")
          ".sh sbatch"))
(global-set-key (kbd "C-c sb")
                'ec-start-supervisor-server)
(defun ec-start-supervisor-server ()
  (interactive)
  (let ((config (current-window-configuration)))
    (let ((supervisor (ec-create-shell "supervisor"
                                    (ec-supervisor-server-command t))))
      (ec-create-shell "server"
                    (ec-supervisor-server-command nil))
      (delete-other-windows)
      (split-window-below 10)
      (select-window (next-window))
      (set-window-buffer nil supervisor))
    (window-configuration-to-register ?s)
    (set-window-configuration config)))

;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c ss")
                'ec-sirepo-service-http)
(defun ec-sirepo-service-http ()
  (interactive)
  (let ((config (current-window-configuration)))
    (ec-create-shell "server" "cd ~/src/radiasoft/sirepo &&  SIREPO_FEATURE_CONFIG_PROPRIETARY_SIM_TYPES=flash SIREPO_MPI_CORES=4 sirepo service http")
    ;; (ec-create-shell "server" "cd ~/src/radiasoft/sirepo &&  SIREPO_MPI_CORES=4 sirepo service http")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))


;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c se")
                'ec-sirepo-email)
(defun ec-sirepo-email ()
  (interactive)
  (let ((config (current-window-configuration)))
    ;; (ec-create-shell "server" "cd ~/src/radiasoft/sirepo && SIREPO_FEATURE_CONFIG_DEFAULT_PROPRIETARY_SIM_TYPES=jupyterhublogin SIREPO_FEATURE_CONFIG_PROPRIETARY_SIM_TYPES=flash bash  etc/run-auth-email.sh")
    (ec-create-shell "server" "cd ~/src/radiasoft/sirepo && SIREPO_FEATURE_CONFIG_DEFAULT_PROPRIETARY_SIM_TYPES=jupyterhublogin bash  etc/run-auth-email.sh")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))

;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c sj")
                'ec-service-jupyterhub)
(defun ec-service-jupyterhub ()
  (interactive)
  (let ((config (current-window-configuration)))
    (ec-create-shell "server" "cd ~/src/radiasoft/sirepo && SIREPO_FEATURE_CONFIG_DEFAULT_PROPRIETARY_SIM_TYPES=jupyterhublogin SIREPO_FEATURE_CONFIG_PROPRIETARY_SIM_TYPES=flash bash etc/run-jupyterhub.sh")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))


;; TODO(e-carlin): lots of repeated code
(global-set-key (kbd "C-c cj")
                'ec-container-jupyterhub)
(defun ec-container-jupyterhub ()
  (interactive)
  (let ((config (current-window-configuration)))
    (ec-create-shell "server" "cd ~/src/radiasoft/container-jupyterhub/container-conf && bash test.sh")
    (delete-other-windows)
    (window-configuration-to-register ?s)
    (set-window-configuration config)))

(global-set-key (kbd "C-c nt")
                'ec-todos)
(defun ec-todos ()
  (interactive)
  (find-file "/vagrant/notes/ec-note-TODO")
  )

(global-set-key (kbd "C-c nn")
                'ec-new-note)
(defun ec-new-note ()
  (interactive)
  (find-file (concat "/vagrant/notes/ec-note-" (format-time-string "%s")))
  )
()

(provide 'ec-radiasoft)
;;; ec-radiasoft.el ends here
