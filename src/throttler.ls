Debugger = require './debugger'

class Throttler implements Debugger
  # The optional THROTTLE_MILLISECONDS configuration value specifies
  # a minimum time that should elapse between each call to the
  # handler. N.b. the first call the handler will be run
  # immediately, and the final call will always result in the
  # handler being called after the `wait` period elapses.
  # A slimmed down version of underscore's implementation.
  (@$timeout) ->

  config: (@func, @wait) ->
    @throttle

  throttle: ->
    if @no-time-remaining! then @reset! else @set-timeout!

  no-time-remaining: ->
    @remaining-time! <= 0

  remaining-time: ->
    @remaining ||= wait - (@now! - @previous)

  set-timeout: ->
    debug "set timeout"
    @timeout ||= $timeout(later, remaining)

  reset: ->
    debug "reset"
    @clearTimeout @timeout
    @$timeout.cancel @timeout
    @timeout = null
    @previous = @now!
    @func.call!

  now: ->
    @_now ||= new Date().get-time!

  timeout: null
  previous: 0

  later: ->
    debug "later"
    @previous = new Date().get-time!
    @$timeout.cancel timeout
    @timeout = null
    @func.call!
    @context = null
