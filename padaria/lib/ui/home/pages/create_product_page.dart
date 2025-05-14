import 'package:flutter/material.dart';
import 'package:padaria/data/repositories/product_repository.dart';
import '../../../core/services/product_service.dart';
import '../../../data/models/product_model.dart';

class CreateProductPage extends StatefulWidget {
  final String? productId;
  const CreateProductPage({Key? key, this.productId}) : super(key: key);

  @override
  State<CreateProductPage> createState() => _CreateProductPage();
}

class _CreateProductPage extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _estoqueController = TextEditingController();

  String? _selectedGrupoId;
  bool _statusAtivo = true;

  List<Map<String, dynamic>> _grupos = [];
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _loadGrupos();
    if (widget.productId != null) {
      _loadProdutos(widget.productId!);
    }
  }

  Future<void> _loadGrupos() async {
    try {
      final grupos = await _productService.listGrupo();
      setState(() {
        _grupos = grupos;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _loadProdutos(String id) async {
    try {
      final response = await ProductRepository().getProductById(id);
      setState(() {
        _descricaoController.text = response.descricao;
        _valorController.text = response.valor.toString();
        _estoqueController.text = response.estoque.toString();
        _selectedGrupoId = response.grupoId;
        if (response.status == 1) {
          _statusAtivo = true;
        }
        if (response.status == 2) {
          _statusAtivo = false;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar produto: $e")));
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final model = ProductModel(
        objectId: widget.productId,
        descricao: _descricaoController.text,
        valor: double.parse(_valorController.text),
        estoque: int.parse(_estoqueController.text),
        grupoId: _selectedGrupoId!,
        // ignore: dead_code
        status: _statusAtivo ? 1 : 2,
      );

      try {
        if (widget.productId != null) {
          await _productService.updateProduct(model.objectId!, model.descricao,
              model.valor, model.status, model.grupoId, model.estoque);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Produto atualizado com sucesso !")));
        } else {
          await _productService.createProduct(model.descricao, model.valor,
              model.status, model.grupoId, model.estoque);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Produto cadastrado com sucesso !")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) =>
                      value!.isEmpty ? 'O Campo e obrigatório' : null,
                ),
                TextFormField(
                  controller: _valorController,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o Valor' : null,
                ),
                TextFormField(
                  controller: _estoqueController,
                  decoration: const InputDecoration(labelText: 'Estoque'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o estoque' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGrupoId,
                  hint: const Text("Selecione o grupo"),
                  items: _grupos.map<DropdownMenuItem<String>>((grupo) {
                    return DropdownMenuItem(
                      value: grupo['objectId'],
                      child: Text(grupo['descricao']),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() {
                    _selectedGrupoId = value;
                  }),
                  validator: (value) =>
                      value == null ? 'Selecione um grupo' : null,
                ),
                SwitchListTile(
                    title: const Text('Ativo'),
                    value: _statusAtivo,
                    onChanged: (value) {
                      setState(() {
                        _statusAtivo = value;
                      });
                    }),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _submit, child: const Text("Salvar")),
                if (widget.productId != null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                    'Deseja realmente excluir o produto?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Excluir"))
                                ],
                              ));
                      if (confirm == true) {
                        try {
                          await _productService
                              .deleteProduct(widget.productId!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Produto excluído com sucesso.')),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erro ao excluir: $e")));
                        }
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Excluir"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  )
              ],
            )),
      ),
    );
  }
}
