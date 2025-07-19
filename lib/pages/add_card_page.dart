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
  String searchQuery = '';
  late List<Map<String, dynamic>> _searchedShops = [];
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
        _searchedShops = shops;
        isLoading = false;
      });
    } catch (error) {
      print('Ошибка загрузки магазинов: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchShops(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchedShops = shops;
      } else {
        final queryToLower = query.toLowerCase();
        _searchedShops =
            shops.where((shop) {
              final nameMatches = shop['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
              final engNameMatches = shop['eng_name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
              return nameMatches || engNameMatches;
            }).toList();
      }
    });
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
              : Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    height: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 330.0,
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              filled: true,
                              hintText: "Поиск по магазинам...",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(118, 118, 118, 1),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(118, 118, 118, 1),
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 13.0,
                                horizontal: 13.0,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                _searchShops(searchQuery);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchedShops.length,
                      itemBuilder: (context, index) {
                        final shop = _searchedShops[index];
                        final name = shop['name'] ?? 'Без названия';
                        final engName = shop['eng_name'] ?? 'Без названия';
                        final image = shop['image_url'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyAddCardInfoPage(
                                      shopName: name,
                                      shopEngName: engName,
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
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
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
