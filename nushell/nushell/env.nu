#!/usr/bin/env nu

def left-prompt [] {
  let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
    null => $env.PWD
    "" => "~"
    $relative_pwd => ([~ $relative_pwd] | path join)
  }
  $"(ansi cyan)($dir)(ansi reset)\n\n"
}

def right-prompt [] {
  mut duration = ($env.CMD_DURATION_MS | into int) / 1000 | into int
  $duration = if ($duration >= 5) {
    [
      (ansi purple)
      ($duration | into duration --unit sec)
      (ansi reset)
    ] | str join
  } else { "" }
  let exit_code = if ($env.LAST_EXIT_CODE != 0) {
    $" (ansi black)($env.LAST_EXIT_CODE)(ansi reset)"
  } else { "" }
  $"($duration)($exit_code)"
}

$env.PROMPT_COMMAND = {|| left-prompt }
$env.PROMPT_COMMAND_RIGHT = {|| right-prompt }

$env.TRANSIENT_PROMPT_COMMAND = ""
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""

def prompt-indicator [color: string = "blue"] {
  let color = if ($env.LAST_EXIT_CODE != 0) { ansi red } else { ansi $color }
  $"($color)●• (ansi reset)"
}

$env.PROMPT_INDICATOR_VI_INSERT = {|| prompt-indicator }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| prompt-indicator "white" }

$env.PROMPT_MULTILINE_INDICATOR = {|| "   " }

