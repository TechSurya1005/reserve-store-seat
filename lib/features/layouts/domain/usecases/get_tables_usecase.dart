import '../entities/table_entity.dart';
import '../repositories/layout_repository.dart';

class GetTablesUseCase {
  final LayoutRepository repository;

  GetTablesUseCase(this.repository);

  Future<List<TableEntity>> execute() async {
    return await repository.getTables();
  }
}
