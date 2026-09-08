import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/patrimonio_dados.dart';
import '../services/patrimonio_service.dart';

class PatrimonioController extends GetxController {
  final PatrimonioService _service = Get.put(PatrimonioService());

  final patrimonios = <Patrimonio>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    carregarPatrimonios();
  }

  Future<void> carregarPatrimonios() async {
    isLoading.value = true;
    final response = await _service.listar();

    if (response.isOk && response.body != null) {
      patrimonios.assignAll(response.body!);
    } else {
      Get.snackbar(
        'Erro',
        'Falha ao conectar com o servidor',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }

  Future<void> adicionar(Patrimonio patrimonio) async {
    isLoading.value = true;
    final response = await _service.cadastrar(patrimonio);

    if (response.isOk && response.body != null) {
      patrimonios.add(response.body!);
      Get.back();
      Get.snackbar(
        'Sucesso',
        'Patrimônio cadastrado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erro',
        'Falha ao cadastrar patrimônio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }

  Future<void> editar(int id, Patrimonio patrimonio) async {
    isLoading.value = true;
    final response = await _service.atualizar(id, patrimonio);

    if (response.isOk && response.body != null) {
      final index = patrimonios.indexWhere((p) => p.id == id);
      if (index != -1) {
        patrimonios[index] = response.body!;
      }
      Get.back();
      Get.snackbar(
        'Sucesso',
        'Patrimônio atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erro',
        'Falha ao atualizar patrimônio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading.value = false;
  }

  Future<void> remover(int id) async {
    final response = await _service.excluir(id);

    if (response.isOk) {
      patrimonios.removeWhere((p) => p.id == id);
      Get.snackbar(
        'Sucesso',
        'Patrimônio excluído!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erro',
        'Falha ao excluir patrimônio',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}