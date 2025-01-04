import UIKit
import Combine

internal class MainMenuViewController: UIViewController {
    private let viewModel: MainMenuViewModel
    private var musicListViewModel: [MusicViewModel] = []
    enum Section {
        case main
    }
    private var currentPlayedCell: MusicCellView?
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
        tableView.backgroundColor = .secondarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
    lazy var musicControlView: MusicControlView = MusicControlView()
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: LocalizedKey.error.localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedKey.ok.localized, style: .default))
        return alert
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
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
        view.addSubview(musicControlView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicControlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicControlView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            musicControlView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            musicControlView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12)
        ])
        musicControlView.prevButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        musicControlView.pausePlayButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        musicControlView.nextButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
    }

    @objc private func handleButtonTapped(_ sender: UIButton) {
        guard
            let label = sender.accessibilityLabel,
            let buttonType = MusicControlView.ButtonType(rawValue: label)
        else {
            return
        }
        switch buttonType {
        case .playPause:
            print("play button tapped")
        case .next:
            print("next button tapped")
        case .previous:
            print("prev button tapped")
        }
    }
}

extension MainMenuViewController {
    private func bindViewModel() {
        viewModel.$musicListViewModel
            .sink { [weak self] musicList in
                guard let self else { return }
                self.musicListViewModel = musicList ?? []
                self.updateDataSource()
            }
            .store(in: &cancellables)
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self, let errorMessage else { return }
                self.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    private func updateDataSource() {
        guard let dataSource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MusicViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(musicListViewModel)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        errorAlert.message = message
        present(errorAlert, animated: true, completion: nil)
    }
}

extension MainMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let musicViewModel = dataSource?.itemIdentifier(for: indexPath),
            let cell = tableView.cellForRow(at: indexPath) as? MusicCellView
        else {
            return
        }
        if let currentCell = currentPlayedCell, currentCell != cell {
            currentCell.indicatorView.stop()
            viewModel.pauseAudio()
        }
        if cell.indicatorView.isPlaying {
            cell.indicatorView.stop()
            viewModel.pauseAudio()
        } else {
            cell.indicatorView.start()
            viewModel.playAudio(trackId: musicViewModel.trackId)
        }
        if cell.indicatorView.isPlaying {
            currentPlayedCell = cell
        } else {
            currentPlayedCell = nil
        }
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
