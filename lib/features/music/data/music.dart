class Music {
  final String title;
  final String artist;
  final String state;
  final String? thumbnail;

  Music({
    required this.title,
    required this.artist,
    required this.state,
    this.thumbnail,
  });

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      state: map['state'] ?? 'unknown',
      thumbnail: map['thumbnail'],
    );
  }

  bool get isPlaying => state == "playing";
  bool get isAvailable => title.isNotEmpty || artist.isNotEmpty;
}
