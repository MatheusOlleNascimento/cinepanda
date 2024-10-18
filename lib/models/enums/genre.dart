enum Genre {
  acao(28, "Ação"),
  aventura(12, "Aventura"),
  animacao(16, "Animação"),
  comedia(35, "Comédia"),
  crime(80, "Crime"),
  documentario(99, "Documentário"),
  drama(18, "Drama"),
  familia(10751, "Família"),
  fantasia(14, "Fantasia"),
  historia(36, "História"),
  terror(27, "Terror"),
  musica(10402, "Música"),
  misterio(9648, "Mistério"),
  romance(10749, "Romance"),
  ficcaoCientifica(878, "Ficção científica"),
  cinemaTV(10770, "Cinema TV"),
  thriller(53, "Thriller"),
  guerra(10752, "Guerra"),
  faroeste(37, "Faroeste");

  final int id;
  final String name;

  const Genre(this.id, this.name);
}
