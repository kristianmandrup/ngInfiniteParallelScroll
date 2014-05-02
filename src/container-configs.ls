navigator-helper = require './navigator'

class BaseContainerConfig implements Debugger
  (debug) ->
    @log!
    @configure!

  log: ->
    debug "container configuration"

  container-bottom: ->
    @_container-bottom = calc-container-bottom!

  elem-bottom: ->
    @_element-bottom   = calc-elem-bottom!

  c-height: ->
    @container.height!

  e-height: ->
    @elem.height!

  configure: ->
    @configure-for-chrome! if @is-chrome-browser! and @browser-version >= 34

  is-chrome-browser: ->
    @browser-name! is 'Chrome'

  configure-for-chrome: ->
    @c-height = ->
      @container.innerHeight!

  browser-name: ->
    navigator-helper.sayswho.match(/\w+/)[0]

  browser-version: ->
    parseInt(navigator-helper.sayswho.match(/\d+/)[0], 10)


class WindowContainerConfig extends BaseContainerConfig
  (debug) ->
    super ...

  calc-container-bottom: ->
    @container.height! + @container.scroll-top!

  calc-elem-bottom: ->
    @elem.offset!top + @e-height!

class DomContainerConfig extends BaseContainerConfig
  (debug) ->
    super ...
           
  calc-container-bottom: ->
    @c-height!

  calc-elem-bottom: ->
    @elem.offset!top - @container.offset!top + @e-height!

module.exports =
  BaseContainerConfig: BaseContainerConfig
  WindowContainerConfig: WindowContainerConfig
  DomContainerConfig: DomContainerConfig