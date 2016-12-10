-------------------------------
--  Based on "Zenburn theme  --
-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- {{{ Main
theme = {}

theme.configdir = os.getenv("HOME") .. "/.config/awesome"
theme.themedir = theme.configdir .. "/themes/default"

theme.wallpaper = theme.themedir .. "/background.png"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"

theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#1E2320"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 1
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#FF0000"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.themedir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.themedir .. "/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.themedir .. "/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.themedir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.themedir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.themedir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.themedir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.themedir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.themedir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.themedir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.themedir .. "/layouts/dwindle.png"
theme.layout_max        = theme.themedir .. "/layouts/max.png"
theme.layout_fullscreen = theme.themedir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.themedir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.themedir .. "/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.themedir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.themedir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.themedir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.themedir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.themedir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.themedir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.themedir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.themedir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.themedir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.themedir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.themedir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.themedir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.themedir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.themedir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.themedir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.themedir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.themedir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.themedir .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme