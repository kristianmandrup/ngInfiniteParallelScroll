# infinite-scroll specifies a function to call when the window,
# or some other container specified by infinite-scroll-container,
# is scrolled within a certain range from the bottom of the
# document. It is recommended to use infinite-scroll-disabled
# with a boolean that is set to true when the function is
# called in order to throttle the function call.
Debugger = require './debugger'
container-configs = require './container-configs'

class ScrollHandler implements Debugger
  (@scope, @config, debug) ->
    @container        = @config.container
    @elem             = @config.elem
    @scroll-distance  = @config.scroll-distance
    @scroll-enabled   = @config.scroll-enabled

    @debug-on! if debug?
    @debug-lv = parseInt(debug, 10) or 0
    @

  handle-scroll: ->
    info-msg "remaining", @remaining!
    info-msg "scroll-boundary", @scroll-boundary!
    debug "handle scroll, should:", @should-scroll!
    @scroll! if @should-scroll!

  isWindowContainer: ->
    @container == $window

  scroll: ->
    info-msg "scroll"
    if @scroll-enabled then @perform-scroll! else @enable-scroll!

  perform-scroll: ->
    info-msg "perform scroll"
    @configure-scroll!
    @scope.infiniteScroll!

  enable-scroll: ->
    info-msg "enable scroll", @config
    @config.enable-scroll!

  configure-scroll: ->
    info-msg "configure-scroll, window-container:", @is-window-container!


  should-scroll: ->
    @remaining! <= @scroll-boundary!

  scroll-boundary: ->
    @container.height! * @scroll-distance + 1

  remaining: ->
    @_remaining ||= @element-bottom! - @container-bottom!

  element-bottom: ->
    @container-config!.element-bottom!

  container-bottom: ->
    @container-config!.container-bottom!

  container-config: ->
    @_container-config ||= @window-container-config! or @dom-container-config!

  dom-container-config: ->
     new container-configs.ContainerConfig @debugging

  window-container-config: ->
    @_window-container-config ||= new container-configs.WindowContainerConfig(@debugging) if @is-window-container!


module.exports = ScrollHandler