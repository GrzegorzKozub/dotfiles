// https://github.com/zed-industries/zed/blob/main/crates/theme/src/schema.rs

package main

import (
	"os"
	"strings"

	"github.com/tidwall/gjson"
)

func read(path string) string {
	file, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return string(file)
}

func parse(path string) gjson.Result {
	return gjson.Parse(read(path))
}

func build(variant string) {
	theme := read("./template.json")
	palette := parse("./" + variant + ".jsonc")
	palette.ForEach(func(key, value gjson.Result) bool {
		theme = strings.ReplaceAll(theme, "{{"+key.Str+"}}", value.Str)
		return true
	})
	theme = gjson.Get(theme, "@pretty").Raw
	if err := os.WriteFile(
		"../gruvbox-material-flat.json",
		[]byte(theme),
		0644,
	); err != nil {
		panic(err)
	}
}

func main() {
	for _, variant := range [1]string{"dark"} {
		build(variant)
	}
}
