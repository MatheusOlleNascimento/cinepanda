class MovieWatchProvider {
  int id;
  CountryResult? brazilResult;

  MovieWatchProvider({
    required this.id,
    this.brazilResult,
  });

  factory MovieWatchProvider.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>?;

    CountryResult? brazilResult;
    if (results != null && results.containsKey('BR')) {
      brazilResult = CountryResult.fromJson(results['BR']);
    }

    return MovieWatchProvider(
      id: json['id'] ?? 0,
      brazilResult: brazilResult,
    );
  }
}

class CountryResult {
  String link;
  List<MovieProvider> providers;

  CountryResult({
    required this.link,
    required this.providers,
  });

  factory CountryResult.fromJson(Map<String, dynamic> json) {
    String link = json['link'] ?? '';

    var providerList = json['flatrate'] as List<dynamic>? ?? [];
    List<MovieProvider> providers = providerList.map((e) => MovieProvider.fromJson(e)).toList();

    return CountryResult(
      link: link,
      providers: providers,
    );
  }
}

class MovieProvider {
  String logoPath;
  String providerName;

  MovieProvider({
    required this.logoPath,
    required this.providerName,
  });

  factory MovieProvider.fromJson(Map<String, dynamic> json) {
    return MovieProvider(
      logoPath: json['logo_path'] ?? '',
      providerName: json['provider_name'] ?? '',
    );
  }
}
