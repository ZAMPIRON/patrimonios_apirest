import 'package:get/get.dart';
import '../models/patrimonio_dados.dart';

class PatrimonioService extends GetConnect {
  @override
  void onInit() {
    baseUrl = 'http://127.0.0.1:8000';
    super.onInit();
  }

  // GET /patrimonios
  Future<Response<List<Patrimonio>>> listar() async {
    return await get(
      '/patrimonios',
      decoder: (data) {
        if (data is List) {
          return data.map((e) => Patrimonio.fromJson(e)).toList();
        }
        return <Patrimonio>[];
      },
    );
  }

  // GET /patrimonios/{id}
  Future<Response<Patrimonio>> buscar(int id) async {
    return await get(
      '/patrimonios/$id',
      decoder: (data) {
        if (data is Map<String, dynamic> && data.containsKey('nome')) {
          return Patrimonio.fromJson(data);
        }
        return null as dynamic;
      },
    );
  }

  // POST /patrimonios
  Future<Response<Patrimonio>> cadastrar(Patrimonio patrimonio) async {
    return await post(
      '/patrimonios',
      patrimonio.toJson(),
      decoder: (data) {
        if (data is Map<String, dynamic> && data.containsKey('nome')) {
          return Patrimonio.fromJson(data);
        }
        return null as dynamic;
      },
    );
  }

  // PUT /patrimonios/{id}
  Future<Response<Patrimonio>> atualizar(int id, Patrimonio patrimonio) async {
    return await put(
      '/patrimonios/$id',
      patrimonio.toJson(),
      decoder: (data) {
        if (data is Map<String, dynamic> && data.containsKey('nome')) {
          return Patrimonio.fromJson(data);
        }
        return null as dynamic;
      },
    );
  }

  // DELETE /patrimonios/{id}
  Future<Response> excluir(int id) async {
    return await delete('/patrimonios/$id');
  }
}