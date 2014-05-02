myApp = angular.module 'myApp', ['infinite-scroll']
myApp.controller 'DemoController', ($scope) ->
  $scope.images = [1, 2, 3, 4, 5, 6, 7, 8]

  $scope.loadMore = ->
    last = $scope.images[$scope.images.length - 1]
    for i from 0 to 7
      $scope.images.push last + i
