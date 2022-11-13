//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Vasichko Anna on 07.11.2022.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    //MARK: - IBOtlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider! {
        didSet {
            let rangedSliderAnswerCount = Float((questions.filter({$0.responseType == .ranged}).first?.answers.count ?? 0) - 1)
            rangedSlider.maximumValue = rangedSliderAnswerCount
            rangedSlider.value = rangedSliderAnswerCount / 2
        }
    }
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions() // массив вопрсов
    private var questionIndex = 0 // индекс ответа из массива
    
    private var answersChosen: [Answer] = [] // массив выбранных ответов
    private var currentAnswers:[Answer] = []  // массив ответов из выбираемого экрана
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        
        goToNextQuestion()
    }
    
    
    @IBAction func multipleAnswerButtonPressed() {
        //в сториборд было 5 мультисвич массив дополнялся лишним значение по которому шло обращение к лишними индексу 
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        goToNextQuestion()
    }
    
    
    @IBAction func rangedButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        
        goToNextQuestion()
    }
}

//MARK: - Navigation
extension QuestionsViewController {
    private func goToNextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}

// MARK: - Private Methods
extension QuestionsViewController {
    
    private func updateUI() {
        // Hide stacks
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for question label
        questionLabel.text = currentQuestion.title
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for questionProgressView
        questionProgressView.setProgress(totalProgress, animated: true)
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Show stacks corresponding to question type
        showCurrentAnswers(for: currentQuestion.responseType)
        
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        guard let answers = questions.filter({$0.responseType == type}).first?.answers else {return}
        currentAnswers = answers
        switch type {
        case .single:
            singleStackView.isHidden = false
            for (button, answer) in zip(singleButtons, answers) {
                button.setTitle(answer.title, for: .normal)
            }
        case .multiple:
            multipleStackView.isHidden = false
            
            for (label, answer) in zip(multipleLabels, answers) {
                label.text = answer.title
            }
        case .ranged:
            rangedStackView.isHidden = false
            rangedLabels.first?.text = answers.first?.title
            rangedLabels.last?.text = answers.last?.title
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultViewController {
            // нужно передать массив c ответами на резултВК
            resultVC.answersChosen = answersChosen
            
        }
        
        
    }
}



