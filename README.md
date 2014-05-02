![logo](http://sroze.github.com/ngInfiniteScroll/images/logo-resized.png)

[![Build Status](https://travis-ci.org/sroze/ngInfiniteScroll.png?branch=master)](https://travis-ci.org/sroze/ngInfiniteScroll)

ngInfiniteScroll is a directive for [AngularJS](http://angularjs.org/) to evaluate an expression when the bottom of the directive's element approaches the bottom of the browser window, which can be used to implement infinite scrolling.

Getting Started
---------------

 * See ngInfiniteScroll @ [ngInfiniteScroll web site](http://sroze.github.com/ngInfiniteScroll/)
 * Install via Bower: `bower install ngInfiniteScroll`
 * Include the script tag on your page after the AngularJS and jQuery script tags

        <script type='text/javascript' src='path/to/jquery.min.js'></script>
        <script type='text/javascript' src='path/to/angular.min.js'></script>
        <script type='text/javascript' src='path/to/ng-infinite-scroll.min.js'></script>

 * Ensure that your application module specifies `infinite-scroll` as a dependency:

        angular.module('myApplication', ['infinite-scroll']);

 * Use the directive by specifying an `infinite-scroll` attribute on an element.

        <div infinite-scroll="myPagingFunction()" infinite-scroll-distance="3"></div>

Note that neither the module nor the directive use the `ng` prefix, as that prefix is reserved for the core Angular module.

Detailed Documentation
----------------------

ngInfiniteScroll accepts several attributes to customize the behavior of the directive; detailed instructions can be found [on the ngInfiniteScroll web site](http://sroze.github.com/ngInfiniteScroll/documentation.html).

Ports
-----

If you use [AngularDart](https://github.com/angular/angular.dart), Juha Komulainen has [a port of the project](http://pub.dartlang.org/packages/ng_infinite_scroll) you can use.

License
-------

ngInfiniteScroll is licensed under the MIT license. See the LICENSE file for more details.

Testing
-------

ngInfiniteScroll uses Testacular for its unit tests. Note that you will need [PhantomJS](http://phantomjs.org/) on your path,
and the `grunt-cli` npm package installed globally if you wish to use grunt (`npm install -g grunt-cli`).
Then, install the dependencies with `npm install`.

 * `grunt test` - continually watch for changes and run tests in PhantomJS and Chrome
 * `npm test` - run tests once in PhantomJS only

Refactored version
------------------

This version is a refactored version of the *1.1.0* release by @sroze. It is a fork from [@fkiller](https://github.com/fkiller/ngInfiniteParallelScroll)

Browserify
----------

This refactoring uses node Common JS modules. It can be assembled into a single file for browser usage, using browserify.

`browserify src/infinite-scroller.js -o build/infinite-scroller.js`

Demos
-----

This project contains a demos folder with demo projects.