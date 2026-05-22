void main() async {
  final dbService = DatabaseService();

  await dbService.init();

  print('Sistema NexusPericia pronto!');
}