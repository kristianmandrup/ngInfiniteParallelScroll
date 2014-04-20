/* ng-infinite-parallel-scroll - v1.0.0 - 2013-04-20 */
var mod;

mod = angular.module('infinite-parallel-scroll', []);

mod.directive('infiniteParallelScroll', [
  '$rootScope', '$window', '$timeout', function ($rootScope, $window, $timeout) {
      return {
          link: function (scope, elem, attrs) {
              var checkWhenEnabled, handler, scrollDistance, scrollEnabled;
              $window = angular.element($window);

              scrollDistance = 0;
              if (attrs.infiniteScrollDistance != null) {
                  scope.$watch(attrs.infiniteScrollDistance, function (value) {
                      return scrollDistance = parseInt(value, 10);
                  });
              }
              scrollEnabled = true;
              checkWhenEnabled = false;
              if (attrs.infiniteScrollDisabled != null) {
                  scope.$watch(attrs.infiniteScrollDisabled, function (value) {
                      scrollEnabled = !value;
                      if (scrollEnabled && checkWhenEnabled) {
                          checkWhenEnabled = false;
                          return handler();
                      }
                  });
              }
              handler = function () {
                  var elementBottom, targetBottom, remaining, shouldScroll, windowBottom;
                  windowBottom = $window.height() + $window.scrollTop();
                  elementBottom = elem.offset().top + elem.height();
                  if (attrs.infiniteScrollTarget && angular.element('#' + attrs.infiniteScrollTarget).length) {
                      targetBottom = elem.offset().top + angular.element('#' + attrs.infiniteScrollTarget).offset().top + angular.element('#' + attrs.infiniteScrollTarget).height();
                      remaining = targetBottom - windowBottom;
                  } else {
                      remaining = elementBottom - windowBottom;
                  }
                  shouldScroll = remaining <= $window.height() * scrollDistance;
                  if (shouldScroll && scrollEnabled) {
                      if ($rootScope.$$phase) {
                          return scope.$eval(attrs.infiniteScroll);
                      } else {
                          return scope.$apply(attrs.infiniteScroll);
                      }
                  } else if (shouldScroll) {
                      return checkWhenEnabled = true;
                  }
              };
              $window.on('scroll', handler);
              scope.$on('$destroy', function () {
                  return $window.off('scroll', handler);
              });
              return $timeout((function () {
                  if (attrs.infiniteScrollImmediateCheck) {
                      if (scope.$eval(attrs.infiniteScrollImmediateCheck)) {
                          return handler();
                      }
                  } else {
                      return handler();
                  }
              }), 0);
          }
      };
  }
]);