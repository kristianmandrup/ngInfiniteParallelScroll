# infinite-scroll specifies a function to call when the window,
# or some other container specified by infinite-scroll-container,
# is scrolled within a certain range from the bottom of the
# document. It is recommended to use infinite-scroll-disabled
# with a boolean that is set to true when the function is
# called in order to throttle the function call.
require './debugger'

class ScrollHandler implements Debugger
  (@scope, @config) ->
    @container        = @config.container
    @elem             = @config.elem
    @scroll-distance  = @config.scroll-distance
    @scroll-enabled   = @config.scroll-enabled
    @

  handle-scroll: ->
    @scroll! if @should-scroll!

  isWindowContainer: ->
    @container == $window

  scroll: ->
    if @scroll-enabled then @perform-scroll! else @enable-scroll!

  perform-scroll: ->
    @configure-scroll!
    @scope.infiniteScroll!

  enable-scroll: ->
    @config.enable-scroll!

  configureScroll: ->
    if @is-window-container! then @config-window-scroll! else @config-container-scroll!

  should-scroll:
    @remaining! <= @scroll-boundary!

  scroll-boundary: ->
    @container.height! * @scroll-distance + 1

  remaining: ->
    @_remaining ||= @element-bottom - @container-bottom

  config-window-scroll: ->
    @container-bottom = @container.height! + @container.scroll-top!
    @element-bottom   = @elem.offset!top + @elem.height!

  config-container-scroll: ->
    container-bottom  = @container.height!
    element-bottom    = @elem.offset!top - @container.offset!top + @elem.height!


module.exports = ScrollHandler