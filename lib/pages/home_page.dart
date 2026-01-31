import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/animated_avatar.dart';
import 'posts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  User? user;
  bool loading = false;

  void fetchUser() async {
    if (controller.text.isEmpty) return;
    setState(() {
      loading = true;
      user = null; // réinitialise l'ancien user
    });
    try {
      final u = await ApiService.getUser(int.parse(controller.text));
      setState(() => user = u);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
    setState(() => loading = false);
  }

  Widget info(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar avec mode loading
              AnimatedAvatar(loading: loading),
              const SizedBox(height: 20),
              const Text(
                "Hey User, Welcome Back! 👋",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Champ ID + bouton Get
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter your ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ElevatedButton(
                      onPressed: fetchUser,
                      child: const Text("Get"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Infos user affichées seulement si user != null
              if (user != null) ...[
                const SizedBox(height: 10),
                info("ID", user!.id.toString()),
                info("Name", user!.name),
                info("Email", user!.email),
                info("Phone", user!.phone),
                info("Company", user!.company),
                info("Website", user!.website),
                const SizedBox(height: 20),

                // Bouton pour aller voir les posts
                ElevatedButton.icon(
                  icon: const Icon(Icons.article),
                  label: const Text("Check your posts"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => PostsPage(user: user!),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
