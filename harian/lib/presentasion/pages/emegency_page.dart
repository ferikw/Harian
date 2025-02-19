import 'package:flutter/material.dart';
import '../controllers/emergency_controller.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({Key? key}) : super(key: key);
  static const routeName = '/emergency';

  @override
  Widget build(BuildContext context) {
    final controller = EmergencyController();

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Teman Bantu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Akses fitur chat AI kami dan dapatkan bantuan nomor penting',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Chat AI',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.openChatPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4CFC),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/chat.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 0),
                      const Expanded(
                        child: Text(
                          'Chat AI - Diskusi Yuk',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => controller.openChatPage(context),
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                          overlayColor: WidgetStatePropertyAll(Colors.grey),
                        ),
                        icon: const ImageIcon(
                          AssetImage('assets/icons/message.png'),
                          size: 24,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Telepon Darurat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                EmergencyCard(
                  imagePath: 'assets/icons/ambulance.png',
                  title: 'Ambulans',
                  number: '118 atau 119',
                  color: Colors.red,
                ),
                EmergencyCard(
                  imagePath: 'assets/icons/truck.png',
                  title: 'Pemadam Kebakaran',
                  number: '113',
                  color: Colors.orange,
                ),
                EmergencyCard(
                  imagePath: 'assets/icons/hospital.png',
                  title: 'Palang Merah Indonesia',
                  number: '(021) 7992325',
                  color: Colors.amber,
                ),
                EmergencyCard(
                  imagePath: 'assets/icons/police.png',
                  title: 'Polisi',
                  number: '110',
                  color: Colors.blue,
                ),
                EmergencyCard(
                  imagePath: 'assets/icons/call.png',
                  title: 'Nomor Darurat Indonesia',
                  number: '112',
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String number;
  final Color color;

  const EmergencyCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.number,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(number),
        onTap: () {},
      ),
    );
  }
}
