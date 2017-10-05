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
    SUBMIT_METHOD: 'FieloCMSELR_QuizCtlr.submitQuestion',
    SUBMIT_MODULE: 'FieloCMSELR_QuizCtlr.submitModuleResponse',
    QUESTION_NUMBER: 'cms-elr-question-number',
    QUESTION_TEXT: 'cms-elr-question-text',
    DETAIL_PARAMETER: 'data-detail-parameter'
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
    SINGLECHOICE_FORM: 'cms-elr-singlechoice-answer__form',
    SINGLECHOICE_INPUT: 'cms-elr-answer-input',
    SHORTANSWER: 'cms-elr-shortanswer-answer',
    SHORTANSWER_ITEM: 'cms-elr-shortanswer-answer__item',
    MATCHING: 'cms-elr-matching-answer',
    MATCHING_ITEM: 'cms-elr-matching-answer__item',
    MATCHING_OPTION: 'cms-elr-matching-answer__option',
    MATCHING_MATCHES: 'cms-elr-matching-answer__matches',
    MATCHING_SELECT: 'cms-elr-matching-answer__match-selector',
    MATCHING_SELECT_OPTION: 'cms-elr-matching-answer__match-option',
    SUBMIT: 'fielo-button__submit',
    INPUT: 'cms-elr-answer-input',
    OUTPUT: 'fielo-output'
  };

  FieloQuiz.prototype.getData = function(name) {
    var result = localStorage.getItem(name);
    var resultObject = JSON.parse(result);
    this.dataStructure = resultObject;
    this.deleteData(name);
  };

  FieloQuiz.prototype.deleteData = function(name) {
    localStorage.removeItem(name);
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
    } else if (this.currentQuestion.FieloELR__Type__c === 'Matching Options') {
      this.initMatchingOption();
    }
    fieloUtils.spinner.FieloSpinner.hide(); // eslint-disable-line no-undef
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
        .querySelector('.' + this.CssClasses_.OUTPUT)
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
        .querySelector(
          '.' + this.CssClasses_.SINGLECHOICE_FORM)
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
      answerOptions[answers.indexOf(answer)]
        .querySelector('.' + this.CssClasses_.INPUT)
          .value = answer.Id;
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

  FieloQuiz.prototype.initMatchingOption = function() {
    var answerOptionsContainer =
      this.element_.querySelector(
        '.' + this.CssClasses_.MATCHING).cloneNode(true);
    var answers =
      this.currentQuestion.FieloELR__AnswerOptions__r;
    var matchingText = [];
    [].forEach.call(answers, function(answer) {
      if (answer.FieloELR__MatchingText__c !== undefined ||
        answer.FieloELR__MatchingText__c !== null ||
        answer.FieloELR__MatchingText__c !== '') {
        if (matchingText.indexOf(answer.FieloELR__MatchingText__c) === -1) {
          matchingText.push(answer.FieloELR__MatchingText__c);
        }
      }
    }, this);
    var answerOptions =
      answerOptionsContainer
        .querySelectorAll(
          '.' + this.CssClasses_.MATCHING_ITEM);
    var answerOptionSelectContainer =
      answerOptions[0]
        .querySelector(
          '.' + this.CssClasses_.MATCHING_SELECT);
    var answerOptionSelect =
      answerOptions[0]
        .querySelectorAll(
          '.' + this.CssClasses_.MATCHING_SELECT_OPTION);
    while (answerOptionSelect.length <=
        matchingText.length) {
      answerOptionSelectContainer
        .appendChild(answerOptionSelect[0].cloneNode());
      answerOptionSelect =
        answerOptions[0]
          .querySelectorAll(
            '.' + this.CssClasses_.MATCHING_SELECT_OPTION);
    }
    answerOptionSelect[0]
      .innerHTML = FrontEndJSSettings.LABELS.SelectAnOption; // eslint-disable-line no-undef
    answerOptionSelect[0]
      .setAttribute('value', FrontEndJSSettings.LABELS.SelectAnOption); // eslint-disable-line no-undef
    [].forEach.call(matchingText, function(text) {
      answerOptionSelect[matchingText.indexOf(text) + 1]
        .innerHTML = text;
      answerOptionSelect[matchingText.indexOf(text) + 1]
        .setAttribute('value', text);
    }, this);
    while (answerOptions.length <
        this.currentQuestion.FieloELR__AnswerOptions__r.length) {
      answerOptionsContainer
        .appendChild(answerOptions[0].cloneNode(true));
      answerOptions =
        answerOptionsContainer
          .querySelectorAll(
            '.' + this.CssClasses_.MATCHING_ITEM);
    }

    [].forEach.call(answers,
    function(answer) {
      var answerText = answer.FieloELR__AnswerOptionText__c ?
            answer.FieloELR__AnswerOptionText__c :
            '';
      if (answerText === '') {
        answerOptions[answers.indexOf(answer)]
          .parentNode
            .removeChild(
              answerOptions[answers.indexOf(answer)]);
      } else {
        answerOptions[answers.indexOf(answer)]
          .querySelector('.fielo-output')
            .innerHTML = answerText + '&nbsp;';
        answerOptions[answers.indexOf(answer)]
          .setAttribute('data-record-id',
            answer.Id);
      }
    }, this);
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
      this.submitButton =
        this.element_.querySelector(
          '.' + this.CssClasses_.SUBMIT).cloneNode(true);
      this.element_
        .querySelector('.' + this.CssClasses_.BUTTON_CONTAINER)
          .appendChild(this.submitButton);
      this.submitButton.addEventListener('click',
        this.submitQuestion.bind(this));
      this.hasEventListener = true;
    }
  };

  FieloQuiz.prototype.submitQuestion = function() {
    fieloUtils.spinner.FieloSpinner.show(); // eslint-disable-line no-undef
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

  FieloQuiz.prototype.showMessage = function(message, redirect, time) {
    fieloUtils.message.FieloMessage.clear(); // eslint-disable-line no-undef
    fieloUtils.message.FieloMessage.addMessages( // eslint-disable-line no-undef
    fieloUtils.site.FieloSite.getLabel( // eslint-disable-line no-undef
      message)
    );
    fieloUtils.message.FieloMessage.setRedirect(redirect, time); // eslint-disable-line no-undef
    fieloUtils.message.FieloMessage.show(); // eslint-disable-line no-undef
  };

  FieloQuiz.prototype.submitCallback = function(result) {
    try {
      if (result) {
        if (result.questionResponse) {
          if (result.questionResponse.FieloELR__IsCorrect__c === true) {
            this.currentQuestionNumber++;
            if (this.currentQuestionNumber <
                this.dataStructure.questions.length) {
              this.loadQuestion(this.currentQuestionNumber);
            } else {
              this.submitModule();
            }
          } else if (this.currentQuestionNumber <
              this.dataStructure.questions.length) {
            if (result.canRepeatQuestion) {
              this.showMessage(FrontEndJSSettings.LABELS.WrongAnswer, '#', 3); // eslint-disable-line no-undef
              this.loadQuestion(this.currentQuestionNumber);
            } else {
              this.showMessage(FrontEndJSSettings.LABELS.MaximumAttempts, '#'); // eslint-disable-line no-undef
              this.currentQuestionNumber++;
              if (this.currentQuestionNumber <
              this.dataStructure.questions.length) {
                this.loadQuestion(this.currentQuestionNumber);
              } else {
                this.submitModule();
              }
            }
          } else {
            this.submitModule();
          }
        }
      }
    } catch (e) {
      console.log(e);
    }
  };

  FieloQuiz.prototype.submitModule = function() {
    fieloUtils.spinner.FieloSpinner.show(); // eslint-disable-line no-undef
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

  FieloQuiz.prototype.submitModuleCallback = function() {
    this.clearQuestion();
    this.questionText.innerHTML =
      '';
    this.submitButton.style.visibility = 'hidden';
    this.element_.querySelector(
      '.' + this.CssClasses_.TITLE)
        .style.visibility = 'hidden';
    fieloUtils.spinner.FieloSpinner.hide(); // eslint-disable-line no-undef
    this.showMessage(
      FrontEndJSSettings.LABELS.ModuleFinished, // eslint-disable-line no-undef
        this.redirectURL, 3);
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
    } else if (this.currentQuestion.FieloELR__Type__c === 'Matching Options') {
      this.answers =
        this.getMatchingOptionsAnswers();
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

  FieloQuiz.prototype.getMatchingOptionsAnswers = function() {
    var answersContainer =
      this.element_
        .querySelector(
          '.' + this.CssClasses_.ANSWER_CONTAINER);
    var answerOptions =
      answersContainer
        .querySelectorAll(
          '.' + this.CssClasses_.MATCHING_ITEM);
    var answers = [];
    var answer;
    var textValue;
    [].forEach.call(answerOptions, function(answerOption) {
      answer = {};
      answer.FieloELR__AnswerOption__c = // eslint-disable-line camelcase
        answerOption.getAttribute('data-record-id');
      textValue =
        answerOption
          .querySelector(
            '.' + this.CssClasses_.MATCHING_MATCHES)
            .querySelector(
              '.' + this.CssClasses_.MATCHING_SELECT)
              .value;
      answer.FieloELR__TextValue__c = // eslint-disable-line camelcase
        textValue === FrontEndJSSettings.LABELS.SelectAnOption ? // eslint-disable-line no-undef
          '' :
          textValue;
      answers.push(answer);
    }, this);
    return answers;
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
    this.widgetLabel =
      this.element_.querySelector('h3');
    this.questionNumberLabel =
      this.element_.querySelector(
        '#' + this.Constant_.QUESTION_NUMBER);
    this.questionText =
      this.element_.querySelector(
        '#' + this.Constant_.QUESTION_TEXT);
    this.detailParameter =
      this.element_.getAttribute(
        this.Constant_.DETAIL_PARAMETER);
    this.detailParameter =
      this.detailParameter ?
      this.detailParameter :
      'id';
    this.redirectURL =
      '/FieloCMS__Page?pageId=' +
        this.element_.getAttribute('data-redirect-page') +
          '&' + this.detailParameter + '=' + this.moduleResponseId;
  };

  /**
   * Inicializa el elemento
   */
  FieloQuiz.prototype.init = function() {
    if (this.element_) {
      this.getModuleResponseId();
      this.getElements();
      if (this.moduleResponseId !== '' &&
        this.moduleResponseId !== undefined &&
        this.moduleResponseId !== null) {
        this.getData(this.moduleResponseId);
        if (this.dataStructure) {
          if (this.dataStructure.questions) {
            if (this.dataStructure.questions.length > 0) {
              this.widgetLabel
                .style.display = null;
              this.currentQuestionNumber = 0;
              this.loadQuestion(this.currentQuestionNumber);
            }
          }
        }
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
