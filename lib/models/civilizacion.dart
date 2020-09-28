class Civilizacion{
  String id;
  String name;
  int votes;

  Civilizacion({
    this.id,
    this.name,
    this.votes
  });

  /*
    factory: Recibe argumentos de alguna cosa y retorna una instancia de esta clase.
  */
  factory Civilizacion.fromMap(Map<String, dynamic> obj)=>Civilizacion(
    id: obj['id'] ?? 'no_id',
    name: obj['name']??'no_name',
    votes: obj['votes']??'no_votes'
  );
}