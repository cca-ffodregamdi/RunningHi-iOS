//
//  EditProfileViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/23/24.
//

import UIKit
import Common
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

public class EditProfileViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var editProfileView: EditProfileView = {
        return EditProfileView()
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.Neutrals300, for: .disabled)
        button.setTitleColor(.Primary, for: .normal)
        button.titleLabel?.font = .Body1Regular
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureNavigationBarItem()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public init(reactor: EditProfileReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .Secondary100
        self.view.addSubview(editProfileView)
        
        editProfileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.title = "내 정보 수정"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: confirmButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
}
extension EditProfileViewController: View{
    public func bind(reactor: EditProfileReactor) {
        
    }
}
