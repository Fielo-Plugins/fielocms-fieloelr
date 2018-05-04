@isTest
public class MockUpFactory {

    private static Map<String, Id> rtMember;
    
    public static List<FieloPLT__Program__c> createPrograms(String basename, Integer count) {
        List<FieloPLT__Program__c> results = new List<FieloPLT__Program__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Program__c p = new FieloPLT__Program__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__OnlineTransactionProcessing__c = true;
            results.add(p);
        }
        return results;
    }

    //Created for FieloPRP
    public static List<FieloPLT__Member__c> createMembers(String programId, Integer count){
        List<FieloPLT__Member__c> membersToCreate = new List<FieloPLT__Member__c>();
        for(Integer x = 0; x < count; x++){
            membersToCreate.add(new FieloPLT__Member__c(
                    Name='Member '+String.valueOf(x),
                    FieloPLT__Email__c='email'+String.valueOf(x)+'l@example.com',
                    FieloPLT__Type__c='Individual Account',
                    FieloPLT__Program__c=programId
                )
            );
        }
        return membersToCreate;
    }

    public static List<FieloELR__Course__c> createCourses(String programId, String segmentId, Integer count){
        List<FieloELR__Course__c> coursesToCreate = new List<FieloELR__Course__c>();
        for(Integer x = 0; x < count; x++){
            coursesToCreate.add(new FieloELR__Course__c(
            		Name = 'Course ' + x,
                    FieloELR__Program__c = programId,
                    FieloELR__Description__c = 'Description',
                    FieloELR__SubscriptionMode__c = 'Manual',
                    FieloELR__Segment__c = segmentId
                )
            );
        }
        return coursesToCreate;
    }

    public static List<FieloPLT__Promotion__c> createPromotions(String basename, Integer count, Id programId){
        List<FieloPLT__Promotion__c> results = new List<FieloPLT__Promotion__c>();
        for(Integer x = 0; x < count; x++){
            FieloPLT__Promotion__c p = new FieloPLT__Promotion__c();
            p.Name = basename + String.valueOf(x);
            p.FieloPLT__Program__c = programId;
            results.add(p);
        }
        return results;
    }

    public static List<FieloPLT__Segment__c> createSegments(String basename, Integer count, String type){
        List<FieloPLT__Segment__c> results = new List<FieloPLT__Segment__c>();
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName =: type].Id;
        for(Integer x = 0; x < count; x++){
            FieloPLT__Segment__c s = new FieloPLT__Segment__c();
            s.Name = basename + String.valueOf(x);
            s.RecordTypeId = rtId;
            results.add(s);
        }
        return results;
    }

    public static List<FieloELR__Question__c> createQuestions(Id moduleId, Map<String, String> questionsMap) {
        List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
        for (String questionText: questionsMap.keySet()) {
            questions.add(
                new FieloELR__Question__c(
                    Name = 'Q' + questions.size(),
                    FieloELR__QuestionText__c	 = questionText,
                    FieloELR__Type__c		 = questionsMap.get(questionText),
                    FieloELR__Module__c = moduleId
                )
            );
        }
        return questions;
    }

    public static List<FieloELR__AnswerOption__c> createAnswerOptions(Id questionId, Map<String,Boolean> answerOptionsMap, Map<String, String> matchingTextMap) {
        List<FieloELR__AnswerOption__c> answers = new List<FieloELR__AnswerOption__c>();
        for (String answerOptionText: answerOptionsMap.keySet()) {
            answers.add(
                new FieloELR__AnswerOption__c(
                    FieloELR__Question__c = questionId,
                    FieloELR__IsCorrect__c = answerOptionsMap.get(answerOptionText),
                    FieloELR__AnswerOptionText__c = answerOptionText,
                    FieloELR__MatchingText__c = matchingTextMap.containsKey(answerOptionText) ? matchingTextMap.get(answerOptionText) : null
                )
            );
        }
        return answers;
    }

    public static FieloELR__ModuleResponse__c createModuleResponses(Id moduleId, Id memberId) {
        return new FieloELR__ModuleResponse__c(FieloELR__Module__c = moduleId, FieloELR__Member__c = memberId);
    }

    public static void InsertTestData() {
        List<FieloPLT__Program__c> programs = MockUpFactory.createPrograms('Default', 2);
        insert programs;

        List<FieloPLT__Segment__c> segments = MockUpFactory.createSegments('Segment',1,'Manual');
        insert segments;

        List<FieloELR__Course__c> courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 2);
        insert courses;

        List<FieloPLT__Member__c> members = MockUpFactory.createMembers(programs.get(0).id, 1);
        members.addAll(MockUpFactory.createMembers(programs.get(1).id, 1));
        members.addAll(MockUpFactory.createMembers(programs.get(0).id, 1));
        insert members;

        FieloPLT__MemberSegment__c memberSegment = new FieloPLT__MemberSegment__c(
            FieloPLT__Segment__c = segments.get(0).Id,
            FieloPLT__Member__c = members.get(0).Id
        );
        insert memberSegment;

        List<FieloELR__Module__c> modules = new List<FieloELR__Module__c> { 
            new FieloELR__Module__c(
                Name = 'Basic',
                FieloELR__Course__c = courses.get(0).id,
                FieloELR__ApprovalGrade__c = 50,
                FieloELR__AttemptsAllowed__c = 2,
                FieloELR__AttemptsAllowedPerQuestion__c = 1
            ),
            new FieloELR__Module__c(
                Name = 'Intermediate',
                FieloELR__Course__c = courses.get(0).id,
                FieloELR__ApprovalGrade__c = 70,
                FieloELR__AttemptsAllowed__c = 2,
                FieloELR__AttemptsAllowedPerQuestion__c = 1
            ),
            new FieloELR__Module__c(
                Name = 'Basic 2',
                FieloELR__Course__c = courses.get(1).id,
                FieloELR__ApprovalGrade__c = 70,
                FieloELR__AttemptsAllowed__c = 2,
                FieloELR__AttemptsAllowedPerQuestion__c = 1
            )
        };
        insert modules;

        FieloELR__ModuleDependency__c moduleDependency = new FieloELR__ModuleDependency__c(
            FieloELR__Module__c = modules.get(1).Id,
            FieloELR__Predecessor__c	 = modules.get(0).Id
        );
        insert moduleDependency;

        //Question
        Map<String, String> questionsMap = new Map<String, String>{
            'Which one is the MOST popular programming language?' => 'Single Choice',
            'Select all Family-C programming languages?' => 'Multiple Choice',
            'Acronym for Personal Computer' => 'Short Answer',
            'C++ is more performatic then Java' => 'Statement',
            'Match statement with its meaning' => 'Matching Options'
        };

        List<FieloELR__Question__c> questions = createQuestions(modules.get(0).Id, questionsMap);

        questions.addAll(createQuestions(modules.get(2).Id, questionsMap));

        questionsMap = new Map<String, String>{
            'Which one is the LEAST popular programming language?' => 'Single Choice',
            'Select all loop statements' => 'Multiple Choice',
            'What is the smallest piece of information in Computing' => 'Short Answer',
            'One byte consists of 8 bits' => 'Statement',
            'Match Company with it\'s product' => 'Matching Options'
        };

        questions.addAll(createQuestions(modules.get(1).Id, questionsMap));

        insert questions;
        
        List<FieloELR__AnswerOption__c> answersOptions = new List<FieloELR__AnswerOption__c>();

        for (FieloELR__Question__c q: questions){
            if ((q.FieloELR__Module__c == modules.get(0).Id || q.FieloELR__Module__c == modules.get(2).Id) && q.FieloELR__Type__c		 == 'Single Choice') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'Java' => false,
                            'PHP' => false,
                            'SQL' => false,
                            'Javascript' => true,
                            'C++' => false,
                            'HTML' => false
                        },
                        new Map<String, String>()
                    )
                );
            }
            if ((q.FieloELR__Module__c == modules.get(0).Id || q.FieloELR__Module__c == modules.get(2).Id) && q.FieloELR__Type__c		 == 'Multiple Choice') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'Java' => true,
                            'C++' => true,
                            'PHP' => true,
                            'Python' => false,
                            'Objective-C' => true
                        },
                        new Map<String, String>()
                    )
                );
            }
            if ((q.FieloELR__Module__c == modules.get(0).Id || q.FieloELR__Module__c == modules.get(2).Id) && q.FieloELR__Type__c		 == 'Short Answer') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'pc' => true,
                            'PC' => true
                        },
                        new Map<String, String>()
                    )
                );
            }
            if ((q.FieloELR__Module__c == modules.get(0).Id || q.FieloELR__Module__c == modules.get(2).Id) && q.FieloELR__Type__c		 == 'Statement') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'True' => true,
                            'False' => false
                        },
                        new Map<String, String>()
                    )
                );
            }
            if ((q.FieloELR__Module__c == modules.get(0).Id || q.FieloELR__Module__c == modules.get(2).Id) && q.FieloELR__Type__c		 == 'Matching Options') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'if' => true,
                            'for' => true,
                            'while' => true,
                            'break' => true,
                            'new' => true
                        },
                        new Map<String, String> {
                            'if' => 'conditional',
                            'for' => 'loop',
                            'while' => 'loop',
                            'break' => 'exit loop',
                            'new' => 'create instance'
                        }
                    )
                );
            }
            if (q.FieloELR__Module__c == modules.get(1).Id && q.FieloELR__Type__c		 == 'Single Choice') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'Javascript' => false,
                            'C++' => false,
                            'PHP' => false,
                            'HTML' => false,
                            'Haskell' => true,
                            'Groovy' => false
                        },
                        new Map<String, String>()
                    )
                );
            }
            if (q.FieloELR__Module__c == modules.get(1).Id && q.FieloELR__Type__c		 == 'Multiple Choice') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'if' => false,
                            'for' => true,
                            'while' => true,
                            'new' => false,
                            'do {...} while' => true
                        },
                        new Map<String, String>()
                    )
                );
            }
            if (q.FieloELR__Module__c == modules.get(1).Id && q.FieloELR__Type__c		 == 'Short Answer') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'Bit' => true,
                            'BIT' => true,
                            'bit' => true
                        },
                        new Map<String, String>()
                    )
                );
            }
            if (q.FieloELR__Module__c == modules.get(1).Id && q.FieloELR__Type__c		 == 'Statement') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'True' => true,
                            'False' => false
                        },
                        new Map<String, String>()
                    )
                );
            }
            if (q.FieloELR__Module__c == modules.get(1).Id && q.FieloELR__Type__c		 == 'Matching Options') {
                answersOptions.addAll(
                    createAnswerOptions(q.Id,
                        new Map<String, Boolean> {
                            'Apple' => true,
                            'Microsoft' => true,
                            'Ubisoft' => true,
                            'Google' => true,
                            'Mozzila' => true
                        },
                        new Map<String, String> {
                            'Apple' => 'Mac OS',
                            'Microsoft' => 'Windows',
                            'Ubisoft' => 'Unreal Tournament Game',
                            'Google' => 'Chrome',
                            'Mozzila' => 'Firefox'
                        }
                    )
                );
            }
        }
        insert answersOptions;
    }

    public static void activateCourse() {
        Map<Id, FieloELR__Module__c> modulesMap = new Map<Id, FieloELR__Module__c>();
        List<FieloELR__ModuleDependency__c> moduleDependencies = [SELECT Id, FieloELR__Module__r.FieloELR__Course__r.Id, FieloELR__Module__r.Id, FieloELR__Module__r.Name, FieloELR__Predecessor__r.Id, FieloELR__Predecessor__r.Name FROM FieloELR__ModuleDependency__c];
        List<FieloELR__Module__c> modules = [SELECT Id FROM FieloELR__Module__c];

        for (FieloELR__ModuleDependency__c md:moduleDependencies) {
            if (!modulesMap.containsKey(md.FieloELR__Predecessor__r.Id)) {
                md.FieloELR__Predecessor__r.FieloELR__IsActive__c = true;
                modulesMap.put(md.FieloELR__Predecessor__r.Id, md.FieloELR__Predecessor__r);
            }
            if (!modulesMap.containsKey(md.FieloELR__Module__r.Id)) {
                md.FieloELR__Module__r.FieloELR__IsActive__c = true;
                modulesMap.put(md.FieloELR__Module__r.Id, md.FieloELR__Module__r);
            }
        }
        for (FieloELR__Module__c module:modules) {
            if (!modulesMap.containsKey(module.Id)) {
                module.FieloELR__IsActive__c = true;
                modulesMap.put(module.Id, module);
            }
        }

        update modulesMap.values();

        Map<Id, FieloELR__Course__c> courses = new Map<Id, FieloELR__Course__c>([SELECT Id FROM FieloELR__Course__c]);

        //FieloELR.CourseService.activateCourses(courses.keySet());
    }

    public static void inactivateCourse() {
        Map<Id, FieloELR__Module__c> modulesMap = new Map<Id, FieloELR__Module__c>();
        List<FieloELR__ModuleDependency__c> moduleDependencies = [SELECT Id, FieloELR__Module__r.FieloELR__Course__r.Id, FieloELR__Module__r.Id, FieloELR__Module__r.Name, FieloELR__Predecessor__r.Id, FieloELR__Predecessor__r.Name FROM FieloELR__ModuleDependency__c];
        List<FieloELR__Module__c> modules = [SELECT Id FROM FieloELR__Module__c];

        for (FieloELR__ModuleDependency__c md:moduleDependencies) {
            if (!modulesMap.containsKey(md.FieloELR__Module__r.Id)) {
                md.FieloELR__Module__r.FieloELR__IsActive__c = false;
                modulesMap.put(md.FieloELR__Module__r.Id, md.FieloELR__Module__r);
            }
            if (!modulesMap.containsKey(md.FieloELR__Predecessor__r.Id)) {
                md.FieloELR__Predecessor__r.FieloELR__IsActive__c = false;
                modulesMap.put(md.FieloELR__Predecessor__r.Id, md.FieloELR__Predecessor__r);
            }
        }
        for (FieloELR__Module__c module:modules) {
            if (!modulesMap.containsKey(module.Id)) {
                module.FieloELR__IsActive__c = false;
                modulesMap.put(module.Id, module);
            }
        }

        Map<Id, FieloELR__Course__c> courses = new Map<Id, FieloELR__Course__c>([SELECT Id FROM FieloELR__Course__c]);

        // FieloELR.CourseService.inactivateCourses(courses.keySet());

        update modulesMap.values();
    }

    public static void answerModuleCorrectly(FieloELR.ModuleService.moduleWrapper moduleWrapper) {
        List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();
        List<FieloELR__Answer__c> answers = new List<FieloELR__Answer__c>();

        for (FieloELR__Question__c question: moduleWrapper.questions) {
            questionResponses.add(
                new FieloELR__QuestionResponse__c(
                    FieloELR__ModuleResponse__c = moduleWrapper.moduleresponse.Id,
                    FieloELR__Question__c = question.Id
                )
            );
        }
        insert questionResponses;

        Map<Id, FieloELR__Question__c> questionMap = new Map<Id, FieloELR__Question__c>([SELECT Id, FieloELR__Type__c		, (SELECT Id, FieloELR__AnswerOptionText__c, FieloELR__MatchingText__c, FieloELR__IsCorrect__c FROM FieloELR__AnswerOptions__r) FROM FieloELR__Question__c WHERE Id in : new Map<Id,FieloELR__Question__c>(moduleWrapper.questions).keySet()]);
        List<FieloELR__QuestionResponse__c> needUpdate = new List<FieloELR__QuestionResponse__c>();

        for (FieloELR__QuestionResponse__c qr: questionResponses) {
            for (FieloELR__AnswerOption__c ao: questionMap.get(qr.FieloELR__Question__c).FieloELR__AnswerOptions__r) {
                if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Short Answer') {
                    if (ao.FieloELR__IsCorrect__c) {
                        qr.FieloELR__TextValue__c = ao.FieloELR__AnswerOptionText__c;
                        needUpdate.add(qr);
                        break;
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Single Choice' || questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Statement') {
                    if (ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id
                            )
                        );
                        break;
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Multiple Choice') {
                    if (ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id
                            )
                        );
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Matching Options') {
                    if (ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id,
                                FieloELR__TextValue__c = ao.FieloELR__MatchingText__c
                            )
                        );
                    }
                }
            }
        }
        if (!needUpdate.isEmpty()) {
            update needUpdate;
        }

        insert answers;

        update new FieloELR__ModuleResponse__c(
            Id = moduleWrapper.moduleresponse.Id,
            FieloELR__IsSubmitted__c = true
        );

        System.debug(JSON.serializePretty(questionResponses));
        System.debug(JSON.serializePretty(answers));
    }

    public static void answerModuleIncorrectly(FieloELR.ModuleService.moduleWrapper moduleWrapper) {
        List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();
        List<FieloELR__Answer__c> answers = new List<FieloELR__Answer__c>();

        for (FieloELR__Question__c question: moduleWrapper.questions) {
            questionResponses.add(
                new FieloELR__QuestionResponse__c(
                    FieloELR__ModuleResponse__c = moduleWrapper.moduleresponse.Id,
                    FieloELR__Question__c = question.Id
                )
            );
        }
        insert questionResponses;

        Map<Id, FieloELR__Question__c> questionMap = new Map<Id, FieloELR__Question__c>([SELECT Id, FieloELR__Type__c		, (SELECT Id, FieloELR__AnswerOptionText__c, FieloELR__MatchingText__c, FieloELR__IsCorrect__c FROM FieloELR__AnswerOptions__r) FROM FieloELR__Question__c WHERE Id in : new Map<Id,FieloELR__Question__c>(moduleWrapper.questions).keySet()]);
        List<FieloELR__QuestionResponse__c> needUpdate = new List<FieloELR__QuestionResponse__c>();

        for (FieloELR__QuestionResponse__c qr: questionResponses) {
            for (FieloELR__AnswerOption__c ao: questionMap.get(qr.FieloELR__Question__c).FieloELR__AnswerOptions__r) {
                if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Short Answer') {
                    if (!ao.FieloELR__IsCorrect__c) {
                        qr.FieloELR__TextValue__c = ao.FieloELR__AnswerOptionText__c;
                        needUpdate.add(qr);
                        break;
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Single Choice' || questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Statement') {
                    if (!ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id
                            )
                        );
                        break;
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Multiple Choice') {
                    if (!ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id
                            )
                        );
                    }
                } else if (questionMap.get(qr.FieloELR__Question__c).FieloELR__Type__c		 == 'Matching Options') {
                    if (ao.FieloELR__IsCorrect__c) {
                        answers.add(
                            new FieloELR__Answer__c(
                                FieloELR__QuestionResponse__c = qr.Id,
                                FieloELR__AnswerOption__c = ao.Id,
                                FieloELR__TextValue__c = '!!Wrong Value!!'
                            )
                        );
                    }
                }
            }
        }
        if (!needUpdate.isEmpty()) {
            update needUpdate;
        }

        insert answers;

        update new FieloELR__ModuleResponse__c(
            Id = moduleWrapper.moduleresponse.Id,
            FieloELR__IsSubmitted__c = true
        );

        System.debug(JSON.serializePretty(questionResponses));
        System.debug(JSON.serializePretty(answers));
    }
}