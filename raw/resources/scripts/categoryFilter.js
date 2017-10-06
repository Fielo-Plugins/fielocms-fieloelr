(function() {
  'use strict';

  /**
   * @description Constructor for paginatior filter
   * FieloCategoryFilter Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloCategoryFilter = function FieloCategoryFilter(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloCategoryFilter = FieloCategoryFilter;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloCategoryFilter.prototype.Constant_ = {
    DATA_VALUE: 'data-value'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCategoryFilter.prototype.CssClasses_ = {
    CATEGORY_FIELD: 'fielo-field--is-FieloCMSELR_Category__c',
    LINK_TO_DETAIL: 'fielo-link__to-detail',
    OUTPUT: 'fielo-output'
  };

  FieloCategoryFilter.prototype.hideCategoryField = function() {
    this.categoryElements =
      this.element_
        .querySelectorAll('.' + this.CssClasses_.CATEGORY_FIELD);
    this.categoryFields = [];
    [].forEach.call(this.categoryElements, function(element) {
      element.style.display = 'none';
      if (element.tagName === 'TD') {
        this.categoryFields.push(element);
      }
    }, this);
  };

  FieloCategoryFilter.prototype.getLinkToDetail = function() {
    this.linkToDetailFields =
      this.element_
        .querySelectorAll('.' + this.CssClasses_.LINK_TO_DETAIL);
  };

  FieloCategoryFilter.prototype.updateLinkToDetail = function() {
    if (this.linkToDetailFields) {
      if (this.linkToDetailFields.length > 0) {
        var href;
        var categoryId;
        [].forEach.call(this.linkToDetailFields, function(linkToDetail) {
          href = linkToDetail.href;
          categoryId =
            this.categoryFields[
              [].indexOf.call(this.linkToDetailFields, linkToDetail)]
              .querySelector('.' + this.CssClasses_.OUTPUT)
                .getAttribute(this.Constant_.DATA_VALUE);
          if (categoryId !== undefined &&
            categoryId !== null &&
            categoryId !== '') {
            href += '&categoryId=' + categoryId;
            linkToDetail.href = href;
          }
        }, this);
      }
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloCategoryFilter.prototype.init = function() {
    if (this.element_) {
      this.hideCategoryField();
      if (this.categoryElements) {
        if (this.categoryElements.length > 0) {
          this.getLinkToDetail();
          this.updateLinkToDetail();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCategoryFilter,
    classAsString: 'FieloCategoryFilter',
    cssClass: 'cms-elr-category-filter',
    widget: true
  });
})();
