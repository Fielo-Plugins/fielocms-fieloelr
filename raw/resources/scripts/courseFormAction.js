(function() {
  'use strict';

  /**
   * @description Constructor for the form course action component
   * FieloCourseFormAction Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloCourseFormAction = function FieloCourseFormAction(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloCourseFormAction = FieloCourseFormAction;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloCourseFormAction.prototype.Constant_ = {
    GET_ACTIONS: 'FieloCMSELR_CourseActionCtlr.getCourseActions',
    JOIN_COURSE: 'FieloCMSELR_CourseActionCtlr.joinCourse'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCourseFormAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD: 'fielo-record-set__template'
  };

  FieloCourseFormAction.prototype.getRecordIds = function() {
    this.recordIds = [];
    this.records = {};
    if (this.element_.querySelector('.' + this.CssClasses_.ACTION)) {
      var recordId = this.element_
        .querySelector('.' + this.CssClasses_.ACTION)
          .getAttribute('data-record-id');
      this.recordIds.push(recordId);
      this.records[recordId] = this.element_;
    }
  };

  FieloCourseFormAction.prototype.updateAction = function(results) {
    if (results) {
      [].forEach.call(Object.keys(results), function(courseId) {
        this.records[courseId]
          .querySelector('.' + this.CssClasses_.ACTION)
            .innerHTML = results[courseId].Action;
        if (results[courseId].Action === 'View' ||
          results[courseId].Action === 'Continue' ||
          results[courseId].Action === 'Hide') {
          this.records[courseId]
            .querySelector('.' + this.CssClasses_.ACTION)
              .style.display = 'none';
        } else {
          this.records[courseId]
            .querySelector('.' + this.CssClasses_.ACTION)
              .href = '#';
          this.records[courseId]
            .querySelector('.' + this.CssClasses_.ACTION)
              .addEventListener('click', this.joinCourse.bind(this));
        }
      }, this);
    }
  };

  FieloCourseFormAction.prototype.joinCourse = function(event) {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.JOIN_COURSE,
      event.srcElement.getAttribute('data-record-id'),
      this.joinCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloCourseFormAction.prototype.joinCallback = function(result) {
    if (result) {
      window.location.href =
        this.recordHrefs[result.FieloELR__Course__c].joinHref;
    }
  };

  FieloCourseFormAction.prototype.getActions = function() {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.GET_ACTIONS,
      this.element_.getAttribute('data-componentid'),
      this.recordIds,
      this.updateAction.bind(this),
      {
        escape: false
      }
    );
  };

  FieloCourseFormAction.prototype.getURLs = function() {
    var action;
    var categorySearch;
    this.pathPrefix = '';
    if (FrontEndJSSettings) { // eslint-disable-line no-undef
      if (FrontEndJSSettings.SITE) { // eslint-disable-line no-undef
        if (FrontEndJSSettings.SITE.pathPrefix) { // eslint-disable-line no-undef
          this.pathPrefix = FrontEndJSSettings.SITE.pathPrefix; // eslint-disable-line no-undef
        }
      }
    }
    this.recordHrefs = {};
    [].forEach.call(Object.keys(this.records), function(recordId) {
      action = this.records[recordId]
        .querySelector('.' + this.CssClasses_.ACTION);
      categorySearch = action.getAttribute('data-category-search') ?
        action.getAttribute('data-category-search') :
        '';
      this.recordHrefs[recordId] = {};
      this.recordHrefs[recordId].joinHref =
        this.pathPrefix +
          '/FieloCMS__Page?' +
            action.getAttribute('data-page-field') + '=' +
              action.getAttribute('data-join-redirect-page') +
                categorySearch +
                  '&' + action.getAttribute('data-join-parameter') +
                    '=' + action.getAttribute('data-record-id');
    }, this);
  };

  /**
   * Inicializa el elemento
   */
  FieloCourseFormAction.prototype.init = function() {
    if (this.element_) {
      this.getRecordIds();

      if (this.recordIds) {
        if (this.recordIds.length > 0) {
          this.getURLs();
          this.getActions();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCourseFormAction,
    classAsString: 'FieloCourseFormAction',
    cssClass: 'cms-elr-form-action--course',
    widget: true
  });
})();
