module.exports =
  debugging: false

  has-debug: ->
    @debugging || @@debug-all

  debug: ->
    if @has-debug!
      constr = @constructor.display-name || @display-name
      console.log constr + ':'
      console.log ...

  info-msg: ->
    if @debugging || @@debug-all
      console.log ...

  debug-all-on: ->
    @debug-all = true

  debug-all-off: ->
    @debug-all = false

  debug-on: ->
    @debugging = true

  debug-off: ->
    @debugging = false