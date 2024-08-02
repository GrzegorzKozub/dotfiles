let gruvbox_material_dark = {
  separator: dark_gray
  leading_trailing_space_bg: red_reverse # unseen
  header: dark_gray
  empty: red_reverse # unseen
  bool: purple
  int: purple
  filesize: purple
  duration: purple
  date: purple
  range: yellow
  float: purple
  string: green
  nothing: dark_gray
  binary: yellow
  cell-path: red_reverse # unseen
  row_index: dark_gray
  record: light_gray
  list: light_gray
  block: light_gray
  hints: dark_gray
  search_result: { bg: yellow }
  shape_and: yellow
  shape_binary: purple
  shape_block: gray
  shape_bool: purple
  shape_closure: yellow
  shape_custom: red_reverse # unseen
  shape_datetime: purple
  shape_directory: cyan
  shape_external: green
  shape_externalarg: yellow
  shape_external_resolved: green
  shape_filepath: cyan
  shape_flag: yellow
  shape_float: purple
  shape_garbage: { bg: red }
  shape_glob_interpolation: red_reverse # unseen
  shape_globpattern: red_reverse # unseen
  shape_int: purple
  shape_internalcall: blue
  shape_keyword: red
  shape_list: gray
  shape_literal: red_reverse # unseen
  shape_match_pattern: yellow
  shape_matching_brackets: { attr: r }
  shape_nothing: dark_gray
  shape_operator: yellow
  shape_or: yellow
  shape_pipe: dark_gray
  shape_range: yellow
  shape_record: gray
  shape_redirection: dark_gray
  shape_signature: red_reverse # unseen
  shape_string: green
  shape_string_interpolation: cyan
  shape_table: gray
  shape_variable: red
  shape_vardecl: red
  shape_raw_string: green
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
      marker: (prompt_indicator "blue")
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
      marker: (prompt_indicator "purple")
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
      marker: (prompt_indicator "blue")
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
