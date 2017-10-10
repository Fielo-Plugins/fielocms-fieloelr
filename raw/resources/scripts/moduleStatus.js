(function() {
  'use strict';

  /**
   * @description Constructor for module status component
   * FieloModuleStatus Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Tiago Bittencourt Leal
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloModuleStatus = function FieloModuleStatus(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloModuleStatus = FieloModuleStatus;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloModuleStatus.prototype.Constant_ = {
    GET_STATUS: 'FieloCMSELR_ModuleStatusCtrl.getModuleStatus',
    SUBCOMPONENT: 'data-subcomponent-apiname'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloModuleStatus.prototype.CssClasses_ = {
    RECORD_TEMPLATE: 'fielo-record-set__template',
    STATUS: 'cms-elr-module-status',
    RECORD: 'fielo-record',
    RECORD_SET: 'fielo-record-set',
    DETAIL: 'fielo-detail',
    PAGINATOR: 'fielo-paginator',
    PASSED: 'cms-elr-icon__approved',
    NOT_PASSED: 'cms-elr-icon__notapproved'
  };

  FieloModuleStatus.prototype.getRecordIds = function() {
    if (this.dataLayout === 'grid') {
      this.recordSet = this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD);
    } else if (this.dataLayout === 'table') {
      this.recordSet = this.element_
        .querySelectorAll('.' + this.CssClasses_.RECORD_TEMPLATE);
    } else if (this.dataLayout === 'form') {
      this.recordSet = [];
      this.recordSet.push(this.element_);
    }
    this.recordIds = [];
    this.records = {};
    var recordId;
    [].forEach.call(this.recordSet, function(record) {
      if (record.querySelector('.' + this.CssClasses_.STATUS)) {
        recordId = record
          .querySelector('.' + this.CssClasses_.STATUS)
            .getAttribute('data-record-id');
        this.recordIds.push(recordId);
        this.records[recordId] =
          record;
      }
    }, this);
  };

  FieloModuleStatus.prototype.updateStatus = function(results) {
    if (results) {
      var statusElement;
      [].forEach.call(Object.keys(results), function(moduleId) {
        if (results[moduleId] === 'Passed' ||
          results[moduleId] === 'Not Passed') {
          statusElement = this.records[moduleId]
            .querySelector('.' + this.CssClasses_.STATUS);
          statusElement.style.display = null;
          statusElement.classList.add(results[moduleId] === 'Passed' ?
            this.CssClasses_.PASSED :
            this.CssClasses_.NOT_PASSED);
          statusElement.title = results[moduleId] === 'Passed' ?
            FrontEndJSSettings.LABELS.Passed : // eslint-disable-line no-undef
            FrontEndJSSettings.LABELS.NotPassed; // eslint-disable-line no-undef
        }
      }, this);
    }
  };

  FieloModuleStatus.prototype.getStatus = function() {
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.GET_STATUS,
      this.componentId,
      this.recordIds,
      this.updateStatus.bind(this),
      {
        escape: false
      }
    );
  };

  FieloModuleStatus.prototype.getComponentId = function() {
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

  FieloModuleStatus.prototype.setLabel = function() {
    if (this.recordSet) {
      if (this.dataLayout !== 'form') {
        var firstStatus = this.recordSet[0]
          .querySelector('.' + this.CssClasses_.STATUS);
        var subComponentApiName =
          firstStatus.getAttribute(this.Constant_.SUBCOMPONENT);
        this.element_
          .querySelector('th.fielo-field--is-' + subComponentApiName)
            .innerHTML =
              FrontEndJSSettings.LABELS.Passed; // eslint-disable-line no-undef
      }
    }
  };

  /**
   * Inicializa el elemento
   */
  FieloModuleStatus.prototype.init = function() {
    if (this.element_) {
      this.componentType = '';
      if ([].indexOf.call(
          this.element_.classList, this.CssClasses_.RECORD_SET) !== -1) {
        this.componentType = 'list';
      } else if ([].indexOf.call(
          this.element_.classList, this.CssClasses_.DETAIL) !== -1) {
        this.componentType = 'detail';
      }
      if (this.componentType === '') {
        console.log('Error: Unsuported type, ' +
          'expected fielo-record-set or fielo-record-set, ' +
          'got: ' +
          [].join.call(this.element_.classList, ','));
      } else {
        if (this.componentType === 'list') {
          this.dataLayout =
            this.element_.getAttribute('data-layout');
        } else {
          this.dataLayout = 'form';
        }
        this.getRecordIds();
        if (this.recordIds) {
          if (this.recordIds.length > 0) {
            this.getComponentId();
            this.setLabel();
            this.getStatus();
          }
        }
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloModuleStatus,
    classAsString: 'FieloModuleStatus',
    cssClass: 'cms-elr-module-list-status',
    widget: true
  });
})();
