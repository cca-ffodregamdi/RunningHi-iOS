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

public class ReportCommentViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 사유 선택"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var reportTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: "reportCell")
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var reportTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        textField.placeholder = "신고 사유 직접 입력"
        textField.returnKeyType = .done
        //        textField.layer.borderWidth = 1
        //        textField.layer.borderColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155).cgColor
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
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(reportTableView)
        self.scrollView.addSubview(reportTextField)
        [cancelButton, confirmButton].forEach{
            bottomButtonStackView.addArrangedSubview($0)
        }
        self.scrollView.addSubview(warningLabel)
        self.scrollView.addSubview(bottomButtonStackView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        reportTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        reportTextField.snp.makeConstraints { make in
            make.top.equalTo(reportTableView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(reportTextField.snp.bottom).offset(20).priority(.high)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(bottomButtonStackView.snp.top).offset(-20)
        }
        
        bottomButtonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
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
            
        reactor.state
            .map{$0.seletedTypeIndex >= 0}
            .bind(to: self.confirmButton.rx.isEnabled)
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
            .bind{ [weak self] _ in
                print("confirm")
            }.disposed(by: self.disposeBag)
        
        reportTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.reportTextField.resignFirstResponder()
                self.reportTextField.text = ""
            }.disposed(by: self.disposeBag)
    }
    // TODO: confirm button isEnable 색 변경
    // TODO: TextField 처리
}
