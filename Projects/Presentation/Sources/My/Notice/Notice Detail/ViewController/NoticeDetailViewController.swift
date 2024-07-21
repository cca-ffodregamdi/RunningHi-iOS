//
//  NoticeDetailViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/18/24.
//

import UIKit
import SnapKit
import Domain

public final class NoticeDetailViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        return UIScrollView()
    }()
    
    private lazy var noticeDetailView: NoticeDetailView = {
        return NoticeDetailView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "공지사항"
        configureUI()
    }
    
    public init(noticeModel: NoticeModel){
        super.init(nibName: nil, bundle: nil)
        configureModel(noticeModel: noticeModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(noticeDetailView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeDetailView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
    
    private func configureModel(noticeModel: NoticeModel){
        noticeDetailView.configureModel(noticeModel: noticeModel)
    }
}
