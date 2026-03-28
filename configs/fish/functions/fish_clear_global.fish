function fish_clear_global
  for var in (set -U | cut -d ' ' -f 1)
    set -e $var
  end
end
