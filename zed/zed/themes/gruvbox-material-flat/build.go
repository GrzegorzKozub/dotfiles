package main

import (
	"os"
	"strings"

	"github.com/tidwall/gjson"
	"github.com/tidwall/sjson"
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

func set(target string, prop string, source string) string {
	result, err := sjson.SetRaw(target, prop, source)
	if err != nil {
		panic(err)
	}
	return result
}

func build() {
	theme := read("./theme.json")
	for _, variant := range [1]string{"dark"} {
		colors := read("./" + variant + "-theme.json")
		palette := parse("./" + variant + "-palette.jsonc")
		palette.ForEach(func(key, value gjson.Result) bool {
			colors = strings.ReplaceAll(colors, "{{"+key.Str+"}}", value.Str)
			return true
		})
		theme = set(theme, "themes.-1", colors)
	}
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
	build()
}
