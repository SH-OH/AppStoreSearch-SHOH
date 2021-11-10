//
//  SearchResultDetailViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

import SPMSHOHProxy
import ActiveLabel
import ReactorKit
import RxRelay
import SnapKit

final class SearchResultDetailViewController: UIViewController, StoryboardLoadable {
    
    deinit {
        print("deinit", String(describing: self))
    }
    
    private enum ScrollTag: Int {
        case main = 100
        case summary
        case newFeature
        case preview
        case description
        case rating
        case review
        case privacy
        case info
    }
    
    private enum Const {
        static let downImage: String = "chevron.down"
        static let privacyUrlText: String = "개발자의 개인정보 처리방침"
        static let privacyText: String = "개발자가 아래 설명된 데이터 처리 방식이 앱의 개인정보 처리방침에 포함되어 있을 수 있다고 표시했습니다. 자세한 내용은 \(Const.privacyUrlText)을 참조하십시오."
        static let reviewCellHeight: CGFloat = 150
        static let previewCellMultiplier: CGFloat = 0.6
        static let animationDuration: CGFloat = 0.25
    }
    
    // MARK: - Constraints
    
    @IBOutlet private weak var releaseNotesTextViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var previewCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var descriptionTextViewHeight: NSLayoutConstraint!
    
    // MARK: - UI Components
    
    @IBOutlet private weak var rootScrollView: UIScrollView!
    
    // 메인
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    /// 진입하고 3초 이후 description으로 변경 및 lookup api 추가 후 artist 상태 일 경우 보여주기
    @IBOutlet private weak var mainArtistNameLabel: UILabel!
    @IBOutlet private weak var openButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    // 요약
    /// 리뷰
    @IBOutlet private weak var summaryReviewView: UIView!
    @IBOutlet private weak var summaryRatingCountLabel: UILabel!
    @IBOutlet private weak var summaryRatingLabel: UILabel!
    @IBOutlet private weak var summaryRatingStarImage01: UIImageView!
    @IBOutlet private weak var summaryRatingStarImage02: UIImageView!
    @IBOutlet private weak var summaryRatingStarImage03: UIImageView!
    @IBOutlet private weak var summaryRatingStarImage04: UIImageView!
    @IBOutlet private weak var summaryRatingStarImage05: UIImageView!
    /// 연령 등급
    @IBOutlet private weak var summaryContentRatingView: UIView!
    @IBOutlet private weak var summaryContentRatingLabel: UILabel!
    /// 차트
    @IBOutlet private weak var summaryRankView: UIView!
    /// 아티스트
    @IBOutlet private weak var summaryArtistView: UIView!
    @IBOutlet private weak var summaryArtistNameLabel: UILabel!
    /// 언어
    @IBOutlet private weak var summaryLanguageView: UIView!
    @IBOutlet private weak var summaryLanguageCodeLabel: UILabel!
    @IBOutlet private weak var summaryLanguageLabel: UILabel!
    
    // 새로운 기능
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var versionHistoryButton: UIButton!
    @IBOutlet private weak var updateDateToAgoLabel: UILabel!
    @IBOutlet private weak var releaseNotesTextView: UITextView!
    @IBOutlet private weak var releaseNotesMoreView: UIView!
    
    // 미리보기
    @IBOutlet private weak var previewCollectionView: UICollectionView!
    
    // 설명
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var descriptionMoreView: UIView!
    @IBOutlet private weak var descriptionArtistNameLabel: UILabel!
    @IBOutlet private weak var descriptionArtistAppsButton: UIButton!
    // 평가
    @IBOutlet private weak var reviewAllButton: UIButton!
    @IBOutlet private weak var reviewRatingLabel: UILabel!
    @IBOutlet private weak var reviewRatingCountLabel: UILabel!
    // 리뷰
    @IBOutlet private weak var reviewCollectionView: UICollectionView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var supportAppButton: UIButton!
    
    // 앱 개인 정보 보호
    @IBOutlet private weak var privacyDescriptionActiveLabal: ActiveLabel!
    
    // 정보
    /// 제공자
    @IBOutlet private weak var infoArtistNameLabel: UILabel!
    /// 크기
    @IBOutlet private weak var infoFileSizeLabel: UILabel!
    /// 카테고리
    @IBOutlet private weak var infoGenreNameLabel: UILabel!
    /// 호환성
    @IBOutlet private weak var infoSupportedStackView: UIStackView!
    @IBOutlet private weak var infoSupportedDownButton: UIButton!
    /// 언어
    @IBOutlet private weak var infoLanguageDownButton: UIButton!
    @IBOutlet private weak var infoLanguageSubView: UIView!
    @IBOutlet private weak var infoLanguageSubTextLabel: UILabel!
    /// 연령 등급
    @IBOutlet private weak var infoContentRatingDownButton: UIButton!
    @IBOutlet private weak var infoContentRatingSubView: UIView!
    @IBOutlet private weak var infoContentRatingLabel: UILabel!
    @IBOutlet private weak var infoContentRatingMoreButton: UIButton!
    /// 저작권
    @IBOutlet private weak var infoCopyrightLabel: UILabel!
    /// etc.
    @IBOutlet private weak var infoDeveloperWebButton: UIButton!
    @IBOutlet private weak var infoPrivacyPolicyButton: UIButton!
    @IBOutlet private weak var infoIssueReportButton: UIButton!
    
