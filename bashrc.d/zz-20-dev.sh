# export PYKERN_PKDEBUG_OUTPUT=/dev/tty
# export PYKERN_PKDEBUG_REDIRECT_LOGGING=1
export PYKERN_PKDEBUG_OUTPUT=
export PYKERN_PKDEBUG_REDIRECT_LOGGING=
export PYKERN_PKDEBUG_CONTROL=.*
export SIREPO_FEATURE_CONFIG_JOB_SUPERVISOR=1 # TODO(e-carlin): Remove

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
