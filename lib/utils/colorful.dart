/// Print colorful message in the terminal
class Colorful {
  static const String reset = "\x1B[0m";

  // Define colors
  static const String black = "\x1B[30m";
  static const String red = "\x1B[31m";
  static const String green = "\x1B[32m";
  static const String yellow = "\x1B[33m";
  static const String blue = "\x1B[34m";
  static const String magenta = "\x1B[35m";
  static const String cyan = "\x1B[36m";
  static const String white = "\x1B[37m";

  static void printBlack(String message) {
    _printWithColor(message, black);
  }

  static void printRed(String message) {
    _printWithColor(message, red);
  }

  static void printGreen(String message) {
    _printWithColor(message, green);
  }

  static void printYellow(String message) {
    _printWithColor(message, yellow);
  }

  static void printBlue(String message) {
    _printWithColor(message, blue);
  }

  static void printMagenta(String message) {
    _printWithColor(message, magenta);
  }

  static void printCyan(String message) {
    _printWithColor(message, cyan);
  }

  static void printWhite(String message) {
    _printWithColor(message, white);
  }

  static void _printWithColor(String message, String color) {
    print('$color$message$reset');
  }
}
