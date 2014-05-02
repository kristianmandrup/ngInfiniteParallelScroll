class BaseContainerConfig implements Debugger
  (debug) ->
    @log!

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