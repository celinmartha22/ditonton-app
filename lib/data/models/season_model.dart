import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  SeasonModel({
    required this.id,
    required this.name,
    required this.episodeCount,
    required this.posterPath,
  });

  final int id;
  final String name;
  final int episodeCount;
  final String posterPath;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        id: json["id"],
        name: json["name"]!= null ? json["name"]:'',
        episodeCount: json["episode_count"],
        posterPath: json["poster_path"] != null ? json["poster_path"]:'',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "episode_count": episodeCount,
        "poster_path": posterPath,
      };

  Season toEntity() {
    return Season(
        id: this.id,
        name: this.name,
        episodeCount: this.episodeCount,
        posterPath: this.posterPath);
  }

  @override
  List<Object?> get props => [id, name, episodeCount, posterPath];
}
