import 'message_model.dart';

class LedScrollerController {
  // Create a new message
  Message createMessage({
    required String text,
    required String textColor,
    required String backgroundColor,
    required double scrollSpeed,
  }) {
    return Message.create(
      text: text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Create a message from a template
  Message createMessageFromTemplate({
    required String templateName,
    required Map<String, String> templates,
    String textColor = '#FFD700',
    String backgroundColor = '#000000',
    double scrollSpeed = 5.0,
  }) {
    final text = templates[templateName] ?? 'Template not found';

    return Message.fromTemplate(
      text: text,
      textColor: textColor,
      backgroundColor: backgroundColor,
      scrollSpeed: scrollSpeed,
    );
  }

  // Update message text
  Message updateMessageText(Message message, String newText) {
    return message.updateText(newText);
  }

  // Update text color
  Message updateTextColor(Message message, String newColor) {
    return message.updateTextColor(newColor);
  }

  // Update background color
  Message updateBackgroundColor(Message message, String newColor) {
    return message.updateBackgroundColor(newColor);
  }

  // Update scroll speed
  Message updateScrollSpeed(Message message, double newSpeed) {
    return message.updateScrollSpeed(newSpeed);
  }

  // Calculate animation duration based on speed and text length
  Duration calculateAnimationDuration(Message message) {
    // Base duration in seconds
    const baseDuration = 15.0;

    // Adjust based on speed (1-10)
    // Speed 1 = longest duration, Speed 10 = shortest duration
    final speedFactor = (11 - message.scrollSpeed) / 5;

    // Adjust based on text length
    final lengthFactor = message.text.length / 20;

    // Calculate final duration
    final durationInSeconds = baseDuration * speedFactor * lengthFactor;

    // Ensure minimum and maximum duration
    final clampedDuration = durationInSeconds.clamp(5.0, 30.0);

    return Duration(seconds: clampedDuration.toInt());
  }
}
