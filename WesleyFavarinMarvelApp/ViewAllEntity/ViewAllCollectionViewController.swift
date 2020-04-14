//
//  ViewAllCollectionViewController.swift
//  WesleyFavarinMarvelApp
//
//  Created by Wesley Favarin on 09/04/20.
//  Copyright © 2020 Wesley Favarin. All rights reserved.
//


import Foundation
import UIKit
import MarvelApiWrapper

class ViewAllCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var id: Int!

    var dataSource: [Marvel]!
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let frame = CGRect(x: collectionView.frame.midX, y: 15, width: 20, height: 20)
        let indicator = UIActivityIndicatorView(frame: frame)
        indicator.style = .large
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAll", for: indexPath) as! ViewAllCollectionViewCell
        cell.imageView.image = UIImage(data: dataSource[indexPath.row].imageData ?? Data())
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        if loadingIndicator.superview == nil {
            view.addSubview(loadingIndicator)
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadingIndicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = sender as? Int else {
            return
        }

        if let destination = segue.destination as? ComicDetailViewController {
            destination.comicId = id
        } else if let destination = segue.destination as? EventDetailViewController {
            destination.eventId = id
        } else if let destination = segue.destination as? SerieDetailViewController {
            destination.serieId = id
        } else if let destination = segue.destination as? CharacterDetailViewController {
            destination.characterId = id
        } else if let destination = segue.destination as? CreatorDetailViewController {
            destination.creatorId = id
        }
    }
    
    func add(moreData: [Marvel]?, to total: [Marvel]) {
        self.loadingIndicator.stopAnimating()
        guard let data = moreData, !data.isEmpty else {
            return
        }

        var indexPaths = [IndexPath]()
        
        for row in stride(from: self.dataSource.count, to: total.count, by: 1) {
            indexPaths.append(IndexPath(row: row, section: 0))
        }
        self.dataSource.append(contentsOf: data)
        self.collectionView.insertItems(at: indexPaths)
    }
}

class CharacterComicViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CharacterComicConfig()
            config.offset = dataSource.count + 20
            Service.getComicsWith(characterId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getComicsWith(characterId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.ComicDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class CharacterEventViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CharacterEventConfig()
            config.offset = dataSource.count + 20
            Service.getEventsWith(characterId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getEventsWith(characterId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.EventDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class CharacterSerieViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CharacterSerieConfig()
            config.offset = dataSource.count + 20
            Service.getSeriesWith(characterId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getSeriesWith(characterId: self.id))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.SerieDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class ComicEventViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = ComicEventConfig()
            config.offset = dataSource.count + 20
            Service.getEventsWith(comicId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getEventsWith(comicId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.EventDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class ComicCharacterViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = ComicCharacterConfig()
            config.offset = dataSource.count + 20
            Service.getCharactersWith(comicId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCharactersWith(comicId: self.id))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CharacterDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class ComicCreatorViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = ComicCreatorConfig()
            config.offset = dataSource.count + 20
            Service.getCreatorsWith(comicId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCreatorsWith(comicId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CreatorDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class EventCharacterViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = EventCharacterConfig()
            config.offset = dataSource.count + 20
            Service.getCharactersWith(eventId: id, config: config) { moreData in
                self.loadingIndicator.stopAnimating()
                guard let data = moreData, !data.isEmpty else {
                    return
                }

                let totalData = Model().getCharactersWith(eventId: self.id)
                var indexPaths = [IndexPath]()
                
                for row in stride(from: self.dataSource.count, to: totalData.count, by: 1) {
                    indexPaths.append(IndexPath(row: row, section: 0))
                }
                self.dataSource.append(contentsOf: data)
                self.collectionView.insertItems(at: indexPaths)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CharacterDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class EventComicViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = EventComicConfig()
            config.offset = dataSource.count + 20
            Service.getComicsWith(eventId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getComicsWith(eventId: self.id))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.ComicDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class EventCreatorViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = EventCreatorConfig()
            config.offset = dataSource.count + 20
            Service.getCreatorsWith(eventId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCreatorsWith(eventId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CreatorDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class EventSerieViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = EventSerieConfig()
            config.offset = dataSource.count + 20
            Service.getSeriesWith(eventId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getSeriesWith(eventId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.SerieDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class SerieCharacterViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = SerieCharacterConfig()
            config.offset = dataSource.count + 20
            Service.getCharactersWith(serieId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCharactersWith(serieId: self.id))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CharacterDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class SerieComicViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = SerieComicConfig()
            config.offset = dataSource.count + 20
            Service.getComicsWith(serieId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getComicsWith(serieId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.ComicDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class SerieCreatorViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = SerieCreatorConfig()
            config.offset = dataSource.count + 20
            Service.getCreatorsWith(serieId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCreatorsWith(serieId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CreatorDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class SerieEventViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = SerieEventConfig()
            config.offset = dataSource.count + 20
            Service.getEventsWith(serieId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getEventsWith(serieId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.EventDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class CreatorSerieViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CreatorSerieConfig()
            config.offset = dataSource.count + 20
            Service.getSeriesWith(creatorId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getSeriesWith(creatorId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.SerieDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class CreatorComicViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CreatorComicConfig()
            config.offset = dataSource.count + 20
            Service.getComicsWith(creatorId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getComicsWith(creatorId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.ComicDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class CreatorEventViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = CreatorEventConfig()
            config.offset = dataSource.count + 20
            Service.getEventsWith(creatorId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getEventsWith(creatorId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.EventDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class StorySerieViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = StorySerieConfig()
            config.offset = dataSource.count + 20
            Service.getSeriesWith(storyId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getSeriesWith(storyId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.SerieDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class StoryCharacterViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = StoryCharacterConfig()
            config.offset = dataSource.count + 20
            Service.getCharactersWith(storyId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCharactersWith(storyId: self.id))
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CharacterDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class StoryComicViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = StoryComicConfig()
            config.offset = dataSource.count + 20
            Service.getComicsWith(storyId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getComicsWith(storyId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.ComicDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class StoryCreatorViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = StoryCreatorConfig()
            config.offset = dataSource.count + 20
            Service.getCreatorsWith(storyId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getCreatorsWith(storyId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.CreatorDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}

class StoryEventViewAll: ViewAllCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        if (indexPath.row == dataSource.count - 1 ) {
            var config = StoryEventConfig()
            config.offset = dataSource.count + 20
            Service.getEventsWith(storyId: id, config: config) { moreData in
                self.add(moreData: moreData, to: Model().getEventsWith(storyId: self.id))
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.Segue.EventDetail.rawValue, sender: dataSource[indexPath.row].id)
    }
}


