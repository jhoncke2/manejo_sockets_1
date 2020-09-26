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
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  );
}