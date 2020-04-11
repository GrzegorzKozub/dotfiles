from __future__ import (absolute_import, division, print_function)
import os
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    default, black, blue, cyan, green, magenta, red, white, yellow,
    normal, bold, dim, reverse, BRIGHT,
    default_colors
)
class Solarized(ColorScheme):
    progress_bar_color = blue
    __light = os.environ['MY_THEME'] == 'solarized-light'
    def __dim_gray(self):
        color = cyan if self.__light else green
        color += BRIGHT
        return color
    def __almost_background(self): return white if self.__light else black
    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset: return default_colors
        elif context.in_browser:
            if context.empty:
                fg = self.__almost_background()
                bg = default
            if context.error: fg, bg = red, default
            if context.directory: fg = blue
            elif context.executable and \
                    not any((context.container, context.fifo, context.media, context.socket)):
                fg = green
            if context.link:
                fg = cyan if context.good else magenta
            if not context.selected and (context.cut or context.copied): fg = self.__dim_gray()
            if context.main_column and context.marked: bg = self.__almost_background()
            if context.selected: attr = reverse
        elif context.in_titlebar:
            if context.directory: fg = self.__dim_gray()
            elif context.link: fg = cyan
            elif context.tab: fg = default if context.good else self.__dim_gray()
            else: fg = blue
        elif context.in_statusbar:
            if context.permissions:
                fg = green if context.good else red
            elif context.message:
                if context.bad: fg = red
            else: fg = self.__dim_gray()
            if context.loaded: bg = self.progress_bar_color
        elif context.in_taskview:
            if context.selected:
                fg = self.__dim_gray()
                attr = reverse
            if context.loaded: bg = self.progress_bar_color
        return fg, bg, attr
