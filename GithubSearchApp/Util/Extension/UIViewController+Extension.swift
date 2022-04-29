//
//  UIViewController+Extension.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/29.
//

import UIKit
import Network

extension UIViewController {
    
    func noNetworkAlert() {
        let alert = UIAlertController(title: "인터넷 연결을 확인해주세요!", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func monitorNetwork() {

        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network")

        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.noNetworkAlert()
                }
            }
        }
    }
}
