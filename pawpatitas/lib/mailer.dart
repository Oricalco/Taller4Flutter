import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailSender {
  final String username;
  final String password;

  EmailSender(this.username, this.password);

  Future<void> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    final smtpServer = gmail(username, password);

    // Crear el mensaje
    final message = Message()
      ..from = Address(username, 'Tu Nombre')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      // Enviar el mensaje
      await send(message, smtpServer);

      // Si no se lanzó una excepción, entonces el mensaje se envió con éxito
      print('Mensaje enviado con éxito');
    } on MailerException catch (e) {
      print('Error al enviar el mensaje: $e');
      throw Exception('Error al enviar el mensaje');
    }
  }
}

void main() async {
  await dotenv.load(); // Cargar variables de entorno

  // Acceder a las variables de entorno
  final emailSender = EmailSender(
    dotenv.env['USERNAME'] ?? '',
    dotenv.env['PASSWORD'] ?? '',
  );

  try {
    await emailSender.sendEmail(
      recipient: 'destinatario@example.com',
      subject: 'Asunto del correo',
      body: 'Cuerpo del correo electrónico...',
    );
  } catch (e) {
    print('Error: $e');
  }
}
