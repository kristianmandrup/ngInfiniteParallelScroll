mod = angular.module 'infinite-scroll', []

mod.value 'THROTTLE_MILLISECONDS', null

Throttler     = require './throttler'
ScrollHandler = require './scroll-handler'

mod.directive 'infiniteScroller', ['$rootScope', '$window', '$timeout', 'THROTTLE_MILLISECONDS', \
                                  ($rootScope, $window, $timeout, THROTTLE_MILLISECONDS) ->
  scope:
    infinite-scroll: '&'
    debug-on: '&'
    debug-lv: '&'
    infinite-scroll-container: '='
    infinite-scroll-distance: '='
    infinite-scroll-disabled: '='

  debug-msg: ->
    if @debug-on
      console.log ...

  config: new ScrollConfig

  handle-infinite-scroll-disabled: (value) ->
    @config-toggle-scroll-enabled value
    if @config.is-scroll-enabled!
      @config.disable-scroll!
      @handler!

  handle-infinite-scroll-container: (new-container) ->
    # TODO: For some reason newContainer is sometimes null instead
    # of the empty array, which Angular is supposed to pass when the
    # element is not defined
    # (https://github.com/sroze/ngInfiniteScroll/pull/7#commitcomment-5748431).
    # So I leave both checks.
    return unless @is-valid-container new-container
    @change-container new-container

  is-valid-container: (container) ->
    container? and container.length > 0

  # infinite-scroll-container sets the container which we want to be
  # infinte scrolled, instead of the whole window. Must be an
  # Angular or jQuery element, or, if jQuery is loaded,
  # a jQuery selector as a string.
  change-container: (new-container) ->
    new-container = @wrap-angular new-container
    @container.off 'scroll', handler if @container?

    @container = new-container
    @container.on 'scroll', handler

  # infinite-scroll-distance specifies how close to the bottom of the page
  # the window is allowed to be before we trigger a new scroll. The value
  # provided is multiplied by the container height; for example, to load
  # more when the bottom of the page is less than 3 container heights away,
  # specify a value of 3. Defaults to 0.
  handle-infinite-scroll-distance = (value) ->
    @config.set-scroll-distance value

  wrap-angular: (element) ->
    angular.element element

  throttler: (debug) ->
    @_throttler ||= new Throttler($timeout, debug)

  basic-scroll-handler: (debug)->
    new ScrollHandler(debug).handle-scroll

  throttled-scroll-handler: (wait-ms, debug)->
    @throttler(debug).config @scroll-handler(debug), wait-ms if wait-ms?

  create-scroll-handler: (wait, debug)->
    @scroll-handler = @throttled-scroll-handler(wait, debug) or @basic-handler(debug)

  link: (scope, elem, attrs) ->
    debug-msg "infiniteScroller: link ", attrs
    $window   = @wrap-angular $window

    @debug-on = attrs.debug-on
    @debug-lv = attrs.debug-lv or 0

    wait-ms = THROTTLE_MILLISECONDS
    debug-msg "wait ", wait-ms

    @create-scroll-handler wait-ms, @debug-lv

    scope.$on '$destroy', ->
      @config.container.off 'scroll', @scroll-handler

    debug-msg "infiniteScrollDistance", @handle-infinite-scroll-distance

    scope.$watch 'infiniteScrollDistance', @handle-infinite-scroll-distance
    # If I don't explicitly call the handler here, tests fail. Don't know why yet.
    @handle-infinite-scroll-distance scope.infinite-scroll-distance

    debug-msg "handle-infinite-scroll-distance using", scope.infinite-scroll-distance

    # infinite-scroll-disabled specifies a boolean that will keep the
    # infnite scroll function from being called; this is useful for
    # debouncing or throttling the function call. If an infinite
    # scroll is triggered but this value evaluates to true, then
    # once it switches back to false the infinite scroll function
    # will be triggered again.

    scope.$watch 'infiniteScrollDisabled', handle-infinite-scroll-disabled
    # If I don't explicitly call the handler here, tests fail. Don't know why yet.
    handle-infinite-scroll-disabled scope.infinite-scroll-disabled

    debug-msg "try changing container to $window"
    @change-container $window

    scope.$watch 'infiniteScrollContainer', handle-infinite-scroll-container
    @handle-infinite-scroll-container scope.infinite-scroll-container or []

    # infinite-scroll-parent establishes this element's parent as the
    # container infinitely scrolled instead of the whole window.
    if attrs.infinite-scroll-parent?
      parent = elem.parent!
      angle-parent = @wrap-angular parent

      @debug-msg "Infinite scroll parent is", angle-parent

      @change-container angle-parent
    else
      @debug-msg "Infinite scroll parent is window"

    # infinite-scoll-immediate-check sets whether or not run the
    # expression passed on infinite-scroll for the first time when the
    # directive first loads, before any actual scroll.
    if attrs.infinite-scroll-immediate-check?
      @debug-msg "infinite-scroll-immediate-check", attrs.infinite-scroll-immediatecheck
      @config.immediate-check = scope.$eval attrs.infinite-scroll-immediatecheck

    self = @
    $timeout (->
      self.debug-msg 'timeout'
      if self.immediate-check
        self.debug-msg 'immediate check OK - run handler!'
        self.scroll-handler.handle-scroll!
    ), 0
]
