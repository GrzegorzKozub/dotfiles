-- https://github.com/maoiscat/mpv-osc-framework
-- luacheck: ignore 111 112 113 212

require 'expansion'
require 'oscf'

opts = {
  scale = 2,
  hideTimeout = 1,
  fadeDuration = 0.5,
}

-- color: bgr, foreground, border, background, border

local styles = {
  background = {
    color = { '0', '0', '0', '0' },
    alpha = { 255, 255, 0, 0 },
    border = 150,
    blur = 150,
  },
  tooltip = {
    color = { 'ffffff', 'ffffff', '0', '0' },
    font = 'sans-serif',
    fontsize = 24,
    border = 0.75,
  },
  big_button = {
    color1 = { 'ffffff', 'ffffff', 'ffffff', 'ffffff' },
    color2 = { '999999', '999999', '999999', '999999' },
    font = 'monospace',
    fontsize = 48,
  },
  button = {
    color1 = { 'ffffff', 'ffffff', 'ffffff', 'ffffff' },
    color2 = { '999999', '999999', '999999', '999999' },
    font = 'monospace',
    fontsize = 32,
  },
  seekbarFg = {
    color1 = { 'E39C42', 'E39C42', '0', '0' },
    color2 = { '999999', '999999', '0', '0' },
    border = 0.5,
    blur = 1,
  },
  seekbarBg = {
    color = { 'eeeeee', 'eeeeee', '0', '0' },
    border = 0,
    blur = 0,
  },
  volumeSlider = {
    color = { 'ffffff', '0', '0', '0' },
    border = 0,
    blur = 0,
  },
  time = {
    color1 = { 'ffffff', 'ffffff', '0', '0' },
    color2 = { 'eeeeee', 'eeeeee', '0', '0' },
    border = 0,
    blur = 0,
    fontsize = 17,
  },
  title = {
    color = { 'ffffff', '0', '0', '0' },
    border = 0.5,
    blur = 1,
    fontsize = 48,
    wrap = 2,
  },
  winControl = {
    color1 = { 'ffffff', 'ffffff', '0', '0' },
    color2 = { 'eeeeee', 'eeeeee', '0', '0' },
    border = 0.5,
    blur = 1,
    font = 'monospace',
    fontsize = 20,
  },
}

local env = newElement 'env'
env.layer = 1000
env.visible = false
env.init = function(self)
  self.slowTimer = mp.add_periodic_timer(0.5, self.updateTime)
  mp.observe_property('track-list/count', 'native', function(name, val)
    if val == 0 then
      return
    end
    player.chapters = getChapterList()
    player.tracks = getTrackList()
    player.playlist = getPlaylist()
    player.playlistPos = getPlaylistPos()
    player.duration = mp.get_property_number 'duration'
    -- showOsc()
    dispatchEvent 'file-loaded'
  end)
  mp.observe_property('current-tracks/audio/id', 'number', function(name, val)
    if val then
      player.audioTrack = val
    else
      player.audioTrack = 0
    end
    dispatchEvent 'audio-changed'
  end)
  mp.observe_property('current-tracks/sub/id', 'number', function(name, val)
    if val then
      player.subTrack = val
    else
      player.subTrack = 0
    end
    dispatchEvent 'sub-changed'
  end)
  mp.observe_property('pause', 'bool', function(name, val)
    player.paused = val
    dispatchEvent 'pause'
  end)
  mp.observe_property('mute', 'bool', function(name, val)
    player.muted = val
    dispatchEvent 'mute'
  end)
  mp.observe_property('volume', 'number', function(name, val)
    player.volume = val
    dispatchEvent 'volume'
  end)
  mp.observe_property('window-maximized', 'bool', function(name, val)
    player.maximized = val
    dispatchEvent 'window-maximized'
  end)
  mp.observe_property('fullscreen', 'bool', function(name, val)
    player.fullscreen = val
    dispatchEvent 'fullscreen'
  end)
