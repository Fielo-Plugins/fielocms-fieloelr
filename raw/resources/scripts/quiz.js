(function() {
  'use strict';

  /**
   * @description Constructor for the login form
   * FieloQuiz Implements design patterns defined by MDL at
   * {@link https://github.com/jasonmayes/mdl-component-design-pattern}
   *
   * @version 1
   * @author Alejandro Spinelli <alejandro.spinelli@fielo.com>
   * @author Hugo Gómez Mac Gregor <hugo.gomez@fielo.com>
   * @param {HTMLElement} element - Element to be upgraded
   * @constructor
   */
  var FieloQuiz = function FieloQuiz(element) {
    this.element_ = element;

    // Initialize instance.
    this.init();
  };
  window.FieloQuiz = FieloQuiz;

  // Properties
  /**
   * Guarda las constantes en un lugar para que sean facilmente actualizadas
   * @enum {string | number}
   * @private
   */
  FieloQuiz.prototype.Constant_ = {
    SUBMIT_METHOD: 'QuizAPI.submitQuestion',
    SUBMIT_MODULE: 'QuizAPI.submitModuleResponse',
    QUESTION_NUMBER: 'cms-elr-question-number',
    QUESTION_TEXT: 'cms-elr-question-text'
  };

  /**
   * Css name classes
   *
   * @enum {string}
   * @private
   */
  FieloQuiz.prototype.CssClasses_ = {
    TITLE: 'fielo-title',
    ANSWER_CONTAINER: 'cms-elr-answers-container',
    BUTTON_CONTAINER: 'cms-elr-buttons-container',
    MULTIPLECHOICE: 'cms-elr-multiplechoice-answer',
    MULTIPLECHOICE_ITEM: 'cms-elr-multiplechoice-answer__item',
    SINGLECHOICE: 'cms-elr-singlechoice-answer',
    SINGLECHOICE_ITEM: 'cms-elr-singlechoice-answer__item',
    SHORTANSWER: 'cms-elr-shortanswer-answer',
    SHORTANSWER_ITEM: 'cms-elr-shortanswer-answer__item',
    SUBMIT: 'fielo-button__submit',
    INPUT: 'cms-elr-answer-input'
  };

  FieloQuiz.prototype.getCookie = function(name) {
    var result = document.cookie.match(
      new RegExp(name + '=([^;]+)'));
    var resultObject = JSON.parse(result[1]);
    this.dataStructure = resultObject;
  };

  FieloQuiz.prototype.deleteCookie = function(name) {
    document.cookie = [name,
      '=; expires=Thu, 01-Jan-1970 00:00:01 GMT; path=/; domain=.',
      window.location.host.toString()
    ].join('');
  };

  FieloQuiz.prototype.getModuleResponseId = function() {
    var hash = window.location.hash;
    if (hash) {
      this.moduleResponseId = hash.replace('#', '');
    }
  };

  FieloQuiz.prototype.loadQuestion = function(questionNumber) {
    this.clearQuestion();
    this.currentQuestion =
      this.dataStructure.questions[questionNumber];
    this.questionNumberLabel.innerHTML =
      questionNumber + 1;
    this.questionText.innerHTML =
      this.currentQuestion.FieloELR__QuestionText__c;
    if (this.currentQuestion.FieloELR__Type__c === 'Multiple Choice') {
      this.initMultipleChoice();
    } else if (this.currentQuestion.FieloELR__Type__c === 'Single Choice' ||
      this.currentQuestion.FieloELR__Type__c === 'Statement') {
      this.initSingleChoice();
    } else if (this.currentQuestion.FieloELR__Type__c === 'Short Answer') {
      this.initShortAnswer();
    }
  };

  FieloQuiz.prototype.initMultipleChoice = function() {
    var answerOptionsContainer =
      this.element_.querySelector(
        '.' + this.CssClasses_.MULTIPLECHOICE).cloneNode(true);
    var answerOptions =
      answerOptionsContainer
        .querySelectorAll(
          '.' + this.CssClasses_.MULTIPLECHOICE_ITEM);
    while (answerOptions.length <
        this.currentQuestion.FieloELR__AnswerOptions__r.length) {
      answerOptionsContainer
        .appendChild(answerOptions[0].cloneNode(true));
      answerOptions =
        answerOptionsContainer
          .querySelectorAll(
            '.' + this.CssClasses_.MULTIPLECHOICE_ITEM);
    }
    var answers =
      this.currentQuestion.FieloELR__AnswerOptions__r;
    [].forEach.call(answers,
    function(answer) {
      answerOptions[answers.indexOf(answer)]
        .querySelector('.fielo-output')
          .innerHTML = answer.FieloELR__AnswerOptionText__c;
      answerOptions[answers.indexOf(answer)]
        .setAttribute('data-record-id',
          answer.Id);
    }, this);
    this.element_
      .querySelector('.' + this.CssClasses_.ANSWER_CONTAINER)
        .appendChild(answerOptionsContainer);
    this.addSubmitButton();
  };

  FieloQuiz.prototype.initSingleChoice = function() {
    var answerOptionsContainer =
      this.element_.querySelector(
        '.' + this.CssClasses_.SINGLECHOICE).cloneNode(true);
    var answerOptions =
      answerOptionsContainer
        .querySelectorAll(
          '.' + this.CssClasses_.SINGLECHOICE_ITEM);
    while (answerOptions.length <
        this.currentQuestion.FieloELR__AnswerOptions__r.length) {
      answerOptionsContainer
        .appendChild(answerOptions[0].cloneNode(true));
      answerOptions =
        answerOptionsContainer
          .querySelectorAll(
            '.' + this.CssClasses_.SINGLECHOICE_ITEM);
    }
    var answers =
      this.currentQuestion.FieloELR__AnswerOptions__r;
    [].forEach.call(answers,
    function(answer) {
      answerOptions[answers.indexOf(answer)]
        .querySelector('.fielo-output')
          .innerHTML = answer.FieloELR__AnswerOptionText__c;
      answerOptions[answers.indexOf(answer)]
        .setAttribute('data-record-id',
          answer.Id);
    }, this);
    this.element_
      .querySelector('.' + this.CssClasses_.ANSWER_CONTAINER)
        .appendChild(answerOptionsContainer);
    this.addSubmitButton();
  };

  FieloQuiz.prototype.initShortAnswer = function() {
    var answerOptionsContainer =
      this.element_.querySelector(
        '.' + this.CssClasses_.SHORTANSWER).cloneNode(true);
    this.element_
      .querySelector('.' + this.CssClasses_.ANSWER_CONTAINER)
        .appendChild(answerOptionsContainer);
    this.addSubmitButton();
  };

  FieloQuiz.prototype.clearQuestion = function() {
    this.questionText.innerHTML = '';
    var answersContainer = this.element_
      .querySelector('.' + this.CssClasses_.ANSWER_CONTAINER);
    while (answersContainer.firstChild) {
      answersContainer.removeChild(answersContainer.firstChild);
    }
  };

  FieloQuiz.prototype.addSubmitButton = function() {
    if (!this.hasEventListener) {
      var submitButton =
        this.element_.querySelector(
          '.' + this.CssClasses_.SUBMIT).cloneNode(true);
      this.element_
        .querySelector('.' + this.CssClasses_.BUTTON_CONTAINER)
          .appendChild(submitButton);
      submitButton.addEventListener('click',
        this.submitQuestion.bind(this));
      this.hasEventListener = true;
    }
  };

  FieloQuiz.prototype.submitQuestion = function() {
    this.getQuestionResponseWrapper();
    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.SUBMIT_METHOD,
      this.questionResponseWrapper,
      this.submitCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloQuiz.prototype.submitCallback = function(result) {
    console.log(result);
    if (result) {
      if (result.questionResponse) {
        if (result.questionResponse.FieloELR__IsCorrect__c === true) {
          this.currentQuestionNumber++;
          if (this.currentQuestionNumber < this.dataStructure.questions.length) {
            this.loadQuestion(this.currentQuestionNumber);
          } else {
            this.submitModule();
          }
        }
      }
    }
  };

  FieloQuiz.prototype.submitModule = function() {
    this.clearQuestion();
    this.moduleResponse = {};
    this.moduleResponse.Id = this.moduleResponseId;

    Visualforce.remoting.Manager.invokeAction( // eslint-disable-line no-undef
      this.Constant_.SUBMIT_MODULE,
      this.moduleResponse,
      this.submitModuleCallback.bind(this),
      {
        escape: false
      }
    );
  };

  FieloQuiz.prototype.submitModuleCallback = function(result) {
    console.log(result);
    this.clearQuestion();
    this.questionText.innerHTML =
      'Module Finished.';// JSON.stringify(result);
  };

  FieloQuiz.prototype.getQuestionResponseWrapper = function() {
    this.questionResponseWrapper = {};
    this.questionResponse = {};
    this.questionResponse.FieloELR__ModuleResponse__c = // eslint-disable-line camelcase
      this.moduleResponseId;
    this.questionResponse.FieloELR__Question__c = // eslint-disable-line camelcase
      this.currentQuestion.Id;

    if (this.currentQuestion.FieloELR__Type__c === 'Multiple Choice' ||
      this.currentQuestion.FieloELR__Type__c === 'Single Choice' ||
      this.currentQuestion.FieloELR__Type__c === 'Statement') {
      this.answers = // eslint-disable-line camelcase
        this.getFlagAnswers();
    } else if (this.currentQuestion.FieloELR__Type__c === 'Short Answer') {
      this.questionResponse.FieloELR__TextValue__c = // eslint-disable-line camelcase
        this.getShortAnswer();
      this.answers = [];
    }

    this.question = Object.assign({}, this.currentQuestion);

    delete this.question.FieloELR__AnswerOptions__r;

    this.questionResponseWrapper.questionResponse =
      this.questionResponse;
    this.questionResponseWrapper.answers =
      this.answers;
    this.questionResponseWrapper.question =
      this.question;
  };

  FieloQuiz.prototype.getFlagAnswers = function() {
    var answersContainer =
      this.element_
        .querySelector(
          '.' + this.CssClasses_.ANSWER_CONTAINER);
    var answerInputs =
      answersContainer
        .querySelectorAll(
          '.' + this.CssClasses_.INPUT);
    var answers = [];
    var answer = {};
    [].forEach.call(answerInputs, function(input) {
      if (input.checked === true) {
        answer = {};
        answer.FieloELR__AnswerOption__c = // eslint-disable-line camelcase
          input.closest('li')
            .getAttribute('data-record-id');
        answers.push(answer);
      }
    }, this);
    return answers;
  };

  FieloQuiz.prototype.getShortAnswer = function() {
    var answersContainer =
      this.element_
        .querySelector(
          '.' + this.CssClasses_.ANSWER_CONTAINER);
    var answerInput =
      answersContainer
        .querySelector(
          '.' + this.CssClasses_.INPUT);
    return answerInput.value;
  };

  FieloQuiz.prototype.getElements = function() {
    this.questionNumberLabel =
      this.element_.querySelector(
        '#' + this.Constant_.QUESTION_NUMBER);
    this.questionText =
      this.element_.querySelector(
        '#' + this.Constant_.QUESTION_TEXT);
  };

  /**
   * Inicializa el elemento
   */
  FieloQuiz.prototype.init = function() {
    if (this.element_) {
      this.getModuleResponseId();
      this.getElements();
      if (this.moduleResponseId !== '') {
        this.getCookie(this.moduleResponseId);
        this.currentQuestionNumber = 0;
        this.loadQuestion(this.currentQuestionNumber);
      }
    }
  };

  // El componente se registra por si solo.
  // Asume que el componentHandler esta habilitado en el scope global
  componentHandler.register({ // eslint-disable-line no-undef
    constructor: FieloQuiz,
    classAsString: 'FieloQuiz',
    cssClass: 'cms-elr-quiz',
    widget: true
  });
})();
