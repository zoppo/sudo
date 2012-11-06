if ! is-callable sudo; then
  function sudo {
    print -n "root's "
    su -c "${(j| |)${(q)@}}"
  }
fi

zdefault -a ':zoppo:plugin:aliases' environments envs \
  'arch' 'utils'

for env ("$envs[@]")
  source-relative "dispatchers/$env" || warn "dispatchers: $env: environment not found"

unset envs env

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
