function __user_host
  set -l content
  if [ (id -u) = "0" ];
    echo -n (set_color --bold red)
  else
    echo -n (set_color --bold green)
  end
  echo -n $USER@(hostname|cut -d . -f 1) (set_color normal)
end

function __current_path
  echo -n (set_color --bold blue) (prompt_pwd) (set_color normal)
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function __git_status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '<'$git_branch "+"'>'
    else
      set git_info '<'$git_branch'>'
    end

    echo -n (set_color yellow) $git_info (set_color normal)
  end
end

function __ruby_version
  if type "rvm-prompt" > /dev/null 2>&1
    set ruby_version (rvm-prompt i v g)
  else if type "rbenv" > /dev/null 2>&1
    set ruby_version (rbenv version-name)
  else
    set ruby_version "system"
  end

  echo -n (set_color red) ‹$ruby_version› (set_color normal)
end

function fish_prompt
  echo -e ''
  echo -n (set_color blue)"ºo "(set_color normal)
  __user_host
  __current_path
  __ruby_version
  __git_status
  echo -e ''
  echo (set_color blue)"><(((º> "(set_color normal)
end

function fish_battery
  battery.info.update
  battery ● ◦
  if set -q BATTERY_IS_PLUGGED
    echo -n (set_color yellow)⌁(set_color normal)
  end
end

function fish_right_prompt
  set -l st $status

  if [ $st != 0 ];
    echo -n (set_color red) ↵ $st(set_color normal)" "
  end
  echo -n (set_color --bold blue)(date +"%T")(set_color normal)" "
  fish_battery
end