    var disposeBag: DisposeBag = .init()
    private let previewCellSize: BehaviorRelay<CGSize> = .init(value: .zero)
    
    private let privacyDescriptionEvent: PublishRelay<Void> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePreviewCollectionView()
        configureReviewCollectionView()
    }
    
    private func configurePreviewCollectionView() {
        previewCollectionView.registerNib(SearchResultDetailPreviewCell.self)
        previewCollectionView.decelerationRate = .fast
    }
    
    private func configureReviewCollectionView() {
        reviewCollectionView.registerNib(SearchResultReviewCell.self)
        reviewCollectionView.decelerationRate = .fast
    }
    
    private func configureActiveLabel(_ artistName: String) {
        let customType = ActiveType.custom(pattern: Const.privacyUrlText)
        privacyDescriptionActiveLabal.enabledTypes = [customType]
        privacyDescriptionActiveLabal.customColor[customType] = .link
        privacyDescriptionActiveLabal.handleCustomTap(for: customType) { [weak privacyDescriptionEvent] _ in
            privacyDescriptionEvent?.accept(())
        }
        
        let text = artistName + " " + Const.privacyText
        let fontSize = privacyDescriptionActiveLabal.font.pointSize + 1
        let font = UIFont.boldSystemFont(ofSize: fontSize)
        let range = (text as NSString).range(of: artistName)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: font, range: range)
        privacyDescriptionActiveLabal.attributedText = attributedString
    }
}

extension SearchResultDetailViewController: StoryboardView {
    func bind(reactor: SearchResultDetailViewReactor) {
        bindOutput(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchResultDetailViewReactor) {
        previewCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        reviewCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        openButton.rx.throttleTap()
            .withLatestFrom(reactor.state.map({ $0.trackId }))
            .compactMap({ URL(string: "\(Domain.AppStore.url)/id\($0)") })
            .bind(onNext: { url in
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }).disposed(by: disposeBag)
        
        shareButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("공유 버튼 이벤트")
            }).disposed(by: disposeBag)
        
        summaryReviewView.rx.throttleTapGesture()
            .compactMap({ [weak self] _ in
                self?.findOffsetY(
                    self?.reviewAllButton,
                    scrollTag: .rating,
                    rootScrollView: self?.rootScrollView
                )
            })
            .bind(onNext: { [weak rootScrollView] offsetY in
                rootScrollView?.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }).disposed(by: disposeBag)
        
        summaryContentRatingView.rx.throttleTapGesture()
            .compactMap({ [weak self] _ in
                self?.findOffsetY(
                    self?.infoContentRatingSubView,
                    scrollTag: .info,
                    rootScrollView: self?.rootScrollView
                )
            })
            .bind(onNext: { [weak rootScrollView] offsetY in
                rootScrollView?.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }).disposed(by: disposeBag)
        
        summaryLanguageView.rx.throttleTapGesture()
            .compactMap({ [weak self] _ in
                self?.findOffsetY(
                    self?.infoLanguageSubView,
                    scrollTag: .info,
                    rootScrollView: self?.rootScrollView
                )
            })
            .bind(onNext: { [weak rootScrollView] offsetY in
                rootScrollView?.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            }).disposed(by: disposeBag)
        
        versionHistoryButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("버전 히스토리 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        releaseNotesTextView.rx.throttleTapGesture()
            .bind(onNext: { [weak releaseNotesTextView, weak releaseNotesTextViewHeight, weak releaseNotesMoreView] _ in
                let adjustHeight = releaseNotesTextView?.intrinsicContentSize.height ?? 0
                if adjustHeight > releaseNotesTextView?.bounds.height ?? 0 {
                    releaseNotesTextViewHeight?.constant = adjustHeight
                    releaseNotesTextView?.superview?.layoutIfNeeded()
                }
                UIView.animate(withDuration: Const.animationDuration) {
                    releaseNotesMoreView?.alpha = 0
                }
            }).disposed(by: disposeBag)
        
        descriptionTextView.rx.throttleTapGesture()
            .bind(onNext: { [weak descriptionTextView, weak descriptionTextViewHeight, weak descriptionMoreView] _ in
                let adjustHeight = descriptionTextView?.intrinsicContentSize.height ?? 0
                if adjustHeight > descriptionTextView?.bounds.height ?? 0 {
                    descriptionTextViewHeight?.constant = adjustHeight
                    descriptionTextView?.superview?.layoutIfNeeded()
                }
                UIView.animate(withDuration: Const.animationDuration) {
                    descriptionMoreView?.alpha = 0
                }
            }).disposed(by: disposeBag)
        
        descriptionArtistAppsButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("아티스트 앱들 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        reviewAllButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("리뷰 모두 보기 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        writeReviewButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("리뷰 쓰기 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        supportAppButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("앱 지원 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        infoContentRatingMoreButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("연령 등급 더 알아보기 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        infoDeveloperWebButton.rx.throttleTap()
            .debug("tt1")
            .withLatestFrom(reactor.state.compactMap({ URL(string: $0.sellerUrl) }))
            .debug("tt2")
            .bind(onNext: { $0.openURL() })
            .disposed(by: disposeBag)
        
        Observable.merge(
            privacyDescriptionEvent.asObservable(),
            infoPrivacyPolicyButton.rx.throttleTap().asObservable()
        )
            .compactMap({ URL(string: "https://m.kakaobank.com/PrivacyPolicy;ctg=privacyManagementPolicy") })
            .bind(onNext: { $0.openURL() })
            .disposed(by: disposeBag)
        
        infoIssueReportButton.rx.throttleTap()
            .bind(onNext: { _ in
                print("문제 리포트 버튼 이벤트..")
            }).disposed(by: disposeBag)
        
        infoSupportedDownButton.rx.tap
            .withLatestFrom(reactor.state.map({ $0.supportedDeviceTypes}))
            .bind(onNext: { [weak self] devices in
                self?.animateShowInfoSubView(button: self?.infoSupportedDownButton, completion: { [weak self] in
                    devices.forEach({ [weak self] in
                        self?.appendInfoSupportedView(with: $0)
                    })
                })
            }).disposed(by: disposeBag)
        
        infoLanguageDownButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.infoLanguageSubView.isHidden = false
                self?.animateShowInfoSubView(button: self?.infoLanguageDownButton, completion: { [weak self] in
                    self?.infoLanguageSubView.alpha = 1
                })
            }).disposed(by: disposeBag)
        
        infoContentRatingDownButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.infoContentRatingSubView.isHidden = false
                self?.animateShowInfoSubView(button: self?.infoContentRatingDownButton, completion: { [weak self] in
                    self?.infoContentRatingSubView.alpha = 1
                })
            }).disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SearchResultDetailViewReactor) {
        reactor.state.map({ $0.artworkUrl100 })
            .bind(to: trackImage.rx.setImage)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.trackName })
            .bind(to: trackNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.artistName })
            .do(onNext: { [weak self] artistName in
                self?.configureActiveLabel(artistName)
            })
            .bind(to: mainArtistNameLabel.rx.text,
                  summaryArtistNameLabel.rx.text,
                  descriptionArtistNameLabel.rx.text,
                  infoArtistNameLabel.rx.text)
            .disposed(by: disposeBag)
                
        reactor.state.map({ $0.artistName })
            .map({ "© \($0)" })
            .bind(to: infoCopyrightLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.ratingDouble })
            .map({ "\($0)" })
            .bind(to: summaryRatingLabel.rx.text, reviewRatingLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedRatingArray = reactor.state.map({ $0.ratingArray })
            .share(replay: 1)
        sharedRatingArray
            .map({ $0[safe: 0] })
            .bind(to: summaryRatingStarImage01.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRatingArray
            .map({ $0[safe: 1] })
            .bind(to: summaryRatingStarImage02.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRatingArray
            .map({ $0[safe: 2] })
            .bind(to: summaryRatingStarImage03.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRatingArray
            .map({ $0[safe: 3] })
            .bind(to: summaryRatingStarImage04.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRatingArray
            .map({ $0[safe: 4] })
            .bind(to: summaryRatingStarImage05.rx.ratingImage)
            .disposed(by: disposeBag)
        
        let sharedUserRatingCount = reactor.state.map({ $0.userRatingCount })
            .share(replay: 1)
        
        sharedUserRatingCount
            .map({ $0.toUserCountStringValue })
            .map({ "\($0)개의 평가" })
            .bind(to: summaryRatingCountLabel.rx.text)
            .disposed(by: disposeBag)
        sharedUserRatingCount
            .map({ "\($0.toDecimal)개의 평가" })
            .bind(to: reviewRatingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.contentRating })
            .bind(to: summaryContentRatingLabel.rx.text, infoContentRatingLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.currentLanguageCode })
            .bind(to: summaryLanguageCodeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.summaryLanguage })
            .bind(to: summaryLanguageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.version })
            .bind(to: versionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.updateDateToAgo })
            .bind(to: updateDateToAgoLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.releaseNotes })
            .bind(to: releaseNotesTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.description })
            .bind(to: descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state.map({ $0.fileSizeToFormatting })
            .bind(to: infoFileSizeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.genreName })
            .bind(to: infoGenreNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.isSupportedCurrentDevice })
            .bind(to: infoSupportedDownButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.infoTitleLanguage })
            .bind(to: infoLanguageDownButton.rx.title())
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.isShowInfoSubText })
            .map({ $0 ? UIImage(systemName: Const.downImage) : nil })
            .bind(to: infoLanguageDownButton.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.infoSubTextLanguage })
            .bind(to: infoLanguageSubTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.screenshotType })
            .compactMap({ [weak self] in self?.calculatePreviewCellSize($0) })
            .bind(to: previewCellSize)
            .disposed(by: disposeBag)
        
        previewCellSize
            .do(onNext: { [weak previewCollectionViewHeight, weak previewCollectionView] size in
                previewCollectionViewHeight?.constant = size.height
                previewCollectionView?.layoutIfNeeded()
            })
            .withLatestFrom(reactor.state.map({ $0.screenshotUrls }))
            .bind(to: previewCollectionView.rx.items(cellIdentifier: SearchResultDetailPreviewCell.reuseIdentifier, cellType: SearchResultDetailPreviewCell.self)) { index, element, cell in
                cell.configure(element, screenshotType: reactor.currentState.screenshotType)
            }.disposed(by: disposeBag)
        
        Observable.just(["리뷰 데이터"])
            .bind(to: reviewCollectionView.rx.items(cellIdentifier: SearchResultReviewCell.reuseIdentifier, cellType: SearchResultReviewCell.self)) { index, element, cell in
                
            }.disposed(by: disposeBag)
    }
}

