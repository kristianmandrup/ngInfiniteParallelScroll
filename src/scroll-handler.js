// Generated by LiveScript 1.2.0
(function(){
  var Debugger, containerConfigs, ScrollHandler;
  Debugger = require('./debugger');
  containerConfigs = require('./container-configs');
  ScrollHandler = (function(){
    ScrollHandler.displayName = 'ScrollHandler';
    var prototype = ScrollHandler.prototype, constructor = ScrollHandler;
    importAll$(prototype, arguments[0]);
    function ScrollHandler(scope, config, debug){
      this.scope = scope;
      this.config = config;
      this.container = this.config.container;
      this.elem = this.config.elem;
      this.scrollDistance = this.config.scrollDistance;
      this.scrollEnabled = this.config.scrollEnabled;
      if (debug != null) {
        this.debugOn();
      }
      this.debugLv = parseInt(debug, 10) || 0;
      this;
    }
    prototype.handleScroll = function(){
      infoMsg("remaining", this.remaining());
      infoMsg("scroll-boundary", this.scrollBoundary());
      debug("handle scroll, should:", this.shouldScroll());
      if (this.shouldScroll()) {
        return this.scroll();
      }
    };
    prototype.isWindowContainer = function(){
      return this.container === $window;
    };
    prototype.scroll = function(){
      infoMsg("scroll");
      if (this.scrollEnabled) {
        return this.performScroll();
      } else {
        return this.enableScroll();
      }
    };
    prototype.performScroll = function(){
      infoMsg("perform scroll");
      this.configureScroll();
      return this.scope.infiniteScroll();
    };
    prototype.enableScroll = function(){
      infoMsg("enable scroll", this.config);
      return this.config.enableScroll();
    };
    prototype.configureScroll = function(){
      return infoMsg("configure-scroll, window-container:", this.isWindowContainer());
    };
    prototype.shouldScroll = function(){
      return this.remaining() <= this.scrollBoundary();
    };
    prototype.scrollBoundary = function(){
      return this.containerConfig().scrollBoundary();
    };
    prototype.remaining = function(){
      return this._remaining || (this._remaining = this.elementBottom() - this.containerBottom());
    };
    prototype.elementBottom = function(){
      return this.containerConfig().elementBottom();
    };
    prototype.containerBottom = function(){
      return this.containerConfig().containerBottom();
    };
    prototype.containerConfig = function(){
      return this._containerConfig || (this._containerConfig = this.windowContainerConfig() || this.domContainerConfig());
    };
    prototype.domContainerConfig = function(){
      return new containerConfigs.ContainerConfig(this.scrollConfigObj());
    };
    prototype.scrollConfigObj = function(){
      return {
        config: this.config,
        container: this.container,
        elem: this.elem,
        debug: this.debugging
      };
    };
    prototype.windowContainerConfig = function(){
      if (this.isWindowContainer()) {
        return this._windowContainerConfig || (this._windowContainerConfig = new containerConfigs.WindowContainerConfig(this.scrollConfigObj()));
      }
    };
    return ScrollHandler;
  }(Debugger));
  module.exports = ScrollHandler;
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);
