#!/usr/bin/env nu

let gruvbox_material_dark = {
  separator: dark_gray
  leading_trailing_space_bg: light_red # not yet seen
  header: dark_gray
  empty: dark_gray
  bool: purple
  int: purple
  filesize: purple
  duration: purple
  date: purple
  range: yellow
  float: purple
  string: light_gray
  nothing: dark_gray
  binary: purple
  cell-path: light_red_reverse # not yet seen
  row_index: dark_gray
  record: light_gray
  list: light_gray
  block: light_gray
  hints: dark_gray
  search_result: { fg: black bg: yellow }
  shape_and: yellow
  shape_binary: purple
  shape_block: gray
  shape_bool: purple
  shape_closure: gray
  shape_custom: light_red_reverse # not yet seen
  shape_datetime: purple
  shape_directory: cyan
  shape_external: green
  shape_externalarg: yellow
  shape_external_resolved: green
  shape_filepath: cyan
  shape_flag: blue
  shape_float: purple
  shape_garbage: { fg: black bg: red }
  shape_glob_interpolation: purple
  shape_globpattern: purple
  shape_int: purple
  shape_internalcall: green
  shape_keyword: yellow
  shape_list: gray
  shape_literal: light_red_reverse # not yet seen
  shape_match_pattern: light_red_reverse # not yet seen
  shape_matching_brackets: { attr: r }
  shape_nothing: dark_gray
  shape_operator: yellow
  shape_or: yellow
  shape_pipe: gray
  shape_range: yellow
  shape_record: gray
  shape_redirection: gray
  shape_signature: blue
  shape_string: light_gray
  shape_string_interpolation: blue
  shape_table: gray
  shape_variable: red
  shape_vardecl: red
  shape_raw_string: light_gray
}

$env.config = {
  show_banner: false
  table: {
    mode: rounded
    index_mode: auto
    show_empty: false
    padding: { left: 0 right: 0 }
    trim: { methodology: wrapping truncating_suffix: "…" }
  }
  completions: { algorithm: prefix } # fuzzy is weird
  filesize: { metric: true }
  cursor_shape: { vi_insert: line vi_normal: block }
  color_config: $gruvbox_material_dark
  footer_mode: 32
  float_precision: 1
  edit_mode: vi
  use_kitty_protocol: true
  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: (prompt-indicator)
      type: {
        layout: columnar
        columns: 4
        col_padding: 1
      }
      style: {
        text: gray
        selected_text: light_gray
        description_text: dark_gray
        match_text: yellow
        selected_match_text: yellow
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: (prompt-indicator "purple")
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: gray
        selected_text: light_gray
        description_text: dark_gray
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: (prompt-indicator)
      type: {
        layout: description
        columns: 4
        col_padding: 1
        selection_rows: 2
        description_rows: 8
      }
      style: {
        text: gray
        selected_text: light_gray
        description_text: light_gray
      }
    }
  ]
}
