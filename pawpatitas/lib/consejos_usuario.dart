import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsejosUsuario extends StatefulWidget {
  @override
  _ConsejosUsuarioState createState() => _ConsejosUsuarioState();
}

class _ConsejosUsuarioState extends State<ConsejosUsuario> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('consejos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs;

        if (docs == null || docs.isEmpty) {
          return Center(
            child:
                Text('No hay consejos disponibles en la colección "consejos"'),
          );
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final contenido = data['Contenido'] ?? 'Contenido no disponible';

              return Column(
                children: [
                  ListTile(
                    title: Text('Consejo:'),
                    subtitle: Text(contenido),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (index > 0)
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      Text('${index + 1} / ${docs.length}'),
                      if (index < docs.length - 1)
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
