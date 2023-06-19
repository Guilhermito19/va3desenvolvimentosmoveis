import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MenuApp());
}

class MenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Burguers',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MenuScreen(),
    );
  }
}

class ItemMenu {
  final String imagem;
  final String nome;
  final String descricao;
  final double preco;

  ItemMenu({
    required this.imagem,
    required this.nome,
    required this.descricao,
    required this.preco,
  });
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ItemMenu> itensMenu = [];

  @override
  void initState() {
    super.initState();
    carregarItensMenu();
  }

  Future<void> carregarItensMenu() async {
    try {
      String jsonString = await rootBundle.loadString('assets/menu.json');
      final jsonData = json.decode(jsonString) as List<dynamic>;
      final itens = jsonData.map((item) {
        return ItemMenu(
          imagem: item['imagem'],
          nome: item['nome'],
          descricao: item['descricao'],
          preco: item['preco'].toDouble(),
        );
      }).toList();

      setState(() {
        itensMenu = itens;
      });
    } catch (e) {
      print('Erro ao carregar os itens do menu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Burguers'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/hamburger.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'SABOROSO',
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4
                        ..color = Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'SABOROSO',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: itensMenu.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[400],
              ),
              itemBuilder: (context, index) {
                final item = itensMenu[index];
                final precoFormatado =
                    'R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}';
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[200]!, Colors.white],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      item.imagem,
                      width: 72,
                      height: 72,
                    ),
                    title: Text(item.nome),
                    subtitle: Text(item.descricao),
                    trailing: Text(
                      precoFormatado,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
