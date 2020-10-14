//
//  DisplayPlanVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka

class DisplayPlanVC: FormViewController, passPlan {
    
    let viewCustomisation = ViewCustomisation()
    
    var currentWeekIndex = 0
    
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    
    var planDelegate: passWorkoutFromPlans?
    var chosenWorkout = Workout(name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        //        MARK: Gesture recognizers.
        
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        initiatePlanLabelForm()
        initiateWeekLabelForm()
        initiateDayRows ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewCustomisation.setPinkGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenPlan: Plan, chosenPlanIndex: Int?) {
         self.chosenPlan = chosenPlan
         self.chosenPlanIndex = chosenPlanIndex
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DisplayWorkoutVC{
            self.planDelegate = destinationVC
            self.planDelegate?.finishPassingFromPlans(chosenWorkout: chosenWorkout)
        }
    }
    
    //        MARK: Gesture recognizers.
    
    @objc
    func leftSwipe() {
        //        next day
        print("left")
        if(currentWeekIndex < self.chosenPlan.weeks.count - 1) {
            currentWeekIndex += 1
            self.form.removeAll()
            self.reInit()
        }
    }
    
    @objc
    func rightSwipe() {
        print("right")
        //        prev day
        if(currentWeekIndex != 0) {
            currentWeekIndex += -1
            self.reInit()
        }
    }
    
    func reInit () {
        self.form.removeAll()
        self.initiatePlanLabelForm()
        self.initiateWeekLabelForm()
        self.initiateDayRows()
    }
    
    //    MARK: Form handling.
    
    func initiatePlanLabelForm () {
        UIView.setAnimationsEnabled(false)
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        form +++ Section()
            <<< LabelRow () {
                $0.title = self.chosenPlan.name
            }.cellUpdate { cell, row in
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 40)
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemPink, borderColor: UIColor(patternImage: pinkGradientImage!))
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func initiateWeekLabelForm () {
        UIView.setAnimationsEnabled(false)
        form +++ LabelRow () {
            $0.title = "Week " + String(currentWeekIndex + 1)
        }.cellUpdate { cell, row in
            cell.height = {30}
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.lightGray, borderColor: UIColor.lightGray)
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func initiateDayRows () {
        let pinkGradientImage = CAGradientLayer.pinkGradient(on: self.view)
        UIView.setAnimationsEnabled(false)
        for (dayIndex, day) in self.chosenPlan.weeks[currentWeekIndex].days.enumerated() {
            form +++ Section()
                <<< LabelRow () {
                    $0.title = "Day " + String(dayIndex + 1)
                }.cellUpdate { cell, row in
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                    self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemPink, borderColor: UIColor(patternImage: pinkGradientImage!))
            }
            for (workoutIndex, workout) in self.chosenPlan.weeks[currentWeekIndex].days[dayIndex].workouts.enumerated() {
                print(workout.name)
                form +++ Section()
                    <<< ButtonRow () {
                        $0.title = workout.name
                        $0.onCellSelection(self.assignCellRow)
                    }.cellUpdate { cell, row in
                        cell.textLabel?.textColor = UIColor.systemPink
                        cell.indentationLevel = 2
                        cell.indentationWidth = 10
                        cell.textLabel!.textAlignment = .left
                }
            }
        }
        for row in form.rows {
            row.baseCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        UIView.setAnimationsEnabled(true)
    }
    
    func assignCellRow(cell: ButtonCellOf<String>, row: ButtonRow) {
        for (dayIndex, day) in self.chosenPlan.weeks[currentWeekIndex].days.enumerated() {
            for (workoutIndex, workout) in self.chosenPlan.weeks[currentWeekIndex].days[dayIndex].workouts.enumerated() {
                if workout.name == row.title {
                    self.chosenWorkout = workout
                }
            }
        }
        self.performSegue(withIdentifier: "DisplayWorkoutSegueFromPlanDisplay", sender: self)
    }
    
}
