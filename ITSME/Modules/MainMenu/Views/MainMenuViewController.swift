import UIKit
import Combine

internal class MainMenuViewController: UIViewController {
    private let viewModel: MainMenuViewModel
    private var musicListViewModel: [MusicViewModel] = []
    private var currentlyPlayingTrackId: Int?
    enum Section {
        case main
    }
    private var currentPlayedCell: MusicCellView?
    var dataSource: UITableViewDiffableDataSource<Section, MusicViewModel>?
    private var cancellables: Set<AnyCancellable> = []

    lazy var searchBarController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
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
            let musicViewModel = self.musicListViewModel[indexPath.row]
            cell.configure(with: musicViewModel)
            if musicViewModel.trackId == self.currentlyPlayingTrackId {
                cell.indicatorView.start()
            } else {
                cell.indicatorView.stop()
            }
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
    lazy var loadingView: LoadingView = LoadingView()

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
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicControlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            musicControlView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            musicControlView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            musicControlView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        musicControlView.isHidden = true
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
            playPauseTrack(sender)
        case .next:
            playNextTrack()
        case .previous:
            playPreviousTrack()
        }
    }

    private func playPauseTrack(_ sender: UIButton) {
        guard
            let currentCell = currentPlayedCell,
            let trackId = currentlyPlayingTrackId
        else {
            return
        }
        if currentCell.indicatorView.isPlaying {
            viewModel.pauseAudio()
            currentCell.indicatorView.stop()
            sender.isSelected.toggle()
        } else {
            viewModel.playAudio(trackId: trackId)
            currentCell.indicatorView.start()
            sender.isSelected.toggle()
        }
    }

    private func playNextTrack() {
        guard let currentTrackId = currentlyPlayingTrackId else {
            return
        }
        if let currentIndex = musicListViewModel.firstIndex(where: { $0.trackId == currentTrackId }) {
            let nextIndex = (currentIndex + 1) % musicListViewModel.count
            playTrack(at: nextIndex)
        }
    }

    private func playPreviousTrack() {
        guard let currentTrackId = currentlyPlayingTrackId else {
            return
        }
        if let currentIndex = musicListViewModel.firstIndex(where: { $0.trackId == currentTrackId }) {
            let previousIndex = (currentIndex - 1 + musicListViewModel.count) % musicListViewModel.count
            playTrack(at: previousIndex)
        }
    }

    private func playTrack(at index: Int) {
        let newTrack = musicListViewModel[index]
        viewModel.playAudio(trackId: newTrack.trackId)
        currentlyPlayingTrackId = newTrack.trackId
        currentPlayedCell?.indicatorView.stop()
        if let newCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MusicCellView {
            newCell.indicatorView.start()
            currentPlayedCell = newCell
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
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
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

    private func showLoadingIndicator() {
        loadingView.isHidden = false
    }

    private func hideLoadingIndicator() {
        loadingView.isHidden = true
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
            musicControlView.isHidden = true
            currentlyPlayingTrackId = nil
        }
        if cell.indicatorView.isPlaying {
            cell.indicatorView.stop()
            viewModel.pauseAudio()
            currentlyPlayingTrackId = nil
        } else {
            cell.indicatorView.start()
            viewModel.playAudio(trackId: musicViewModel.trackId)
            currentlyPlayingTrackId = musicViewModel.trackId
        }
        if cell.indicatorView.isPlaying {
            currentPlayedCell = cell
            musicControlView.isHidden = false
        } else {
            currentPlayedCell = nil
            musicControlView.isHidden = true
        }
    }
}

extension MainMenuViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        viewModel.fetchData(keyword: query)
    }
}
