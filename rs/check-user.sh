echo user_role_t
sqlite3 ~/src/radiasoft/sirepo/run/auth.db "select * from user_role_t;"
echo jupyterhub_user_t
sqlite3 ~/src/radiasoft/sirepo/run/auth.db "select * from jupyterhub_user_t;"
echo auth_email_user_t
sqlite3 ~/src/radiasoft/sirepo/run/auth.db "select * from  auth_email_user_t;"
echo user_registration_t
sqlite3 ~/src/radiasoft/sirepo/run/auth.db "select * from  user_registration_t;"

ls -al ~/src/radiasoft/sirepo/run/user/
ls -al ~/src/radiasoft/sirepo/run/jupyterhub/user/
echo 'SIREPO_FEATURE_CONFIG_DEFAULT_PROPRIETARY_SIM_TYPES=jupyterhublogin SIREPO_AUTH_METHODS=email  sirepo admin delete_user'
