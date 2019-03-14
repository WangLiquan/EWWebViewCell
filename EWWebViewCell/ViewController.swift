//
//  ViewController.swift
//  EWWebViewCell
//
//  Created by Ethan.Wang on 2018/10/29.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var tableView = UITableView(frame: UIScreen.main.bounds)

    private var webViewCellHeight = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.green
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EWWebViewTableViewCell.self, forCellReuseIdentifier: EWWebViewTableViewCell.identifier)
        /// 接收页面在在完成通知
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWebViewCell(_:)), name: NSNotification.Name(rawValue: "webViewHeightCallBack"), object: nil)

    }
    @objc private func reloadWebViewCell(_ notification: NSNotification) {
        guard let info = notification.object as? Int else { return }
        /// 修改cell高度
        self.webViewCellHeight = info
        /*  重置tableViewCell.height.
            如果使用reloadData()或者reloadRow()会导致webView重新加载.陷入循环.
            使用beginUpdates只更新frame,并不重新加载
         */
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "webViewHeightCallBack"), object: nil)
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(webViewCellHeight)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EWWebViewTableViewCell.identifier) as? EWWebViewTableViewCell else {
            return EWWebViewTableViewCell()
        }
        cell.setData(webUrl: "https://github.com/WangLiquan")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
