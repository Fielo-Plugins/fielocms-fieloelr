(function() {
  'use strict';

  /**
   * @description Constructor for the login form
   * FieloCourseAction Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Alejandro Spinelli <alejandro.spinelli@fielo.com>
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloCourseAction = function FieloCourseAction(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloCourseAction = FieloCourseAction;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloCourseAction.prototype.Constant_ = {
    GET_ACTIONS: 'FieloCMSELR_CourseActionCtlr.getCourseActions',
    JOIN_COURSE: 'FieloCMSELR_CourseActionCtlr.joinCourse'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCourseAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD: 'fielo-record-set__template'
  };

  FieloCourseAction.prototype.getRecordIds = function() {
    this.recordIds = [];
    this.records = {};
    var recordId = this.element_
      .querySelector('.' + this.CssClasses_.ACTION)
        .getAttribute('data-record-id');
    this.recordIds.push(recordId);
    this.records[recordId] = this.element_;
  };

  FieloCourseAction.prototype.updateAction = function(results) {
    console.log(results);
    if (results) {
      [].forEach.call(Object.keys(results), function(courseId) {
        this.records[courseId]
          .querySelector('.' + this.CssClasses_.ACTION)
            .innerHTML = results[courseId].Action;
        if (results[courseId].Action === 'View' ||
          results[courseId].Action === 'Continue') {
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

  FieloCourseAction.prototype.joinCourse = function(event) {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.JOIN_COURSE,
      event.srcElement.getAttribute('data-record-id'),
      this.joinCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloCourseAction.prototype.joinCallback = function(result) {
    console.log(result);
    if (result) {
      window.location.reload();
    }
  };

  FieloCourseAction.prototype.getActions = function() {
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

  /**
   * Inicializa el elemento
   */
  FieloCourseAction.prototype.init = function() {
    if (this.element_) {
      this.getRecordIds();

      this.getActions();
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCourseAction,
    classAsString: 'FieloCourseFormAction',
    cssClass: 'cms-elr-form-action',
    widget: true
  });
})();
