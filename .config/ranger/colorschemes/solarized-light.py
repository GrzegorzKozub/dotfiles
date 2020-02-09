from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    default, black, blue, cyan, green, magenta, red, white, yellow,
    normal, bold, dim, reverse, BRIGHT,
    default_colors
)

class SolarizedLight(ColorScheme):
    progress_bar_color = blue
    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset: return default_colors
        elif context.in_browser:
            if context.selected:
                fg = cyan
                fg += BRIGHT
                attr = reverse
            if context.empty: fg, bg = white, default
            if context.error: fg, bg = red, default
            if context.directory: fg = blue
            elif context.executable and \
                    not any((context.container, context.fifo, context.media, context.socket)):
                fg = green
            if context.link: fg = cyan if context.good else magenta
            if not context.selected and (context.cut or context.copied):
                fg = cyan
                fg += BRIGHT
            if context.main_column and context.marked: bg = white
        elif context.in_titlebar:
            if context.directory:
                fg = cyan
                fg += BRIGHT
            elif context.link: fg = cyan
            elif context.tab:
                if context.good: fg = default
                else:
                    fg = cyan
                    fg += BRIGHT
            else: fg = blue
        elif context.in_statusbar:
            if context.permissions:
                fg = green if context.good else red
            elif context.message:
                if context.bad: fg = red
            else:
                fg = cyan
                fg += BRIGHT
            if context.loaded: bg = self.progress_bar_color
        elif context.in_taskview:
            if context.selected:
                fg = cyan
                fg += BRIGHT
                attr = reverse
            if context.loaded: bg = self.progress_bar_color
        return fg, bg, attr
