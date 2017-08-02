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
    GET_ACTIONS: 'ModuleActionAPI.getModuleActions',
    TAKE_MODULE: 'ModuleActionAPI.takeModule'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloModuleAction.prototype.CssClasses_ = {
    ACTION: 'cms-elr-record-action',
    RECORD: 'fielo-record-set__template'
  };

  FieloModuleAction.prototype.getRecordIds = function() {
    var records = this.element_
      .querySelectorAll('.' + this.CssClasses_.RECORD);
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
    console.log(results);
    var actions;
    if (results) {
      [].forEach.call(Object.keys(results), function(moduleId) {
        actions = results[moduleId].Actions;
        var buttons = this.records[moduleId]
          .querySelectorAll('.' + this.CssClasses_.ACTION);
        while (actions.length > buttons.length) {
          var newButton = this.records[moduleId]
          .querySelector('.' + this.CssClasses_.ACTION).cloneNode(true);
          this.records[moduleId]
          .querySelector('.' + this.CssClasses_.ACTION).closest('td')
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
      }, this);
    }
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
    console.log(result);
    console.log(String(result));
    if (result) {
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
  FieloModuleAction.prototype.init = function() {
    if (this.element_) {
      this.getRecordIds();

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
