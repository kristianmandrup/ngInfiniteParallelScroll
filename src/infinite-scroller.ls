mod = angular.module('infinite-scroll', [])

mod.value('THROTTLE_MILLISECONDS', null)

Throttler     = require './throttler'
ScrollHandler = require './scroll-handler'

mod.directive 'infiniteScroller', ['$rootScope', '$window', '$timeout', 'THROTTLE_MILLISECONDS', \
                                  ($rootScope, $window, $timeout, THROTTLE_MILLISECONDS) ->
  scope:
    infinite-scroll: '&'
    infinite-scroll-container: '='
    infinite-scroll-distance: '='
    infinite-scroll-disabled: '='

  config: new ScrollConfig
  scroll-handler: ->
    @_handler ||= new ScrollHandler.handle-scroll

  throttler: ->
    @_throttle ||= new Throttler($timeout)

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

  wrap-angular: (element) ->
    angular.element element

  link: (scope, elem, attrs) ->
    $window   = @wrap-angular $window

    @scroll-handler = @throttler!.config(@scroll-handler!, THROTTLE_MILLISECONDS) if THROTTLE_MILLISECONDS?

    scope.$on '$destroy', ->
      @config.container.off 'scroll', handler

    # infinite-scroll-distance specifies how close to the bottom of the page
    # the window is allowed to be before we trigger a new scroll. The value
    # provided is multiplied by the container height; for example, to load
    # more when the bottom of the page is less than 3 container heights away,
    # specify a value of 3. Defaults to 0.
    handle-infinite-scroll-distance = (value) ->
      @config.set-scroll-distance value

    scope.$watch 'infiniteScrollDistance', handle-infinite-scroll-distance
    # If I don't explicitly call the handler here, tests fail. Don't know why yet.
    handle-infinite-scroll-distance scope.infinite-scroll-distance

    # infinite-scroll-disabled specifies a boolean that will keep the
    # infnite scroll function from being called; this is useful for
    # debouncing or throttling the function call. If an infinite
    # scroll is triggered but this value evaluates to true, then
    # once it switches back to false the infinite scroll function
    # will be triggered again.

    scope.$watch 'infiniteScrollDisabled', handle-infinite-scroll-disabled
    # If I don't explicitly call the handler here, tests fail. Don't know why yet.
    handle-infinite-scroll-disabled scope.infinite-scroll-disabled

    @change-container $window

    scope.$watch 'infiniteScrollContainer', handle-infinite-scroll-container
    handle-infinite-scroll-container(scope.infinite-scroll-container or [])

    # infinite-scroll-parent establishes this element's parent as the
    # container infinitely scrolled instead of the whole window.
    if attrs.infinite-scroll-parent?
      @change-container @wrap-angular(elem.parent!)

    # infinte-scoll-immediate-check sets whether or not run the
    # expression passed on infinite-scroll for the first time when the
    # directive first loads, before any actual scroll.
    if attrs.infinite-scroll-immediate-check?
      @config.immediate-check = scope.$eval attrs.infinite-scroll-immediatecheck

    self = @
    $timeout (->
      if self.immediate-check
        self.handler!
    ), 0
]
