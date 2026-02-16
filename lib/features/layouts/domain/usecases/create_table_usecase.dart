import '../entities/table_entity.dart';
import '../repositories/layout_repository.dart';

class CreateTableUseCase {
  final LayoutRepository repository;

  CreateTableUseCase(this.repository);

  Future<void> execute(TableEntity table) async {
    return await repository.createTable(table);
  }
}
