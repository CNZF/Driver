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

    let SCREEN_W = UIScreen.main.bounds.size.width
    let SCREEN_H = UIScreen.main.bounds.size.height

    self.view.backgroundColor = UIColor.white
        self.title = "关于"

    let btnPush:UIButton = UIButton(type:.custom)
    
    let rect =  CGRect(origin: CGPoint(x: 0,y :40), size: CGSize(width: SCREEN_W, height: 40));
//        btnPush.frame = CGRectmake(0, 40, SCREEN_W, 40)
    btnPush.frame = rect;
        btnPush.setTitle("用户协议与隐私条款", for: UIControlState.normal)
    btnPush.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    btnPush.setTitleColor(UIColor.black, for: UIControlState.normal)
    btnPush.addTarget(self, action:#selector(pushAction), for:.touchUpInside)
        self.view.addSubview(btnPush)

    let infoDictionary = Bundle.main.infoDictionary
    let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject
        let appversion = majorVersion as! String


        print(appversion)

        let lbAppversion:UILabel = UILabel(frame:CGRect(x:0, y:SCREEN_H - 164, width:SCREEN_W, height:44))
    lbAppversion.textColor = UIColor.lightGray
    lbAppversion.textAlignment = NSTextAlignment.center
        lbAppversion.text = "V "+appversion
    lbAppversion.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lbAppversion)


    }

   func pushAction() {

        let vc:DynamicDetailsViewController = DynamicDetailsViewController()
        vc.title = "条款与隐私"
        vc.urlStr = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
