import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
      final sendReport = await send(message, smtpServer);

      // Verificar si el correo electrónico se envió con éxito
      if (sendReport != null) {
        print('Mensaje enviado con éxito');
      } else {
        print('Error al enviar el mensaje');
        throw Exception('Error al enviar el mensaje');
      }
    } on MailerException catch (e) {
      print('Error al enviar el mensaje: $e');
      throw Exception('Error al enviar el mensaje');
    }
  }
}

void main() async {
  // Reemplaza 'tucorreo@gmail.com' y 'tucontraseña' con tus credenciales
  final emailSender = EmailSender('tucorreo@gmail.com', 'tucontraseña');

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
