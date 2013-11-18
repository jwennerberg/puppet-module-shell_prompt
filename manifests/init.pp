# == Class: shell_prompt
#
# Module to manage shell_prompt
#
class shell_prompt (
  $profile_d_script_name  = 'prompt',
  $profile_d_script_mode  = '0644',
  $profile_d_script_owner = 'root',
  $profile_d_script_group = 'root',
  $bash_user              = '\u',
  $bash_hostname          = '\h',
  $bash_cwd               = '\W',
  $tcsh_user              = '%n',
  $tcsh_hostname          = '%m',
  $tcsh_cwd               = '%c',
  $bash_content           = undef,
  $tcsh_content           = undef,
) {

  case $::kernel {
    'Linux': { }
    default: {
      fail("shell_prompt is supported on kernel Linux. Your kernel identified as ${::kernel}")
    }
  }

  if $bash_content {
    $bash_content_real = "export PS1=\"${bash_content}\"\n"
  } else {
    $bash_content_real = "export PS1=\"[${bash_user}@${bash_hostname} ${bash_cwd}]\\\\$ \"\n"
  }

  if $tcsh_content {
    $tcsh_content_real = "set prompt=\"${tcsh_content}\"\n"
  } else {
    $tcsh_content_real = "set prompt=\"[${tcsh_user}@${tcsh_hostname} ${tcsh_cwd}]%# \"\n"
  }

  $bash_profile_d_script_path = "/etc/profile.d/${profile_d_script_name}.sh"
  $csh_profile_d_script_path = "/etc/profile.d/${profile_d_script_name}.csh"

  file { 'prompt_profile_d_bash':
    ensure  => file,
    path    => $bash_profile_d_script_path,
    mode    => $profile_d_script_mode,
    owner   => $profile_d_script_owner,
    group   => $profile_d_script_group,
    content => $bash_content_real,
  }

  file { 'prompt_profile_d_csh':
    ensure   => file,
    path     => $csh_profile_d_script_path,
    mode     => $profile_d_script_mode,
    owner    => $profile_d_script_owner,
    group    => $profile_d_script_group,
    content  => $tcsh_content_real,
    #content => template('shell_prompt/prompt.csh.erb'),
  }
}
