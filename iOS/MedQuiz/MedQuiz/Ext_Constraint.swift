//
//  Ext_Constraint.swift
//  MedQuiz
//
//  Created by Harnack, Paul (Student) on 2/25/18.
//  Copyright © 2018 Omar Sherief. All rights reserved.
//

import UIKit

extension NSLayoutConstraint{
    func constraintWithMultipler(_ multipler:CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multipler, constant: self.constant)
    }
}
