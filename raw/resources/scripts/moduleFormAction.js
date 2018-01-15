(function() {
  'use strict';

  /**
   * @description Constructor for the form module action component
   * FieloModuleFormAction Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloModuleFormAction = function FieloModuleFormAction(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloModuleFormAction = FieloModuleFormAction;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloModuleFormAction.prototype.Constant_ = {
    GET_ACTIONS: 'FieloCMSELR_ModuleActionCtlr.getModuleActions',
    TAKE_MODULE: 'FieloCMSELR_ModuleActionCtlr.takeModule'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloModuleFormAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD_TEMPLATE: 'fielo-record-set__template',
    RECORD: 'fielo-record',
    IS_ACTION: 'fielo-field--is-ModuleAction',
    PAGINATOR: 'fielo-paginator',
    FIELD_LABEL: 'fielo-field__label',
    FIELD_VALUE: 'fielo-field__value',
    QUIZ: 'cms-elr-quiz',
    DISABLED: 'disabled'
  };

  FieloModuleFormAction.prototype.getRecordIds = function() {
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

  FieloModuleFormAction.prototype.hasRunningQuiz = function() {
    this.quizIsRunning = false;
    var quizObject = document
      .querySelector('.' + this.CssClasses_.QUIZ);
    if (quizObject) {
      if (quizObject.FieloQuiz) {
        if (quizObject.FieloQuiz.isRunning) {
          this.quizIsRunning = quizObject.FieloQuiz.isRunning;
        }
      }
    }
  };

  FieloModuleFormAction.prototype.updateAction = function(results) {
    var actions;
    var model;
    var newButton;
    if (results) {
      [].forEach.call(Object.keys(results), function(moduleId) {
        if (this.records[moduleId]) {
          actions = results[moduleId].Actions;
          var buttons = this.records[moduleId]
            .querySelectorAll('.' + this.CssClasses_.ACTION);
          model = this.records[moduleId]
            .querySelector('.' + this.CssClasses_.ACTION).cloneNode(true);
          while (actions.length > buttons.length) {
            newButton = model.cloneNode(true);
            this.records[moduleId]
              .querySelector('.' + this.CssClasses_.ACTION)
                .closest('.' + this.CssClasses_.FIELD_VALUE)
                  .appendChild(newButton);
            buttons = this.records[moduleId]
              .querySelectorAll('.' + this.CssClasses_.ACTION);
          }
          [].forEach.call(actions, function(action) {
            if (action === 'Take' || action === 'Retake') {
              if (this.quizIsRunning) {
                buttons[actions.indexOf(action)]
                  .style.visibility = 'hidden';
              } else {
                buttons[actions.indexOf(action)].innerHTML = action;
                buttons[actions.indexOf(action)].href = '#';
                buttons[actions.indexOf(action)]
                    .addEventListener('click', this.takeModule.bind(this));
              }
            } else if (action === 'Hide') {
              [].forEach.call(buttons, function(button) {
                button.style.visibility = 'hidden';
                if (action === 'Hide') {
                  this.addClass(
                    button.closest('.' + this.CssClasses_.RECORD)
                      , this.CssClasses_.DISABLED);
                }
              }, this);
            } else {
              buttons[actions.indexOf(action)]
                .innerHTML = action;
              buttons[actions.indexOf(action)]
                .href = this.records[moduleId].FieloRecord.link_;
            }
            if (action === 'View') {
              if (this.quizIsRunning) {
                buttons[actions.indexOf(action)]
                  .style.display = 'none';
              } else if (results[moduleId].ModuleResponseId) {
                buttons[actions.indexOf(action)]
                  .setAttribute('data-module-response-id',
                    results[moduleId].ModuleResponseId);
                buttons[actions.indexOf(action)]
                  .href = this.recordHrefs[moduleId].viewHref +
                    results[moduleId].ModuleResponseId;
              }
            }
          }, this);
        }
      }, this);
    }
  };

  FieloModuleFormAction.prototype.addClass = function(element, className) {
    var classString = element.className;
    var newClass = classString.concat(' ' + className);
    element.className = newClass;
  };

  FieloModuleFormAction.prototype.takeModule = function(event) {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.TAKE_MODULE,
      event.srcElement.getAttribute('data-record-id'),
      this.takeCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloModuleFormAction.prototype.takeCallback = function(result) {
    if (result) {
      localStorage.clear();
      this.storeData(result.moduleResponse.Id, result);
      var reloadPage =
        window.location.href
          .indexOf(this.recordHrefs[result.module.Id].takeHref) !== -1;
      window.location.href =
        this.recordHrefs[result.module.Id].takeHref +
          '#' + result.moduleResponse.Id;
      if (reloadPage) {
        window.location.reload();
      }
    }
  };

  FieloModuleFormAction.prototype.storeData = function(name, value) {
    localStorage.setItem(name, JSON.stringify(value));
  };

  FieloModuleFormAction.prototype.getActions = function() {
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

  FieloModuleFormAction.prototype.getComponentId = function() {
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

  FieloModuleFormAction.prototype.getURLs = function() {
    var action;
    var categorySearch;
    this.recordHrefs = {};
    this.pathPrefix = '';
    if (FrontEndJSSettings) { // eslint-disable-line no-undef
      if (FrontEndJSSettings.SITE) { // eslint-disable-line no-undef
        if (FrontEndJSSettings.SITE.pathPrefix) { // eslint-disable-line no-undef
          this.pathPrefix = FrontEndJSSettings.SITE.pathPrefix; // eslint-disable-line no-undef
        }
      }
    }
    [].forEach.call(Object.keys(this.records), function(recordId) {
      action = this.records[recordId]
        .querySelector('.' + this.CssClasses_.ACTION);
      categorySearch = action.getAttribute('data-category-search') ?
        action.getAttribute('data-category-search') :
        '';
      this.recordHrefs[recordId] = {};
      this.recordHrefs[recordId].takeHref =
        this.pathPrefix +
          '/FieloCMS__Page?' +
            action.getAttribute('data-take-redirect-page-field') + '=' +
              action.getAttribute('data-take-redirect-page') +
                categorySearch +
                  '&' + action.getAttribute('data-take-parameter') +
                    '=' + action.getAttribute('data-record-id');
      this.recordHrefs[recordId].viewHref =
        this.pathPrefix +
          '/FieloCMS__Page?' +
            action.getAttribute('data-view-redirect-page-field') + '=' +
              action.getAttribute('data-view-redirect-page') +
                categorySearch +
                  '&' + action.getAttribute('data-view-parameter') +
                    '=';
    }, this);
  };

  /**
   * Inicializa el elemento
   */
  FieloModuleFormAction.prototype.init = function() {
    if (this.element_) {
      this.getRecordIds();
      if (this.recordIds) {
        if (this.recordIds.length > 0) {
          this.getComponentId();
          this.getURLs();
          this.hasRunningQuiz();
          this.getActions();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloModuleFormAction,
    classAsString: 'FieloModuleFormAction',
    cssClass: 'cms-elr-form-action--module',
    widget: true
  });
})();
