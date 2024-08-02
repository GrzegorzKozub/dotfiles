let gruvbox_material_dark = {
  header: dark_gray
  filesize: gray
  date: gray
  row_index: dark_gray
  shape_directory: cyan
  shape_external: green
  shape_externalarg: yellow
  shape_external_resolved: green
  shape_filepath: cyan
  shape_garbage: { bg: red }
}

$env.config = {
  show_banner: false
  table: {
    mode: none # can't change border color
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
      marker: "●• "
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
      marker: "●• "
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
      marker: "●• "
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
