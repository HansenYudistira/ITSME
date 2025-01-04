import UIKit
import Combine

internal class MainMenuViewController: UIViewController {
    private let viewModel: MainMenuViewModel
    private var musicListViewModel: [MusicViewModel] = []
    enum Section {
        case main
    }
    var dataSource: UITableViewDiffableDataSource<Section, MusicViewModel>?
    private var cancellables: Set<AnyCancellable> = []

    lazy var searchBarController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = LocalizedKey.search.localized
        return searchController
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MusicCellView.self, forCellReuseIdentifier: MusicCellView.identifier)
        tableView.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: MusicCellView.identifier,
                    for: indexPath
                ) as? MusicCellView
            else {
                fatalError("Could not dequeue MusicCellView")
            }
            cell.configure(with: self.musicListViewModel[indexPath.row])
            return cell
        })
        return tableView
    }()
    lazy var controlStackView: ControlStackView = {
        let controlStackView = ControlStackView()
        return controlStackView
    }()

    init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    private func setupView() {
        navigationItem.searchController = searchBarController
        view.backgroundColor = .systemBackground
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(controlStackView)
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.8)
        ])
    }

    private func bindViewModel() {
        viewModel.$musicListViewModel
            .sink { [weak self] musicList in
                guard let self else { return }
                self.musicListViewModel = musicList ?? []
                self.updateDataSource()
            }
            .store(in: &cancellables)
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(musicListViewModel)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension MainMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let musicViewModel = dataSource?.itemIdentifier(for: indexPath)
        else {
            return
        }
        print(musicViewModel.trackName)
    }
}

extension MainMenuViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        viewModel.fetchData(keyword: query)
    }
}
