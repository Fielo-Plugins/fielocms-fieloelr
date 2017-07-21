(function() {
  'use strict';

  /**
   * @description Constructor for the login form
   * FieloPaginatorFilter Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Alejandro Spinelli <alejandro.spinelli@fielo.com>
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloPaginatorFilter = function FieloPaginatorFilter(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloPaginatorFilter = FieloPaginatorFilter;

  // Properties

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloPaginatorFilter.prototype.CssClasses_ = {
    PAGINATOR: 'fielo-paginator'
  };

  FieloPaginatorFilter.prototype.getParameter = function(paramName) {
    var query = window.location.search.substring(1);
    var vars = query.split('&');
    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split('=');
      if (pair[0] === paramName) {
        return pair[1];
      }
    }
    console.log('Query parameter ' + paramName + ' not found');
  };

  /**
   * Inicializa el elemento
   */
  FieloPaginatorFilter.prototype.init = function() {
    if (this.element_) {
      this.paginator = this.element_
        .querySelector('.' + this.CssClasses_.PAGINATOR);
      if (this.paginator.FieloPaginator) {
        var id = this.getParameter('id');
        var filter = {};
        filter.id = // eslint-disable-line camelcase
          id;
        this.paginator.FieloPaginator.setFilters(filter);
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloPaginatorFilter,
    classAsString: 'FieloPaginatorFilter',
    cssClass: 'cms-elr-paginator-filter',
    widget: true
  });
})();
