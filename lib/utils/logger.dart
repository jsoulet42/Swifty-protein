import 'dart:developer' as dev;

/// CLASSE LOGGER : CENTRALISE TOUTES LES OPÉRATIONS DE LOG
///
/// UTILISATION : Appeler Logger.log('votre message', tag: 'TAG_OPTIONNEL');
class Logger {
  /// Log un message en affichant à la fois via [dev.log] et [print].
  ///
  /// [message] : Le message à loguer.
  /// [tag] : Une étiquette pour identifier l'origine du log.
  static void log(String message, {String tag = 'APP'}) {
    // Affiche le log dans la console de débogage
    dev.log(message, name: tag);
    // Pour s'assurer que le log est visible dans le terminal
    // (en mode debug, [print] est généralement visible)
    print("[$tag] $message");
  }
}
