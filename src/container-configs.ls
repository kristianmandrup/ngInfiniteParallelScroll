navigator-helper = require './navigator'

class BaseContainerConfig implements Debugger
  (@scroll-config) ->
    @log!
    @configure!

  log: ->
    debug "container configuration"

  container-bottom: ->
    @_container-bottom = calc-container-bottom!

  elem-bottom: ->
    @_element-bottom   = calc-elem-bottom!

  scroll-boundary: ->
    @c-height! * @config.scroll-distance + 1

  c-height: ->
    @container.height!

  e-height: ->
    @elem.height!

  configure: ->
    # smart destructuring :)
    @{config, container, elem, debugging} = @scroll-config
    # no config

  is-chrome-browser: ->
    @browser-name! is 'Chrome'

  browser-name: ->
    navigator-helper.sayswho.match(/\w+/)[0]

  browser-version: ->
    parseInt(navigator-helper.sayswho.match(/\d+/)[0], 10)


class WindowContainerConfig extends BaseContainerConfig
  (@container, @elem, @debugging) ->
    super ...

  calc-container-bottom: ->
    @container.height! + @container.scroll-top!

  calc-elem-bottom: ->
    @elem.offset!top + @e-height!

  # per-browser configuration for determining window height correctly

  configure: ->
    super!
    # not needed? http://viralpatel.net/blogs/jquery-window-height-incorrect/
    # @configure-for-chrome! if @is-chrome-browser! and @browser-version >= 34 # also for lower version?

  # overwrite c-height function to use innerHeight of container (which is window)
  configure-for-chrome: ->
    @c-height = ->
      @container.innerHeight!


class DomContainerConfig extends BaseContainerConfig
  (@config) ->
    super ...

  configure: ->
    super!

  calc-container-bottom: ->
    @c-height!

  calc-elem-bottom: ->
    @elem.offset!top - @container.offset!top + @e-height!

module.exports =
  BaseContainerConfig: BaseContainerConfig
  WindowContainerConfig: WindowContainerConfig
  DomContainerConfig: DomContainerConfig