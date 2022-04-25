//
//  HomeViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit
import Tabman
import Pageboy

final class HomeViewController: TabmanViewController {

    private let viewControllers = [APIViewController(), LocalViewController()]
    private let tapTitleList = ["API", "Local"]

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "GitHub Stars"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        self.dataSource = self
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit

        addBar(bar, dataSource: self, at: .top)
    }
}

extension HomeViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: tapTitleList[index])
    }
}
