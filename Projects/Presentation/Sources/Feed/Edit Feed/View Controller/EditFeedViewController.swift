//
//  EditFeedViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import Domain

public protocol EditFeedViewControllerDelegate: AnyObject {
    func editedFeed()
}

public class EditFeedViewController: UIViewController {

    public weak var delegate: EditFeedViewControllerDelegate?
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.setTitleColor(.lightGray, for: .disabled)
//        button.isEnabled = false
        return button
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        
        return UITextView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBarItem()
    }
        
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentTextView.resignFirstResponder()
    }
    
    public init(reactor: EditFeedReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit EditFeedViewController")
    }
    
    private func configureUI(){
        self.title = "게시글 수정"
        
        self.view.addSubview(contentTextView)
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: confirmButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
}

extension EditFeedViewController: View{
    
    public func bind(reactor: EditFeedReactor) {
        reactor.action.onNext(.fetchPost)
        
        reactor.state
            .compactMap{$0.feed}
            .bind{ [weak self] feed in
                self?.contentTextView.text = feed.postContent
            }.disposed(by: self.disposeBag)
        
        confirmButton.rx.tap
            .map{ [weak self] _ in
                self?.contentTextView.resignFirstResponder()
                return Reactor.Action.editfeed(EditFeedRequestDTO(postContent: self?.contentTextView.text ?? "", dataType: 1, difficulty: "HARD"))
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.editedFeed}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.editedFeed()
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
    }
}
