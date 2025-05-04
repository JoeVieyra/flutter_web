import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Post> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarPosts();
  }

  Future<void> _cargarPosts() async {
    try {
      final data = await PostService.fetchPosts();
      setState(() {
        _posts = data.take(20).toList(); // Solo los primeros 20
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar los datos')));
    }
  }

  void _mostrarDialogo({Post? post}) {
    final titleCtrl = TextEditingController(text: post?.title ?? '');
    final bodyCtrl = TextEditingController(text: post?.body ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(post == null ? 'Nueva publicación' : 'Editar publicación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: bodyCtrl, decoration: InputDecoration(labelText: 'Contenido')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty || bodyCtrl.text.isEmpty) return;

              if (post == null) {
                final nueva = await PostService.createPost(Post(id: 0, title: titleCtrl.text, body: bodyCtrl.text));
                setState(() => _posts.insert(0, nueva));
              } else {
                final actualizado = Post(id: post.id, title: titleCtrl.text, body: bodyCtrl.text);
                await PostService.updatePost(actualizado);
                setState(() {
                  final index = _posts.indexWhere((p) => p.id == post.id);
                  _posts[index] = actualizado;
                });
              }
              Navigator.pop(context);
            },
            child: Text(post == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminar(int id) async {
    await PostService.deletePost(id);
    setState(() {
      _posts.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Servicios')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (_, i) {
                final post = _posts[i];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(post.title, style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(post.body),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _mostrarDialogo(post: post),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminar(post.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogo(),
        child: Icon(Icons.add),
      ),
    );
  }
}
