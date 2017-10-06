(function() {
  'use strict';

  /**
   * @description Constructor for the form course progress component
   * FieloCourseFormProgress Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloCourseFormProgress = function FieloCourseFormProgress(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloCourseFormProgress = FieloCourseFormProgress;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloCourseFormProgress.prototype.Constant_ = {
    LABEL: 'Progress',
    GET_PROGRESS: 'FieloCMSELR_ProgressBarCtlr.getCourseStatus'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCourseFormProgress.prototype.CssClasses_ = {
    PROGRESS_BAR: 'fielo-progress-bar',
    OUTPUT_TEXT: 'fielo-output__text',
    RECORD: 'fielo-record-set__template'
  };

  FieloCourseFormProgress.prototype.getRecordIds = function() {
    this.recordIds = [];
    this.records = {};
    if (this.element_.querySelector('.' + this.CssClasses_.PROGRESS_BAR)) {
      var recordId = this.element_
        .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
          .getAttribute('data-record-id');
      this.recordIds.push(recordId);
      this.records[recordId] = this.element_;
    }
  };

  FieloCourseFormProgress.prototype.updateProgress = function(results) {
    if (results) {
      if (results.length === 0) {
        [].forEach.call(this.recordIds, function(recordId) {
          this.records[recordId]
            .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
              .style.display = 'none';
        }, this);
      } else {
        var courses = [];
        [].forEach.call(results, function(result) {
          this.records[result.FieloELR__Course__c]
            .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
              .setAttribute('value', result.FieloELR__Progress__c);
          this.records[result.FieloELR__Course__c]
            .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
              .parentNode
                .querySelector('.' + this.CssClasses_.OUTPUT_TEXT)
                  .innerHTML = '<b> ' + result.FieloELR__Progress__c + '% </b>';
          courses.push(result.FieloELR__Course__c);
        }, this);
        [].forEach.call(this.recordIds, function(recordId) {
          if (courses.indexOf(recordId) === -1) {
            this.records[recordId]
              .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
                .style.display = 'none';
          }
        }, this);
      }
    }
  };

  FieloCourseFormProgress.prototype.getProgress = function() {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.GET_PROGRESS,
      this.recordIds,
      this.updateProgress.bind(this),
      {
        escape: false
      }
    );
  };

  /**
   * Inicializa el elemento
   */
  FieloCourseFormProgress.prototype.init = function() {
    if (this.element_) {
      this.getRecordIds();
      if (this.recordIds) {
        if (this.recordIds.length > 0) {
          this.getProgress();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCourseFormProgress,
    classAsString: 'FieloCourseFormProgress',
    cssClass: 'cms-elr-form-progress',
    widget: true
  });
})();
