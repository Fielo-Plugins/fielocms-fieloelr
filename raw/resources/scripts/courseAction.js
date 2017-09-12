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
    PARAMETER: 'data-detail-parameter',
    RECORD_ID: 'data-record-id',
    GET_ACTIONS: 'FieloCMSELR_CourseActionCtlr.getCourseActions',
    JOIN_COURSE: 'FieloCMSELR_CourseActionCtlr.joinCourse',
    COMPONENT_NAME: 'data-component-name'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloCourseAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD_TEMPLATE: 'fielo-record-set__template',
    RECORD: 'fielo-record',
    PAGINATOR: 'fielo-paginator',
    LINK_DETAIL: 'fielo-link__to-detail--is-InternalPage'
  };

  FieloCourseAction.prototype.getRecordIds = function() {
    var records = this.dataLayout === 'grid' ?
      this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD) :
        this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD_TEMPLATE);
    this.recordIds = [];
    this.records = {};
    var recordId;
    [].forEach.call(records, function(record) {
      recordId = record
        .querySelector('.' + this.CssClasses_.ACTION)
          .getAttribute('data-record-id');
      this.recordIds.push(recordId);
      this.records[recordId] = record;
    }, this);
  };

  FieloCourseAction.prototype.updateAction = function(results) {
    if (results) {
      [].forEach.call(Object.keys(results), function(courseId) {
        this.records[courseId]
          .querySelector('.' + this.CssClasses_.ACTION)
            .innerHTML = results[courseId].Action;
        if (results[courseId].Action === 'View' ||
          results[courseId].Action === 'Continue') {
          this.records[courseId]
            .querySelector('.' + this.CssClasses_.ACTION)
              .href = this.records[courseId].FieloRecord.link_ ?
                this.records[courseId].FieloRecord.link_ :
                results[courseId].Page;
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
    if (result) {
      window.location.href =
        this.records[result.FieloELR__Course__c]
          .FieloRecord.link_;
    }
  };

  FieloCourseAction.prototype.getActions = function() {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.GET_ACTIONS,
      this.componentId,
      this.recordIds,
      this.updateAction.bind(this),
      {
        escape: false
      }
    );
  };

  FieloCourseAction.prototype.getComponentId = function() {
    if (this.dataLayout === 'grid') {
      this.componentId =
        this.element_
          .querySelector('.' + this.CssClasses_.PAGINATOR)
            .getAttribute('data-component-id');
    } else {
      this.componentId =
        this.element_.getAttribute('data-componentid');
    }
  };

  FieloCourseAction.prototype.parseQueryString = function(query) {
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

  FieloCourseAction.prototype.courseActionPaginatorCallback = function() {
    var records = this.element_
      .querySelectorAll('.' + this.CssClasses_.RECORD);

    var recordIds = [];
    var recordId;
    var linkToDetail;
    var actionElement;
    [].forEach.call(records, function(record) {
      linkToDetail = record
        .querySelector('.' + this.CssClasses_.LINK_DETAIL);
      if (linkToDetail) {
        recordId = this.parseQueryString(linkToDetail.href)[
          linkToDetail.getAttribute(this.Constant_.PARAMETER)];
        actionElement = record
          .querySelector('.' + this.CssClasses_.ACTION);
        actionElement.setAttribute(this.Constant_.RECORD_ID,
          recordId);
        recordIds.push(recordId);
      }
    }, this);

    if (recordIds.length > 0) {
      this.getRecordIds();
      this.getActions();
    }
  };

  FieloCourseAction.prototype.courseActionPaginatorCb = function(records) {
    var renderedRecords = this.element_
      .querySelectorAll('.' + this.CssClasses_.RECORD);

    var recordIds = [];
    var recordId;
    var actionElement;
    [].forEach.call(records, function(record) {
      recordId = this.componentName === 'course-status' ?
        record.FieloELR__Course__c :
        record.Id;
      actionElement = renderedRecords[records.indexOf(record)]
        .querySelector('.' + this.CssClasses_.ACTION);
      actionElement.setAttribute(this.Constant_.RECORD_ID,
        recordId);
      recordIds.push(recordId);
    }, this);

    if (recordIds.length > 0) {
      this.getRecordIds();
      this.getActions();
    }
  };

  FieloCourseAction.prototype.registerCallback = function() {
    var p = this.element_.querySelector('.' + this.CssClasses_.PAGINATOR);
    if (p) {
      p.FieloPaginator.callback(this.courseActionPaginatorCb.bind(this));
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloCourseAction.prototype.init = function() {
    if (this.element_) {
      this.dataLayout =
        this.element_.getAttribute('data-layout');
      this.componentName =
        this.element_.getAttribute(this.Constant_.COMPONENT_NAME);
      this.getRecordIds();
      this.getComponentId();
      this.getActions();

      if (!this.callbackRegistered) {
        this.registerCallback();
        this.callbackRegistered = true;
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloCourseAction,
    classAsString: 'FieloCourseAction',
    cssClass: 'cms-elr-list-action',
    widget: true
  });
})();
