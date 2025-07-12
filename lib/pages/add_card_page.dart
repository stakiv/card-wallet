import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wallet/pages/add_card_info_page.dart';

class MyAddCardPage extends StatefulWidget {
  const MyAddCardPage({super.key});

  @override
  State<MyAddCardPage> createState() => _MyAddCardPageState();
}

class _MyAddCardPageState extends State<MyAddCardPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> shops = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    try {
      final data =
          await supabase.from('shops').select().order('name', ascending: true)
              as List<dynamic>;
      print(data);
      setState(() {
        shops = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (error) {
      print('Ошибка загрузки магазинов: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 218, 218, 1),
      appBar: AppBar(
        title: const Text('Добавление карты'),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  final name = shop['name'] ?? 'Без названия';
                  final image = shop['image_url'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MyAddCardInfoPage(
                                shopName: name,
                                shopImg: image,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          name,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
