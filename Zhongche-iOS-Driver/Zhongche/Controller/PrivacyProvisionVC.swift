//
//  PrivacyProvisionVC.swift
//  Zhongche
//
//  Created by lxy on 2017/3/9.
//  Copyright © 2017年 lxy. All rights reserved.
//

import Foundation


class PrivacyProvisionVC: BaseViewController {


   override func viewDidLoad() {

    super.viewDidLoad()

    }

   override func bindView() {

        let SCREEN_W = UIScreen.mainScreen().bounds.size.width
        let SCREEN_H = UIScreen.mainScreen().bounds.size.height

        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "关于"

        let btnPush:UIButton = UIButton(type:.Custom)

        btnPush.frame = CGRectMake(0, 40, SCREEN_W, 40)
        btnPush.setTitle("用户协议与隐私条款", forState: UIControlState.Normal)
        btnPush.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnPush.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnPush.addTarget(self, action:#selector(pushAction), forControlEvents:.TouchUpInside)
        self.view.addSubview(btnPush)

        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        let appversion = majorVersion as! String


        print(appversion)

        let lbAppversion:UILabel = UILabel(frame:CGRect(x:0, y:SCREEN_H - 164, width:SCREEN_W, height:44))
        lbAppversion.textColor = UIColor.lightGrayColor()
        lbAppversion.textAlignment = NSTextAlignment.Center
        lbAppversion.text = "V "+appversion
        lbAppversion.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(lbAppversion)


    }

   func pushAction() {

        let vc:DynamicDetailsViewController = DynamicDetailsViewController()
        vc.title = "条款与隐私"
        vc.urlStr = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

}