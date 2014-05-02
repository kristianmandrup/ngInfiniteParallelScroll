class ScrollConfig
  (debug) ->
    @reset!
    @debug-on! if debug?
    @debug-lv = parseInt(debug, 10) or 0

  reset: ->
    @scroll-distance = null
    @scroll-enabled = null
    @check-when-enabled = null
    @container = null
    @immediate-check = true

  toggle-enabled: (value) ->
    @config.scroll-enabled = not (value or @config.scroll-enabled)

  is-scroll-enabled: ->
    @scroll-enabled && @check-when-enabled

  set-scroll-distance: (value) ->
    @scroll-distance = parseInt(value, 10) or 0

  disable-scroll: ->
    @check-when-enabled = false

  enable-scroll: ->
    check-when-enabled = true

module.exports = ScrollConfig