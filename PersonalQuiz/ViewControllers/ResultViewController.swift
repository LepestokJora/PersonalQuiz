//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Vasichko Anna on 10.11.2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    var answersChosen: [Answer] = []
    
    
    
    // 1. Избавиться от кнопки возврата назад на экране результатов
    // 2. Передать массив с ответами на экран с результатами
    // 3. Определить наиболее часто встречающийся тип животного
   // 4. Отобразить результаты в соответствии с этим животным
    
    // использовать функции высшего порядка map и sorted
    // отдельный метод для поиска результата
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animal = showResult()
        titleLabel.text = "Вы - \(animal.titleImgString)"
        subtitleLabel.text = "Да, вы \(animal.name)"
    }
    
    private func showResult() -> (titleImgString:String, name:String) {
        switch animalTypeMaxCount() {
        case .dog:
            return ("🐶", "собака")
        case .cat:
            return ("🐱", "кот")
        case .rabbit:
            return ("🐰", "кролик")
        case .turtle:
            return ("🐢", "черебаха")
        case .none:
            return ("😇","инкогникто")
        }
    }
    
    private func animalTypeMaxCount () -> Animal? {
        
     //   var animals:[("dogs": [Animal]), ("cats": [Animal]), ("rabbits": [Animal]),("turtles": [Animal])] = [:]
        var dogs:[Animal] = []
        var cats:[Animal] = []
        var rabbits:[Animal] = []
        var turtles:[Animal] = []
        
        for answer in answersChosen {
            switch answer.animal {
            case .dog:
                dogs.append(answer.animal)
            case .cat:
                cats.append(answer.animal)
            case .rabbit:
                rabbits.append(answer.animal)
            case .turtle:
                turtles.append(answer.animal)
            }
        }
        return [dogs, cats, rabbits, turtles].sorted(by: {$0.count > $1.count}).first?.first
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    deinit{
        print("ResultVC has been delocated")
    }
    
}
