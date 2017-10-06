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
              buttons[actions.indexOf(action)].innerHTML = action;
              buttons[actions.indexOf(action)].href = '#';
              buttons[actions.indexOf(action)]
                  .addEventListener('click', this.takeModule.bind(this));
            } else if (action === 'Hide' || action === 'View') {
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
          }, this);
          if (results[moduleId].Approved) {
            this.addStatusField(this.records[moduleId],
              FrontEndJSSettings.LABELS.Passed, // eslint-disable-line no-undef
              'cms-elr-icon__approved'
            );
          } else {
            this.addStatusField(this.records[moduleId],
              FrontEndJSSettings.LABELS.NotPassed, // eslint-disable-line no-undef
              'cms-elr-icon__notapproved');
          }
        }
      }, this);
    }
  };

  FieloModuleFormAction.prototype.addStatusField = function(record, label, statusCss) { // eslint-disable-line max-len
    var newButton;
    var field = record
      .querySelector('.' + this.CssClasses_.IS_ACTION);
    var newField = field.cloneNode(true);
    var newFieldLabel = newField
      .querySelector('.' + this.CssClasses_.FIELD_LABEL);

    if (!newFieldLabel) {
      newFieldLabel = document.createElement('span');
      this.addClass(newFieldLabel, this.CssClasses_.FIELD_LABEL);
      newField.insertBefore(newFieldLabel, newField.firstChild);
    }

    newFieldLabel.innerHTML =
          FrontEndJSSettings.LABELS.Passed; // eslint-disable-line no-undef

    var newFieldValue = newField
      .querySelector('.' + this.CssClasses_.FIELD_VALUE);
    while (newFieldValue.firstChild) {
      newFieldValue.removeChild(newFieldValue.firstChild);
    }
    newButton = document.createElement('div');
    newButton.setAttribute('title', label);
    this.addClass(newButton, statusCss);
    newFieldValue.appendChild(newButton);
    field.parentNode.insertBefore(newField, field);
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
      window.location.href =
        this.recordHrefs[result.module.Id].takeHref +
          '#' + result.moduleResponse.Id;
      window.location.reload();
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
    this.recordHrefs = {};
    [].forEach.call(Object.keys(this.records), function(recordId) {
      action = this.records[recordId]
        .querySelector('.' + this.CssClasses_.ACTION);
      this.recordHrefs[recordId] = {};
      this.recordHrefs[recordId].takeHref =
        '/FieloCMS__Page?pageId=' +
          action.getAttribute('data-take-redirect-page') +
            '&' + action.getAttribute('data-take-parameter') +
              '=' + action.getAttribute('data-record-id');
      this.recordHrefs[recordId].viewHref =
        '/FieloCMS__Page?pageId=' +
          action.getAttribute('data-view-redirect-page') +
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
