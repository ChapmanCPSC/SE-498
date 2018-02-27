//
//  UserView.swift
//  
//
//  Created by Harnack, Paul (Student) on 2/26/18.
//

import UIKit

class UserView: UIView {

    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var lab_position: UILabel!
    @IBOutlet weak var lab_username: UILabel!
    @IBOutlet weak var iv_profile: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubviews()
    }
    
    func addSubviews(){
        addSubview(viewMain)
        viewMain.addSubview(iv_profile)
        viewMain.addSubview(lab_position)
        viewMain.addSubview(lab_username)
    }
    

}