end
env.updateTime = function()
  dispatchEvent 'time'
end
env.tick = function(self)
  player.percentPos = mp.get_property_number 'percent-pos'
  player.timePos = mp.get_property_number 'time-pos'
  player.timeRem = mp.get_property_number 'time-remaining'
end
env.responder['resize'] = function(self)
  player.geo.refX = player.geo.width / 2
  player.geo.refY = player.geo.height - 40
  setPlayActiveArea('background', 0, player.geo.height - 120, player.geo.width, player.geo.height)
  if player.fullscreen then
    setPlayActiveArea('window-controls', player.geo.width - 200, 0, player.geo.width, 48)
  else
    setPlayActiveArea('window-controls', -1, -1, -1, -1)
  end
end
-- env.responder['pause'] = function(self)
--   if player.idle then
--     return
--   end
--   if player.paused then
--     setVisibility 'always'
--   else
--     setVisibility 'normal'
--   end
-- end
-- env.responder['idle'] = function(self)
--   if player.idle then
--     setVisibility 'always'
--   else
--     setVisibility 'normal'
--   end
-- end
env:init()
addToPlayLayout 'env'

local background = newElement('background', 'box')
background.style = clone(styles.background)
background.layer = 5
background.geo.h = 1
background.geo.an = 8
background.responder['resize'] = function(self)
  self.geo.x = player.geo.refX
  self.geo.y = player.geo.height
  self.geo.w = player.geo.width
  self.setPos(self)
  self.render(self)
end
background:init()
addToPlayLayout 'background'

local tooltip = newElement('tooltip', 'tooltip')
tooltip.style = clone(styles.tooltip)
tooltip.layer = 20
tooltip:init()
addToPlayLayout 'tooltip'

local play = newElement('play', 'button')
play.style = clone(styles.big_button)
play.layer = 10
play.geo.w = 45
play.geo.h = 45
play.geo.an = 5
play.responder['resize'] = function(self)
  self.geo.x = player.geo.refX
  self.geo.y = player.geo.refY
  self:setPos()
  self:setHitBox()
end
play.responder['pause'] = function(self)
  if player.paused then
    self.text = '󰐊'
  else
    self.text = '󰏤'
  end
  self:render()
end
play.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    mp.commandv('cycle', 'pause')
  end
end
play:init()
addToPlayLayout 'play'

local prev = newElement('prev', 'button')
prev.style = clone(styles.button)
prev.layer = 10
prev.geo.w = 30
prev.geo.h = 24
prev.geo.an = 5
prev.text = '󰒮'
prev.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    mp.commandv('playlist-prev', 'weak')
  end
end
prev.responder['resize'] = function(self)
  self.geo.x = player.geo.refX - 60
  self.geo.y = player.geo.refY
  self:setPos()
  self:setHitBox()
end
prev.responder['file-loaded'] = function(self)
  if player.playlistPos <= 1 and player.loopPlaylist == 'no' then
    self:disable()
  else
    self:enable()
  end
end
prev:init()
addToPlayLayout('prev')

local next = newElement('next', 'button')
next.style = clone(styles.button)
next.layer = 10
next.geo.w = 30
next.geo.h = 24
next.geo.an = 5
next.text = '󰒭'
next.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    mp.commandv('playlist-next', 'weak')
  end
end
next.responder['resize'] = function(self)
  self.geo.x = player.geo.refX + 60
  self.geo.y = player.geo.refY
  self:setPos()
  self:setHitBox()
end
next.responder['file-loaded'] = function(self)
  if player.playlistPos >= #player.playlist and player.loopPlaylist == 'no' then
    self:disable()
  else
    self:enable()
  end
end
next:init()
addToPlayLayout('next')

