(function() {
  'use strict';

  /**
   * @description Constructor for module action component
   * FieloModuleAction Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloModuleAction = function FieloModuleAction(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloModuleAction = FieloModuleAction;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloModuleAction.prototype.Constant_ = {
    GET_ACTIONS: 'FieloCMSELR_ModuleActionCtlr.getModuleActions',
    TAKE_MODULE: 'FieloCMSELR_ModuleActionCtlr.takeModule'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloModuleAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD_TEMPLATE: 'fielo-record-set__template',
    RECORD: 'fielo-record',
    IS_ACTION: 'fielo-field--is-ModuleAction',
    PAGINATOR: 'fielo-paginator',
    FIELD_LABEL: 'fielo-field__label',
    FIELD_VALUE: 'fielo-field__value',
    DISABLED: 'disabled'
  };

  FieloModuleAction.prototype.getRecordIds = function() {
    var records = this.dataLayout === 'grid' ?
      this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD) :
        this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD_TEMPLATE);
    this.recordIds = [];
    this.records = {};
    var recordId;
    [].forEach.call(records, function(record) {
      if (record.querySelector('.' + this.CssClasses_.ACTION)) {
        recordId = record
          .querySelector('.' + this.CssClasses_.ACTION)
            .getAttribute('data-record-id');
        this.recordIds.push(recordId);
        this.records[recordId] =
          record;
      }
    }, this);
  };

  FieloModuleAction.prototype.updateAction = function(results) {
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
            if (this.dataLayout === 'grid') {
              this.records[moduleId]
                .querySelector('.' + this.CssClasses_.ACTION).closest('span')
                  .appendChild(newButton);
            } else {
              this.records[moduleId]
                .querySelector('.' + this.CssClasses_.ACTION).closest('td')
                  .appendChild(newButton);
            }
            buttons = this.records[moduleId]
            .querySelectorAll('.' + this.CssClasses_.ACTION);
          }
          [].forEach.call(actions, function(action) {
            if (action === 'Take' || action === 'Retake') {
              buttons[actions.indexOf(action)].innerHTML = action;
              buttons[actions.indexOf(action)].href = '#';
              buttons[actions.indexOf(action)]
                  .addEventListener('click', this.takeModule.bind(this));
            } else if (action === 'Hide') {
              [].forEach.call(buttons, function(button) {
                button.style.visibility = 'hidden';
                this.addClass(
                  button.closest('.' + this.CssClasses_.RECORD)
                    , this.CssClasses_.DISABLED);
              }, this);
            } else {
              buttons[actions.indexOf(action)]
                .innerHTML = action;
              buttons[actions.indexOf(action)]
                .href = this.records[moduleId].FieloRecord.link_;
            }
            if (action === 'View') {
              if (results[moduleId].ModuleResponseId) {
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

  FieloModuleAction.prototype.addClass = function(element, className) {
    var classString = element.className;
    var newClass = classString.concat(' ' + className);
    element.className = newClass;
  };

  FieloModuleAction.prototype.takeModule = function(event) {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.TAKE_MODULE,
      event.srcElement.getAttribute('data-record-id'),
      this.takeCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloModuleAction.prototype.takeCallback = function(result) {
    if (result) {
      localStorage.clear();
      this.storeData(result.moduleResponse.Id, result);
      window.location.href =
        this.recordHrefs[result.module.Id].takeHref +
          '#' + result.moduleResponse.Id;
    }
  };

  FieloModuleAction.prototype.storeData = function(name, value) {
    localStorage.setItem(name, JSON.stringify(value));
  };

  FieloModuleAction.prototype.getActions = function() {
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

  FieloModuleAction.prototype.getComponentId = function() {
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

  FieloModuleAction.prototype.getURLs = function() {
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
  FieloModuleAction.prototype.init = function() {
    if (this.element_) {
      this.dataLayout =
        this.element_.getAttribute('data-layout');
      this.getRecordIds();
      if (this.recordIds) {
        if (this.recordIds.length > 0) {
          this.getComponentId();
          this.getURLs();
          this.getActions();
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloModuleAction,
    classAsString: 'FieloModuleAction',
    cssClass: 'cms-elr-module-list-action',
    widget: true
  });
})();
