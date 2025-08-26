class Message {
  final String id;
  final String text;
  final String textColor;
  final String backgroundColor;
  final double scrollSpeed; // 1-10 scale, 1 being slowest

  const Message({
    required this.id,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.scrollSpeed,
  });

  // Create a new message
  factory Message.create({
    required String text,
    required String textColor,
    required String backgroundColor, //sdasdasdasd
    required double scrollSpeed,
  }) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Create a message from a template
  factory Message.fromTemplate({
    required String text,
    String textColor = '#FFD700', // Default gold color
    String backgroundColor = '#000000', // Default black background
    double scrollSpeed = 5.0, // Default medium speed
  }) {
    return Message.create(
      text: text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Update the message text
  Message updateText(String newText) {
    return Message(
      id: id,
      text: newText,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Update the text color
  Message updateTextColor(String newColor) {
    return Message(
      id: id,
      text: text,
      textColor: newColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Update the background color
  Message updateBackgroundColor(String newColor) {
    return Message(
      id: id,
      text: text,
      textColor: textColor,
      backgroundColor: newColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Update the scroll speed
  Message updateScrollSpeed(double newSpeed) {
    return Message(
      id: id,
      text: text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: newSpeed,
    );
  }

  // For JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'textColor': textColor,
      'backgroundColor': backgroundColor,
      'scrollSpeed': scrollSpeed,
    };
  }

  // From JSON deserialization
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      textColor: json['textColor'] as String,
      backgroundColor: json['backgroundColor'] as String,
      scrollSpeed: json['scrollSpeed'] as double,
    );
  }
}
