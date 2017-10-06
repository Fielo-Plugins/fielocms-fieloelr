(function() {
  'use strict';

  /**
   * @description Constructor for the course progress component
   * FieloCourseProgress Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloCourseProgress = function FieloCourseProgress(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloCourseProgress = FieloCourseProgress;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloCourseProgress.prototype.Constant_ = {
    LABEL: 'Progress',
    PARAMETER: 'data-detail-parameter',
    RECORD_ID: 'data-record-id',
    GET_PROGRESS: 'FieloCMSELR_ProgressBarCtlr.getCourseStatus'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCourseProgress.prototype.CssClasses_ = {
    PROGRESS_FIELD: 'fielo-field--is-ProgressBar',
    PROGRESS_BAR: 'fielo-progress-bar',
    OUTPUT_TEXT: 'fielo-output__text',
    RECORD: 'fielo-record',
    RECORD_TEMPLATE: 'fielo-record-set__template',
    PAGINATOR: 'fielo-paginator',
    LINK_DETAIL: 'fielo-link__to-detail--is-InternalPage'
  };

  FieloCourseProgress.prototype.getRecordIds = function() {
    var records = this.dataLayout === 'grid' ?
      this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD) :
      this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD_TEMPLATE);
    this.recordIds = [];
    this.records = {};
    var recordId;
    [].forEach.call(records, function(record) {
      if (record.querySelector('.' + this.CssClasses_.PROGRESS_BAR)) {
        recordId = record
          .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
            .getAttribute('data-record-id');
        this.recordIds.push(recordId);
        this.records[recordId] =
          record;
      }
    }, this);

    if (this.records[this.recordIds[0]]) {
      this.oldDisplay =
        this.records[this.recordIds[0]]
          .querySelector('.' + this.CssClasses_.PROGRESS_BAR)
            .style.display;
    }
  };

  FieloCourseProgress.prototype.updateProgress = function(results) {
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

  FieloCourseProgress.prototype.getProgress = function() {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.GET_PROGRESS,
      this.recordIds,
      this.updateProgress.bind(this),
      {
        escape: false
      }
    );
  };

  FieloCourseProgress.prototype.parseQueryString = function(query) {
    var vars = query.split('&');
    var queryString = {};
    [].forEach.call(vars, function(param) {
      var pair = param.split('=');
      // If first entry with this name
      if (typeof queryString[pair[0]] === 'undefined') {
        queryString[pair[0]] = decodeURIComponent(pair[1]);
        // If second entry with this name
      } else if (typeof queryString[pair[0]] === 'string') {
        var arr = [queryString[pair[0]], decodeURIComponent(pair[1])];
        queryString[pair[0]] = arr;
        // If third or later entry with this name
      } else {
        queryString[pair[0]].push(decodeURIComponent(pair[1]));
      }
    }, this);
    return queryString;
  };

  FieloCourseProgress.prototype.progressPaginatorCallback = function() {
    var records = this.element_
      .querySelectorAll('.' + this.CssClasses_.RECORD);

    var recordIds = [];
    var recordId;
    var linkToDetail;
    var progressElement;
    [].forEach.call(records, function(record) {
      linkToDetail = record
        .querySelector('.' + this.CssClasses_.LINK_DETAIL);
      if (linkToDetail) {
        recordId = this.parseQueryString(linkToDetail.href)[
          linkToDetail.getAttribute(this.Constant_.PARAMETER)];
        progressElement = record
          .querySelector('.' + this.CssClasses_.PROGRESS_BAR);
        progressElement.setAttribute(this.Constant_.RECORD_ID,
          recordId);
        recordIds.push(recordId);
      }
    }, this);

    if (recordIds.length > 0) {
      this.getRecordIds();
      this.getProgress();
    }
  };

  FieloCourseProgress.prototype.registerCallback = function() {
    var p = this.element_.querySelector('.' + this.CssClasses_.PAGINATOR);
    if (p) {
      p.FieloPaginator.callback(this.progressPaginatorCallback.bind(this));
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloCourseProgress.prototype.init = function() {
    if (this.element_) {
      this.dataLayout =
        this.element_.getAttribute('data-layout');

      if (this.dataLayout === 'table') {
        if (this.element_
          .querySelector('.' + this.CssClasses_.PROGRESS_FIELD)) {
          this.header = this.element_
            .querySelector('.' + this.CssClasses_.PROGRESS_FIELD);
          this.header.innerHTML = this.Constant_.LABEL;
        }
      }

      this.getRecordIds();

      if (this.recordIds) {
        if (this.recordIds.length > 0) {
          this.getProgress();

          if (!this.callbackRegistered) {
            this.registerCallback();
            this.callbackRegistered = true;
          }
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCourseProgress,
    classAsString: 'FieloCourseProgress',
    cssClass: 'cms-elr-list-progress',
    widget: true
  });
})();
