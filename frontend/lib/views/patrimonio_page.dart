import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patrimonio_controller.dart';
import '../models/patrimonio_dados.dart';

class PatrimonioPage extends StatelessWidget {
  PatrimonioPage({super.key});

  final controller = Get.put(PatrimonioController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450), // Simula a largura de um smartphone
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Patrimônios SENAI'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.carregarPatrimonios,
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value && controller.patrimonios.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.patrimonios.isEmpty) {
              return const Center(child: Text('Nenhum patrimônio cadastrado.'));
            }

            return ListView.builder(
              itemCount: controller.patrimonios.length,
              itemBuilder: (context, index) {
                final item = controller.patrimonios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(item.id != null ? '${item.id}' : '?'),
                    ),
                    title: Text(
                      item.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Local: ${item.local}\nResp: ${item.responsavel}\nDesc: ${item.descricao}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _exibirFormulario(context, patrimonio: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmarExclusao(context, item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _exibirFormulario(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, Patrimonio item) {
    Get.defaultDialog(
      title: 'Excluir Patrimônio',
      middleText: 'Deseja remover "${item.nome}"?',
      textConfirm: 'Sim',
      textCancel: 'Não',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        if (item.id != null) {
          controller.remover(item.id!);
        }
      },
    );
  }

  void _exibirFormulario(BuildContext context, {Patrimonio? patrimonio}) {
    final nomeCtrl = TextEditingController(text: patrimonio?.nome ?? '');
    final descCtrl = TextEditingController(text: patrimonio?.descricao ?? '');
    final localCtrl = TextEditingController(text: patrimonio?.local ?? '');
    final respCtrl = TextEditingController(text: patrimonio?.responsavel ?? '');

    final isEditing = patrimonio != null;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Patrimônio' : 'Novo Patrimônio',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nomeCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: localCtrl,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              TextField(
                controller: respCtrl,
                decoration: const InputDecoration(labelText: 'Responsável'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final novoPatrimonio = Patrimonio(
                    id: patrimonio?.id,
                    nome: nomeCtrl.text,
                    descricao: descCtrl.text,
                    local: localCtrl.text,
                    responsavel: respCtrl.text,
                  );

                  if (isEditing && patrimonio.id != null) {
                    controller.editar(patrimonio.id!, novoPatrimonio);
                  } else {
                    controller.adicionar(novoPatrimonio);
                  }
                },
                child: Text(isEditing ? 'Salvar' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}