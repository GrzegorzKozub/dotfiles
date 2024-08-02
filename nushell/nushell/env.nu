def create_left_prompt [] {
  let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
    null => $env.PWD
    '' => '~'
    $relative_pwd => ([~ $relative_pwd] | path join)
  }
  $"(ansi cyan)($dir)(ansi reset)"
}

$env.PROMPT_COMMAND = {|| create_left_prompt }

def prompt_indicator [color] {
  let color = if ($env.LAST_EXIT_CODE > 0) { ansi red } else { ansi $color }
  $"($color)(char newline)●• (ansi reset)"
}

$env.PROMPT_INDICATOR_VI_INSERT = {|| prompt_indicator "blue" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt_indicator "white" }

$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi blue) • (ansi reset)" }
