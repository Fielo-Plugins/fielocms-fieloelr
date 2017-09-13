(function() {
  'use strict';

  /**
   * @description Constructor for the login form
   * FieloQuestionResponseList Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Alejandro Spinelli <alejandro.spinelli@fielo.com>
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloQuestionResponseList = function FieloQuestionResponseList(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloQuestionResponseList = FieloQuestionResponseList;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloQuestionResponseList.prototype.Constant_ = {
    GET_ACTIONS: 'ActionsAPI.getCourseActions',
    JOIN_COURSE: 'ActionsAPI.joinCourse'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloQuestionResponseList.prototype.CssClasses_ = {
    HIDDEN_TABLE: 'cms-elr-hidden-table',
    TABLE: 'fielo-table',
    LOOKUP_FIELD: 'fielo-field--is-FieloELR__Question__c',
    FIELO_OUTPUT: 'fielo-output',
    RECORD: 'fielo-record-set__template'
  };

  FieloQuestionResponseList.prototype.getAnswers = function() {
    this.tables = {};

    var tables = this.element_
      .querySelector('.' + this.CssClasses_.HIDDEN_TABLE)
        .querySelectorAll('.' + this.CssClasses_.TABLE);

    [].forEach.call(tables, function(table) {
      this.tables[table.getAttribute('data-question-id')] = [];
      var rows = table.querySelectorAll('tr');
      [].forEach.call(rows, function(row) {
        this.tables[table.getAttribute('data-question-id')].push(
          row.cloneNode(true)
          );
      }, this);
    }, this);
  };

  FieloQuestionResponseList.prototype.toggleAnswers = function(event) {
    event.preventDefault();
    var row = event.srcElement.closest('tr');
    var questionId = event.srcElement
      .closest('.' + this.CssClasses_.FIELO_OUTPUT)
        .getAttribute('data-value');
    var toggle = true;

    if (!this.activeQuestionId) {
      this.activeQuestionId = '';
    }

    if (this.activeQuestionId === questionId) {
      if (this.activeAnswers.length > 0) {
        [].forEach.call(this.activeAnswers, function(answerRow) {
          answerRow.parentNode.removeChild(answerRow);
        }, this);
        this.activeAnswers = [];
        toggle = false;
      }
    } else if (this.activeAnswers) {
      if (this.activeAnswers.length > 0) {
        [].forEach.call(this.activeAnswers, function(answerRow) {
          answerRow.parentNode.removeChild(answerRow);
        }, this);
        this.activeAnswers = [];
      }
    } else {
      this.activeAnswers = [];
    }
    if (toggle) {
      var nextRow = row.nextSibling;
      [].forEach.call(this.tables[questionId], function(tableRow) {
        var newRow = tableRow.cloneNode(true);
        row.parentNode.insertBefore(newRow, nextRow);
        this.activeAnswers.push(newRow);
      }, this);
      this.activeQuestionId = questionId;
    }
  };

  FieloQuestionResponseList.prototype.initLinks = function() {
    var ancors = this.element_
      .querySelectorAll('.' + this.CssClasses_.LOOKUP_FIELD);

    [].forEach.call(ancors, function(ancor) {
      if (ancor.querySelector('a')) {
        ancor.querySelector('a').addEventListener('click',
          this.toggleAnswers.bind(this)
          );
      }
    }, this);
  };

  /**
   * Inicializa el elemento
   */
  FieloQuestionResponseList.prototype.init = function() {
    if (this.element_) {
      this.getAnswers();
      this.initLinks();
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloQuestionResponseList,
    classAsString: 'FieloQuestionResponseList',
    cssClass: 'cms-elr-question-response-list',
    widget: true
  });
})();
