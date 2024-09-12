//
//  ReportCommentViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/20/24.
//

import UIKit
import SnapKit
import Common
import RxDataSources
import ReactorKit
import Domain

public class ReportCommentViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var reportTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: "reportCell")
        tableView.register(ReportTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private lazy var reportTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        textField.placeholder = "신고 사유 직접 입력"
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "허위신고일 경우, 신고자의 서비스 활동이 제한될 수 있으니 유의하시어 신중하게 신고해 주세요."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        return label
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.colorWithRGB(r: 34, g: 101, b: 201), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201).cgColor
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        
        return button
    }()
    
    public init(reactor: ReportCommentReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
        self.title = "댓글 신고"
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.reportTextField.resignFirstResponder()
    }
    
    private func configureUI(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(reportTableView)
        self.scrollView.addSubview(reportTextField)
        [cancelButton, confirmButton].forEach{
            bottomButtonStackView.addArrangedSubview($0)
        }
        self.view.addSubview(warningLabel)
        self.view.addSubview(bottomButtonStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        reportTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        reportTextField.snp.makeConstraints { make in
            make.top.equalTo(reportTableView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualTo(self.view.keyboardLayoutGuide.snp.top).offset(-20)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(bottomButtonStackView.snp.top).offset(-20)
        }
        
        bottomButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(54)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [cancelButton, confirmButton].forEach{
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
}
extension ReportCommentViewController: View{
    
    public func bind(reactor: ReportCommentReactor) {
        reactor.action.onNext(.fetchCell)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ReportCommentType>>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = self.reportTableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportTableViewCell
            cell.configureModel(title: item.title)
            return cell
        })
        
        reactor.state
            .map{ [SectionModel(model: "reportCommentModel", items: $0.items )] }
            .bind(to: reportTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reportTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size else {return}
                self?.reportTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
            
        
        let stateObservable = Observable.combineLatest(
                    reactor.state.map { $0.seletedTypeIndex },
                    reportTextField.rx.text.orEmpty.map { !$0.isEmpty }
                ) { (value, isTextFieldNotEmpty) -> Bool in
                    if value >= 0 {
                        if value == 5 {
                            return isTextFieldNotEmpty
                        } else {
                            return true
                        }
                    } else {
                        return false
                    }
                }
        stateObservable
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        stateObservable
            .map{ $0 ? UIColor.colorWithRGB(r: 34, g: 101, b: 201) : UIColor.lightGray }
            .bind(to: self.confirmButton.rx.backgroundColor)
            .disposed(by: self.disposeBag)
        
        self.reportTableView.rx.itemSelected
            .map { Reactor.Action.selectedType($0.row) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.seletedTypeIndex}
            .bind{ [weak self] index in
                guard let self = self, index >= 0 else { return }
                self.reportTableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.seletedTypeIndex != 5}
            .bind(to: self.reportTextField.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .filter{$0.seletedTypeIndex != 5}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.reportTextField.resignFirstResponder()
                self.reportTextField.text = ""
            }.disposed(by: self.disposeBag)
        
        self.cancelButton.rx.tap
            .bind{ [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
        
        self.confirmButton.rx.tap
            .map{ [weak self] _ in
                if self?.reportTextField.text?.isEmpty ?? true{
                    return Reactor.Action.reportComment(
                        ReportCommentRequestModel(category: reactor.currentState.items[reactor.currentState.seletedTypeIndex].category,
                                                commentId: reactor.currentState.commentId))
                }else{
                    return Reactor.Action.reportComment(
                        ReportCommentRequestModel(category: reactor.currentState.items[reactor.currentState.seletedTypeIndex].category,
                                                content: self?.reportTextField.text,
                                                commentId: reactor.currentState.commentId))
                }
            }.bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reportTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.reportTextField.resignFirstResponder()
            }.disposed(by: self.disposeBag)
        
        reportTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.isCompletedReport}
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                let noticeAlert = UIAlertController(
                    title: "댓글 신고를 접수하였습니다.",
                    message: "안전한 커뮤니티를 위한 노력에 동참해 주신 것에 진심으로 감사드립니다.",
                    preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                
                noticeAlert.addAction(confirmAction)
                self.present(noticeAlert, animated: true)
            }.disposed(by: self.disposeBag)
    }
}

extension ReportCommentViewController: UITableViewDelegate{
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerCell")
        return view
    }
}
