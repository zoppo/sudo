if ! is-callable sudo; then
  function sudo {
    print -n "root's "
    su -c "${(j| |)${(q)@}}"
  }
fi

if zdefault -t ':zoppo:plugin:sudo' all 'no'; then
  for program (dispatchers/*(:t))
    source-relative "dispatchers/$program"
  unset program
else
  zdefault ':zoppo:plugin:sudo:environment' arch \
    'pacman' 'pacman-color' 'yaourt' 'packer' 'abs'

  zdefault ':zoppo:plugin:sudo:environment' utils \
    'mount' 'umount' 'shutdown' 'reboot' 'poweroff' 'halt' 'pm-suspend'

  zdefault -a ':zoppo:plugin:sudo' programs programs \
    'pacman' 'pacman-color'

  for program ("$programs[@]")
    source-relative "dispatchers/$program" || warn "sudo: $program: program not found"
  unset program programs

  zstyle -a ':zoppo:plugin:sudo' environments environments

  for environment ($environments[@]); do
    zstyle -a ':zoppo:plugin:sudo:environment' "$environment" programs

    for program ("$programs[@]")
      source-relative "dispatchers/$program" || warn "sudo: $program: program not found"
    unset program programs
  done
  unset environment environments
fi

# vim: ft=zsh sts=2 ts=2 sw=2 et fdm=marker fmr={{{,}}}
