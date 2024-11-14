// https://github.com/zed-industries/zed/blob/main/crates/theme/src/schema.rs

package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
)

func main() {
	templateFile, err := os.ReadFile("./template.json")
	if err != nil {
		panic(err)
	}
	theme := string(templateFile)
	colorsFile, err := os.ReadFile("./colors.json")
	if err != nil {
		panic(err)
	}
	colors := make(map[string]string)
	if err := json.Unmarshal(colorsFile, &colors); err != nil {
		panic(err)
	}
	for k, v := range colors {
		theme = strings.ReplaceAll(theme, fmt.Sprintf("{{%s}}", k), v)
	}
	if err := os.WriteFile("../gruvbox-material.json", []byte(theme), 0644); err != nil {
		panic(err)
	}
}
