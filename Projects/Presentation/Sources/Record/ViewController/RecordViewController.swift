//
//  RecordViewController.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain
import Charts

final public class RecordViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RecordCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private lazy var recordView: RecordView = {
        return RecordView()
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RecordReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RunningViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        self.recordView.chartArea.chartView.delegate = self
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(recordView)
        
        recordView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Binding

extension RecordViewController: View {
    
    public func bind(reactor: RecordReactor) {
        binding(reactor: reactor)
        bindingAction(reactor: reactor)
        bindingState(reactor: reactor)
    }
    
    private func binding(reactor: RecordReactor) {
        self.rx.viewDidLoad
            .bind { [weak self] _ in
                guard let self = self else {return}
                self.recordView.chartTypeView.setChartType(type: .weekly)
                reactor.action.onNext(.viewDidLoad)
            }
            .disposed(by: disposeBag)
        
        self.recordView.runningListView.tableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.recordView.runningListView.tableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
        self.rx.methodInvoked(#selector(ChartViewDelegate.chartValueSelected(_:entry:highlight:)))
            .subscribe(onNext: { parameters in
                guard let entry = parameters[1] as? ChartDataEntry, let highlight = parameters[2] as? Highlight else { return }
                
                let chartArea = self.recordView.chartArea
                guard let barData = chartArea.chartView.data else { return }
                
                // 선택된 엔트리의 색상 변경
                if let dataSet = barData.dataSets.first as? BarChartDataSet {
                    let index = dataSet.entries.firstIndex(of: entry) ?? -1
                    if index != -1 {
                        guard let entry = dataSet[index] as? BarChartDataEntry, entry.y > 0 else { return }
                        
                        dataSet.highlightColor = UIColor.clear
                        dataSet.colors = Array(repeating: .Secondary100, count: dataSet.entries.count)
                        dataSet.colors[index] = .Primary // 원하는 색상으로 변경
                        
                        chartArea.chartViewRenderer?.highlightedIndex = index
                        
                        chartArea.highlightRunningRecordView(true)
                        chartArea.chartView.highlightValue(highlight)
                        chartArea.chartView.notifyDataSetChanged()
                    }
                }
            })
            .disposed(by: self.disposeBag)
        
        self.rx.methodInvoked(#selector(ChartViewDelegate.chartValueNothingSelected(_:)))
            .subscribe(onNext: { parameters in
                let chartArea = self.recordView.chartArea
                guard let barData = chartArea.chartView.data else { return }
                
                // 선택이 해제되었을 때 마커를 숨깁니다.
                if let dataSet = barData.dataSets.first as? BarChartDataSet {
                    dataSet.colors = Array(repeating: .Secondary100, count: dataSet.entries.count)
                }
                
                chartArea.highlightRunningRecordView(false)
                chartArea.chartView.highlightValue(nil)
                chartArea.chartViewRenderer?.highlightedIndex = -1
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindingAction(reactor: RecordReactor) {
        let weeklyChartTap = recordView.chartTypeView.weeklyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .weekly)
                return Reactor.Action.tapChartType(.weekly)
            }
        let monthlyChartTap = recordView.chartTypeView.monthlyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .monthly)
                return Reactor.Action.tapChartType(.monthly)
            }
        let yearlyChartTab = recordView.chartTypeView.yearlyButton.rx.tap
            .map {
                self.recordView.chartTypeView.setChartType(type: .yearly)
                return Reactor.Action.tapChartType(.yearly)
            }
        
        Observable.merge(weeklyChartTap, monthlyChartTap, yearlyChartTab)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.recordView.chartArea.chartRangeView.leftButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.tapChartRangeButton(-1))
            }.disposed(by: self.disposeBag)
        
        self.recordView.chartArea.chartRangeView.rightButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.tapChartRangeButton(1))
            }.disposed(by: self.disposeBag)
        
        self.recordView.chartArea.chartRangeView.rangeButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                showDatePicker()
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingState(reactor: RecordReactor) {
        reactor.state
            .compactMap{ $0.recordData }
            .bind{ [weak self] data in
                guard let self = self else { return }
                self.recordView.setData(data: data)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap{ $0.recordData?.runningRecords }
            .bind(to: self.recordView.runningListView.tableView.rx.items(cellIdentifier: RecordRunningListTableViewCell.identifier, cellType: RecordRunningListTableViewCell.self)){ index, model, cell in
                cell.setData(data: model)
            }.disposed(by: self.disposeBag)
    }
    
    private func showDatePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let datePickerContainerView = UIView()
        
        self.datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)

        alert.view.addSubview(datePickerContainerView)
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "선택", style: .default, handler: { _ in
            self.reactor?.action.onNext(.tapChartDateButton(self.datePicker.date))
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension RecordViewController: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) { }
    public func chartValueNothingSelected(_ chartView: ChartViewBase) { }
}
