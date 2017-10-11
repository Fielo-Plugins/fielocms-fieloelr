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
    CATEGORY_FIELD: 'fielo-field--is-FieloCMSELR_ContentCategory__c',
    LINK_TO_DETAIL: 'fielo-link__to-detail',
    OUTPUT: 'fielo-output',
    ACTION: 'cms-elr-record-action'
  };

  FieloCategoryFilter.prototype.hideCategoryField = function() {
    this.categoryElements =
      this.element_
        .querySelectorAll('.' + this.CssClasses_.CATEGORY_FIELD);
    this.categoryFields = [];
    this.categoryFormFields = [];
    [].forEach.call(this.categoryElements, function(element) {
      element.style.display = 'none';
      if (element.tagName === 'TD') {
        this.categoryFields.push(element);
      }
      if (element.tagName === 'DIV') {
        this.categoryFormFields.push(element);
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
        var actions;
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
            actions = linkToDetail.closest('tr')
              .querySelectorAll('.' + this.CssClasses_.ACTION);
            if (actions) {
              if (actions.length > 0) {
                [].forEach.call(actions, function(action) {
                  action.setAttribute('data-category-search',
                    '&categoryId=' + categoryId);
                }, this);
              }
            }
          }
        }, this);
      } else {
        this.updateActions();
      }
    } else {
      this.updateActions();
    }
  };

  FieloCategoryFilter.prototype.updateActions = function() {
    this.actions =
      this.element_
        .querySelectorAll('.' + this.CssClasses_.ACTION);
    var categoryId;
    [].forEach.call(this.actions, function(action) {
      categoryId =
        this.categoryFormFields[0]
          .querySelector('.' + this.CssClasses_.OUTPUT)
            .getAttribute(this.Constant_.DATA_VALUE);
      action.setAttribute('data-category-search',
        '&categoryId=' + categoryId);
    }, this);
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