local audio = newElement('audio', 'button')
audio.style = clone(styles.button)
audio.style.fontsize = 24
audio.layer = 10
audio.geo.w = 30
audio.geo.h = 24
audio.geo.an = 5
audio.text = '󰭹'
audio.responder['resize'] = function(self)
  self.geo.x = 37
  self.geo.y = player.geo.refY
  self.visible = player.geo.width >= 540
  self:setPos()
  self:setHitBox()
end
audio.responder['mouse_move'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    tooltip:show(self.tipText, { self.geo.x, self.geo.y + 30 }, self)
  else
    tooltip:hide(self)
  end
end
audio.responder['file-loaded'] = function(self)
  if #player.tracks.audio > 0 then
    self:enable()
  else
    self:disable()
  end
end
audio.responder['audio-changed'] = function(self)
  if player.tracks then
    local lang
    if player.audioTrack == 0 then
      lang = 'unknown'
    else
      lang = player.tracks.audio[player.audioTrack].lang
    end
    if not lang then
      lang = 'unknown'
    end
    self.tipText = string.format('%s/%s %s', player.audioTrack, #player.tracks.audio, lang)
    tooltip:update(self.tipText, self)
  end
end
audio.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    cycleTrack 'audio'
  end
end
audio.responder['mbtn_right_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    cycleTrack('audio', 'prev')
  end
end
audio:init()
addToPlayLayout 'audio'

local subtitles = newElement('subtitles', 'button')
subtitles.style = clone(styles.button)
subtitles.layer = 10
subtitles.geo.w = 30
subtitles.geo.h = 24
subtitles.geo.an = 5
subtitles.text = '󰅞'
subtitles.responder['resize'] = function(self)
  self.geo.x = 87
  self.geo.y = player.geo.refY
  self.visible = player.geo.width >= 600
  self:setPos()
  self:setHitBox()
end
subtitles.responder['mouse_move'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    tooltip:show(self.tipText, { self.geo.x, self.geo.y + 30 }, self)
  else
    tooltip:hide(self)
  end
end
subtitles.responder['file-loaded'] = function(self)
  if #player.tracks.sub > 0 then
    self:enable()
  else
    self:disable()
  end
end
subtitles.responder['sub-changed'] = function(self)
  if player.tracks then
    local title
    if player.subTrack == 0 then
      title = 'unknown'
    else
      title = player.tracks.sub[player.subTrack].title
    end
    if not title then
      title = 'unknown'
    end
    self.tipText = string.format('%s/%s %s', player.subTrack, #player.tracks.sub, title)
    tooltip:update(self.tipText, self)
  end
end
subtitles.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    cycleTrack 'sub'
  end
end
subtitles.responder['mbtn_right_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    cycleTrack('sub', 'prev')
  end
end
subtitles:init()
addToPlayLayout 'subtitles'




-- toggle mute
ne = newElement('togMute', 'button')
ne.layer = 10
ne.style = clone(styles.button)
ne.geo.x = 137
ne.geo.w = 30
ne.geo.h = 24
ne.geo.an = 5
ne.responder['resize'] = function(self)
  self.geo.y = player.geo.refY
  self.visible = player.geo.width >= 700
  self:setPos()
  self:setHitBox()
  return false
end
ne.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    mp.commandv('cycle', 'mute')
    return true
  end
  return false
end
ne.responder['mute'] = function(self)
  if player.muted then
    self.text = '󰝟'
  else
    self.text = '󰕾'
  end
  self:render()
  return false
end
ne:init()
addToPlayLayout('togMute', 'button')

-- volume slider
-- background
ne = newElement('volumeSliderBg', 'box')
ne.layer = 9
ne.style = clone(styles.volumeSlider)
ne.geo.r = 0
ne.geo.h = 1
ne.geo.an = 4
ne.responder['resize'] = function(self)
  self.visible = player.geo.width > 740
  self.geo.x = 156
  self.geo.y = player.geo.refY
  self.geo.w = 80
  self:init()
end
ne:init()
addToPlayLayout 'volumeSliderBg'

-- seekbar
ne = newElement('volumeSlider', 'slider')
ne.layer = 10
ne.style = clone(styles.volumeSlider)
ne.geo.an = 4
ne.geo.h = 14
ne.barHeight = 2
ne.barRadius = 0
ne.nobRadius = 4
ne.allowDrag = false
ne.lastSeek = nil
ne.responder['resize'] = function(self)
  self.visible = player.geo.width > 740
  self.geo.an = 4
  self.geo.x = 152
  self.geo.y = player.geo.refY
  self.geo.w = 88
  self:setParam() -- setParam may change geo settings
  self:setPos()
  self:render()
end
ne.responder['volume'] = function(self)
  local val = player.volume
  if val then
    if val > 140 then
      val = 140
    elseif val < 0 then
      val = 0
    end
    self.value = val / 1.4
    self.xValue = val / 140 * self.xLength
    self:render()
  end
  return false
end
ne.responder['idle'] = ne.responder['volume']
ne.responder['mouse_move'] = function(self, pos)
  if not self.enabled then
    return false
  end
  local vol = self:getValueAt(pos)
  if self.allowDrag then
    if vol then
      mp.commandv('set', 'volume', vol * 1.4)
      env.updateTime()
    end
  end
  if self:isInside(pos) then
    local tipText
    if vol then
      tipText = string.format('%d', vol * 1.4)
    else
      tipText = 'N/A'
    end
    tooltip:show(tipText, { pos[1], self.geo.y }, self)
    return true
  else
    tooltip:hide(self)
    return false
  end
end
ne.responder['mbtn_left_down'] = function(self, pos)
  if not self.enabled then
    return false
  end
  if self:isInside(pos) then
    self.allowDrag = true
    local vol = self:getValueAt(pos)
    if vol then
      mp.commandv('set', 'volume', vol * 1.4)
      return true
    end
  end
  return false
end
ne.responder['mbtn_left_up'] = function(self, pos)
  self.allowDrag = false
  self.lastSeek = nil
end
ne:init()
addToPlayLayout 'volumeSlider'

-- toggle fullscreen
ne = newElement('togFs', 'button')
ne.layer = 10
ne.style = clone(styles.button)
ne.geo.w = 30
ne.geo.h = 24
ne.geo.an = 5
ne.responder['resize'] = function(self)
  self.geo.x = player.geo.width - 37
  self.geo.y = player.geo.refY
  self.visible = player.geo.width >= 600
  if player.fullscreen then
    self.text = '󰊔'
  else
    self.text = '󰊓'
  end
  self:render()
  self:setPos()
  self:setHitBox()
  return false
end
ne.responder['mbtn_left_up'] = function(self, pos)
  if self.enabled and self:isInside(pos) then
    mp.commandv('cycle', 'fullscreen')
    return true
  end
  return false
end
ne:init()
addToPlayLayout 'togFs'

-- seekbar background
ne = newElement('seekbarBg', 'box')
ne.layer = 9
ne.style = clone(styles.seekbarBg)
ne.geo.r = 0
ne.geo.h = 2
ne.geo.an = 5
ne.responder['resize'] = function(self)
  self.geo.x = player.geo.refX
  self.geo.y = player.geo.refY - 56
  self.geo.w = player.geo.width - 50
  self:init()
end
ne:init()
addToPlayLayout 'seekbarBg'

-- seekbar
ne = newElement('seekbar', 'slider')
ne.layer = 10
ne.style = clone(styles.seekbarFg)
ne.geo.an = 5
ne.geo.h = 20
ne.barHeight = 2
ne.barRadius = 0
ne.nobRadius = 8
ne.allowDrag = false
ne.lastSeek = nil
ne.responder['resize'] = function(self)
  self.geo.an = 5
  self.geo.x = player.geo.refX
  self.geo.y = player.geo.refY - 56
  self.geo.w = player.geo.width - 34
  self:setParam() -- setParam may change geo settings
  self:setPos()
  self:render()
end
ne.responder['time'] = function(self)
  local val = player.percentPos
  if val and not self.enabled then
    self:enable()
  elseif not val and self.enabled then
    tooltip:hide(self)
    self:disable()
  end
  if val then
    self.value = val
    self.xValue = val / 100 * self.xLength
    self:render()
  end
  return false
end
ne.responder['mouse_move'] = function(self, pos)
  if not self.enabled then
    return false
  end
  if self.allowDrag then
    local seekTo = self:getValueAt(pos)
    if seekTo then
      mp.commandv('seek', seekTo, 'absolute-percent')
      env.updateTime()
    end
  end
  if self:isInside(pos) then
    local tipText
    if player.duration then
      local seconds = self:getValueAt(pos) / 100 * player.duration
      if #player.chapters > 0 then
        local ch = #player.chapters
        for i, v in ipairs(player.chapters) do
          if seconds < v.time then
            ch = i - 1
            break
          end
        end
        if ch == 0 then
          tipText = string.format('[0/%d][unknown]\\N%s', #player.chapters, mp.format_time(seconds))
        else
          local title = player.chapters[ch].title
          if not title then
            title = 'unknown'
          end
          tipText = string.format('[%d/%d][%s]\\N%s', ch, #player.chapters, title, mp.format_time(seconds))
        end
      else
        tipText = mp.format_time(seconds)
      end
    else
      tipText = '--:--:--'
    end
    tooltip:show(tipText, { pos[1], self.geo.y }, self)
    return true
  else
    tooltip:hide(self)
    return false
  end
end
ne.responder['mbtn_left_down'] = function(self, pos)
  if not self.enabled then
    return false
  end
  if self:isInside(pos) then
    self.allowDrag = true
    local seekTo = self:getValueAt(pos)
    if seekTo then
      mp.commandv('seek', seekTo, 'absolute-percent')
      env.updateTime()
      return true
    end
  end
  return false
end
ne.responder['mbtn_left_up'] = function(self, pos)
  self.allowDrag = false
  self.lastSeek = nil
end
ne.responder['file-loaded'] = function(self)
  -- update chapter markers
  env.updateTime()
  self.markers = {}
  if player.duration then
    for i, v in ipairs(player.chapters) do
      self.markers[i] = (v.time * 100 / player.duration)
    end
    self:render()
  end
  return false
end
ne:init()
addToPlayLayout 'seekbar'

-- time display
ne = newElement('time1', 'button')
ne.layer = 10
ne.style = clone(styles.time)
ne.geo.w = 64
ne.geo.h = 20
ne.geo.an = 7
ne.enabled = true
ne.responder['resize'] = function(self)
  self.geo.x = 25
  self.geo.y = player.geo.refY - 44
  self:setPos()
end
ne.responder['time'] = function(self)
  if player.timePos then
    self.pack[4] = mp.format_time(player.timePos)
  else
    self.pack[4] = '--:--:--'
  end
end
ne:init()
addToPlayLayout 'time1'

-- time duration
ne = newElement('time2', 'time1')
ne.geo.an = 9
ne.isDuration = true
ne.responder['resize'] = function(self)
  self.geo.x = player.geo.width - 25
  self.geo.y = player.geo.refY - 44
  self:setPos()
  self:setHitBox()
end
ne.responder['time'] = function(self)
  if self.isDuration then
    val = player.duration
  else
    val = -player.timeRem
  end
  if val then
    self.pack[4] = mp.format_time(val)
  else
    self.pack[4] = '--:--:--'
  end
end
ne.responder['mbtn_left_up'] = function(self, pos)
  if self:isInside(pos) then
    self.isDuration = not self.isDuration
    return true
  end
  return false
end
ne:init()
addToPlayLayout 'time2'


