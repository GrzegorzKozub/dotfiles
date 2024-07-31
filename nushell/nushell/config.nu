let gruvbox_material_dark = {
  header: dark_gray
}

$env.config = {
  show_banner: false
  table: {
    mode: none # can't change border color
    index_mode: auto
    show_empty: false
    padding: { left: 0, right: 0 }
    trim: { methodology: wrapping, truncating_suffix: "…" }
  }
  color_config: $gruvbox_material_dark
}
