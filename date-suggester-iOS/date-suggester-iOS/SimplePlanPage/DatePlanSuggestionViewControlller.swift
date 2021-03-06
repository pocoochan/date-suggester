//
//  DatePlanSuggestionViewControlller.swift
//  date-suggester-iOS
//
//  Created by saya on 2020/02/05.
//  Copyright © 2020 saya. All rights reserved.
//

import UIKit
import ActiveLabel

class DatePlanSuggestionViewControlller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var suggetsPlan: Plan?
    
    @IBOutlet weak var planDecision: UIButton!
    @IBOutlet weak var replanningButton: UIButton!
    @IBOutlet weak var gotoMyPage: UIButton!
    @IBOutlet weak var datePlanTitle: UILabel!
    @IBOutlet weak var datePlanDescription: UILabel!
    @IBOutlet weak var datePlanImage: UIImageView!
    @IBOutlet weak var totalBudget: UILabel!
    @IBOutlet weak var datePlanArea: UILabel!
    @IBOutlet weak var datePlanSuggestTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        //デートプランヘッダー部分に反映される情報
        let thumbImage :UIImage = ChangeUrlToImage.shared.getImageByUrl(url:self.suggetsPlan!.thumb)
        
        DispatchQueue.main.async {
            self.datePlanSuggestTV.reloadData()
            self.datePlanTitle.text = self.suggetsPlan?.title
            self.datePlanDescription.text = self.suggetsPlan?.des
            self.totalBudget.text = self.suggetsPlan?.totalBudget
            self.datePlanArea.text = self.suggetsPlan?.area
            self.datePlanImage.image = thumbImage
        }
    }
    private func setupView() {
        datePlanSuggestTV.delegate = self
        datePlanSuggestTV.dataSource = self
        
        //ボタン装飾
        planDecision.layer.cornerRadius = 30
        planDecision.layer.borderColor = UIColor.white.cgColor
        planDecision.layer.borderWidth = 1.0
        replanningButton.layer.borderColor = UIColor.init(red: 254.0/255, green: 84.0/255, blue: 146.0/255, alpha: 1.0).cgColor
        replanningButton.layer.borderWidth = 1.0
        replanningButton.layer.cornerRadius = 30
        
        gotoMyPage.layer.borderColor = UIColor.white.cgColor
        gotoMyPage.layer.borderWidth = 1.0
        gotoMyPage.layer.cornerRadius = 15
        
    }

    //カスタムセルの作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "DateListCustomCell"
        let spotsThumbImage:UIImage = ChangeUrlToImage.shared.getImageByUrl(url:((self.suggetsPlan?.spots?[indexPath.row].thumb)!))
        
        if let myCell: DateListCustomCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DateListCustomCell {
            myCell.thumbnail?.image = spotsThumbImage
            myCell.location?.text = self.suggetsPlan?.spots?[indexPath.row].name
            myCell.moneyIcon?.image = UIImage(named: "moneyIcon")!
            myCell.budget?.text = self.suggetsPlan?.spots?[indexPath.row].budget
            myCell.linkIcon?.image = UIImage(named: "linkIcon")

            myCell.urlLabel.customize { label in
                label.text = self.suggetsPlan?.spots?[indexPath.row].url as? String
                label.textColor = .blue
                label.handleURLTap{ url in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            return myCell
        }
        
        let myCell = DateListCustomCell(style: .default, reuseIdentifier: cellIdentifier)
        myCell.thumbnail?.image = spotsThumbImage
        myCell.location?.text = self.suggetsPlan?.spots?[indexPath.row].name
        myCell.moneyIcon?.image = UIImage(named: "moneyIcon")!
        myCell.budget?.text = self.suggetsPlan?.spots?[indexPath.row].budget
        myCell.linkIcon?.image = UIImage(named: "linkIcon")
        myCell.urlLabel?.text = self.suggetsPlan?.spots?[indexPath.row].url as? String

        myCell.urlLabel.customize { label in
            label.text = self.suggetsPlan?.spots?[indexPath.row].url as? String
            label.textColor = .blue
            label.handleURLTap{ url in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggetsPlan?.spots?.count ?? 0
    }
    
    @IBAction func DesideDatePlan(_ sender: Any) {
        /*
         デートプランをリストに加えるAPI
         */
        let planFixParams = [
            "plan_id": self.suggetsPlan?.id
            ] as [String : Any]
        
        let parameter = ["plan": planFixParams]
        
        Api().datePlanFix(parameter: parameter, completion: {(token, error) in
            
            if let _error = error {
                // アラートを出す
                return
            }
            
            DispatchQueue.main.async {
                debugPrint("デートプラン決定成功")
                let storyboard = UIStoryboard(name: "MainPageViewController", bundle: nil)
                let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPageViewController")
                mainPageViewController.modalPresentationStyle = .fullScreen
                self.present(mainPageViewController, animated: true, completion: nil)
            }
        })
    }

    @IBAction func gotoMyPageWithoutDecidingPlan(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainPageViewController", bundle: nil)
        let mainPageViewController = storyboard.instantiateViewController(withIdentifier: "MainPageViewController")
        mainPageViewController.modalPresentationStyle = .fullScreen
        self.present(mainPageViewController, animated: true, completion: nil)
    }
    
    @IBAction func replanningButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SimplePlanViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DatePlanViewController")
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


class DateListCustomCell: UITableViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var moneyIcon: UIImageView!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var linkIcon: UIImageView!
    @IBOutlet weak var urlLabel: ActiveLabel!
}
