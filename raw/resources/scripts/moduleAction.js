(function() {
  'use strict';

  /**
   * @description Constructor for the login form
   * FieloModuleAction Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Alejandro Spinelli <alejandro.spinelli@fielo.com>
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
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
    FIELD_VALUE: 'fielo-field__value'
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
      recordId = record
        .querySelector('.' + this.CssClasses_.ACTION)
          .getAttribute('data-record-id');
      this.recordIds.push(recordId);
      this.records[recordId] =
        record;
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
                if (results[moduleId].PageId) {
                  buttons[actions.indexOf(action)]
                    .href = 'FieloCMS__Page?pageId=' +
                      results[moduleId].PageId +
                        '&id=' + results[moduleId].ModuleResponseId;
                }
              }
            }
          }, this);
          if (results[moduleId].Approved) {
            this.addStatusField(this.records[moduleId],
              FrontEndJSSettings.LABELS.Approved, // eslint-disable-line no-undef
              'cms-elr-icon__approved'
            );
          } else {
            this.addStatusField(this.records[moduleId],
              FrontEndJSSettings.LABELS.NotApproved, // eslint-disable-line no-undef
              'cms-elr-icon__notapproved');
          }
        }
      }, this);
    }
  };

  FieloModuleAction.prototype.addStatusField = function(record, label, statusCss) { // eslint-disable-line max-len
    var newButton;
    if (this.dataLayout === 'grid') {
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
            FrontEndJSSettings.LABELS.ApprovedLabel; // eslint-disable-line no-undef

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
    } else {
      var td = record
        .querySelector('.' + this.CssClasses_.IS_ACTION);
      var newTd = td.cloneNode(true);
      var tdIndex = [].indexOf.call(td.parentNode.cells, td);
      var th = td.closest('table')
        .querySelector('thead')
          .querySelector('tr').cells[tdIndex];
      var newTh = th.cloneNode(true);

      if (!this.hasApprovedHeader) {
        th.parentNode.insertBefore(newTh, th);
        this.hasApprovedHeader = true;
        newTh.innerHTML =
          FrontEndJSSettings.LABELS.ApprovedLabel; // eslint-disable-line no-undef
      }
      td.parentNode.insertBefore(newTd, td);

      while (newTd.firstChild) {
        newTd.removeChild(newTd.firstChild);
      }

      newButton = document.createElement('div');
      newButton.setAttribute('title', label);
      this.addClass(newButton, statusCss);
      newTd.appendChild(newButton);
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
        this.records[result.module.Id]
          .FieloRecord.link_ + '#' +
          result.moduleResponse.Id;
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

  /**
   * Inicializa el elemento
   */
  FieloModuleAction.prototype.init = function() {
    if (this.element_) {
      this.dataLayout =
        this.element_.getAttribute('data-layout');
      this.getRecordIds();
      this.getComponentId();
      this.getActions();
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
