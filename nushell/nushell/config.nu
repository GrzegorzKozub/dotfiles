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
  completions: { algorithm: fuzzy }
  filesize: { metric: true }
  cursor_shape: { vi_insert: line vi_normal: block }
  color_config: $gruvbox_material_dark
  footer_mode: 32
  float_precision: 1
  edit_mode: vi
  use_kitty_protocol: true
}