extension SearchResultDetailViewController {
    private func appendInfoSupportedView(with device: SupportDevice) {
        let newView = UIView()
        newView.alpha = 0
        let titleLabel: UILabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 13)
        titleLabel.text = device.deviceType.title
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.text = device.description
        
        newView.addSubview(titleLabel)
        newView.addSubview(descriptionLabel)
        
        newView.layoutIfNeeded()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(20)
        }
        
        infoSupportedStackView.addArrangedSubview(newView)
        
        newView.alpha = 1
    }
    
    private func calculatePreviewCellSize(_ type: ScreenshotType) -> CGSize {
        let width: CGFloat = view?.bounds.width ?? 0
        let resultW = type == .high
        ? width * Const.previewCellMultiplier
        : width - 30
        
        let multiplier = resultW / type.imageWH.width
        let resultH = type.imageWH.height * multiplier
        
        return CGSize(width: resultW, height: resultH)
    }
    
    private func animateShowInfoSubView(button: UIButton?, completion: @escaping () -> Void) {
        UIView.animate(withDuration: Const.animationDuration) {
            button?.alpha = 0
            button?.layoutIfNeeded()
            completion()
        }
    }
    
    private func findOffsetY(
        _ target: UIView?,
        scrollTag: ScrollTag,
        rootScrollView: UIScrollView?
    ) -> CGFloat {
        guard let rootScrollView = rootScrollView else { return .zero }
        
        let defaultBottomY: CGFloat = rootScrollView.contentSize.height
        - rootScrollView.bounds.size.height
        + rootScrollView.contentInset.bottom
        + rootScrollView.safeAreaInsets.bottom
        
        let targetTag: Int = scrollTag.rawValue
        
        var minY: CGFloat = 0.0
        var maxY: CGFloat = 0.0
        var superView: UIView? = target?.superview
        
        func sum(to minY: inout CGFloat, to maxY: inout CGFloat, target: CGRect) {
            minY += target.minY
            maxY += target.maxY
        }
        
        while true {
            if let target = target, target.tag == targetTag {
                sum(to: &minY, to: &maxY, target: target.frame)
                break
                
            } else if let superView = superView, superView.tag == targetTag {
                sum(to: &minY, to: &maxY, target: superView.frame)
                break
                
            } else if superView === rootScrollView {
                break
            }
            
            sum(to: &minY, to: &maxY, target: superView?.frame ?? .zero)
            superView = superView?.superview
        }
        
        if maxY > defaultBottomY {
            return defaultBottomY
        }
        
        return minY
    }
}

extension SearchResultDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch collectionView {
        case previewCollectionView:
            return previewCellSize.value
            
        case reviewCollectionView:
            return CGSize(width: collectionView.bounds.width-30, height: Const.reviewCellHeight)
            
        default:
            return .zero
        }
    }
}
