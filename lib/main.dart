import 'package:flutter/material.dart';
import 'create_voting_screen.dart';
import 'continue_voting_screen.dart';
import 'close_voting_screen.dart';
import 'results_screen.dart';
import 'voting_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VotingManager()),
      ],
      child: MaterialApp(
        title: 'Aplicación de Votación',
        debugShowCheckedModeBanner: false, // Esto elimina el banner de Debug
        theme: ThemeData(
          primarySwatch: Colors.red, // Ajustado a un tema con base roja
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo blanco
      body: SafeArea(
        child: SingleChildScrollView( // Permite el desplazamiento del contenido
          child: Column(
            children: <Widget>[
              header(),
              SizedBox(height: 30),
              buttonsColumn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        ClipPath(
          clipper: CustomClipperHalf(),
          child: Container(
            height: 250,
            color: Colors.red,
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          right: 20,
          child: Container(
            height: 180,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.how_to_vote, size: 80, color: Colors.red), // Icono en lugar de imagen
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VotApp',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonsColumn(BuildContext context) {
    final votingManager = Provider.of<VotingManager>(context);
    final bool isVotingActive = votingManager.currentVoting != null;

    return Column(
      children: <Widget>[
        createButton('Crear Nueva Votación', Icons.add, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateVotingScreen()),
          );
        }),
        createButton('Continuar Votación', Icons.play_arrow, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContinueVotingScreen()),
          );
        }, isEnabled: isVotingActive), // Deshabilitado si no hay votación activa
        createButton('Cerrar Votación', Icons.close, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CloseVotingScreen()),
          );
        }, isEnabled: isVotingActive), // Deshabilitado si no hay votación activa
        createButton('Consulta de Resultados', Icons.list, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsScreen()),
          );
        }),
      ],
    );
  }

// Tu función createButton original, modificada para manejar la deshabilitación
  Widget createButton(String text, IconData icon, VoidCallback onPress, {bool isEnabled = true}) {
    return GestureDetector(
      onTap: isEnabled ? onPress : null, // Deshabilitar el onPress si no está activo
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.red[100] : Colors.grey[300], // Color de fondo condicional
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (isEnabled) // Sombra solo si está habilitado
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isEnabled ? Colors.red[800] : Colors.grey[600]), // Color de icono condicional
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: isEnabled ? Colors.red[800] : Colors.grey[600], // Color de texto condicional
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class CustomClipperHalf extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
