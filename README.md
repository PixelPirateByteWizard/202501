# Solakai - Smart Calendar & Scheduling

A Flutter-based AI-powered calendar application that proactively plans your time and optimizes your schedule.

## Features

### 🗓️ Agenda Screen
- **Today & Tomorrow View**: Clear timeline of upcoming events
- **Enhanced Voice Input**: Tap-to-speak with AI assistant integration
- **Now Card**: Shows current activity or "all caught up" status
- **Event Timeline**: Color-coded events with category indicators
- **Smart Conflict Detection**: Visual warnings with resolution suggestions
- **Quick Event Creation**: Floating action button for manual event addition

### 🔥 Forge Screen
- **Week Heatmap**: Visual representation of your weekly schedule density
- **Dynamic AI Suggestions**: Context-aware recommendations based on current schedule
- **Quick Action Cards**: Add focus time and optimize schedule with one tap
- **Efficiency Metrics**: Shows potential productivity gains with percentages
- **Real-time Updates**: Suggestions update automatically when schedule changes
- **Conflict Resolution**: Smart suggestions for resolving scheduling overlaps

### 🤖 AI Assistant
- **Natural Language Processing**: Chat with your calendar using natural language
- **Voice-to-Event Creation**: Speak naturally to create calendar events
- **DeepSeek Integration**: Powered by DeepSeek AI for intelligent responses
- **Contextual Awareness**: AI understands your schedule and preferences
- **Interactive Quick Actions**: Tap buttons to add events directly from chat
- **Intent Recognition**: Distinguishes between questions and event creation commands
- **Smart Event Parsing**: Extracts date, time, duration, and category from speech

### ⚙️ Settings
- **Profile Management**: User account and preferences
- **Notification Controls**: Customize alerts and reminders
- **AI Configuration**: Toggle AI features and voice control
- **Sync Settings**: Calendar synchronization options

## Architecture

### Clean Architecture Principles
- **Models**: Data structures for events, suggestions, and chat messages
- **Providers**: State management using Provider pattern
- **Services**: Business logic and API integrations
- **Widgets**: Reusable UI components
- **Screens**: Main application screens

### Key Components
```
lib/
├── models/           # Data models
├── providers/        # State management
├── services/         # Business logic & API calls
├── screens/          # Main app screens
├── widgets/          # Reusable UI components
└── theme/           # App theming and colors
```

## Technology Stack

- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **HTTP**: API communication
- **DeepSeek AI**: Natural language processing
- **Material Design**: UI components

## Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd Solakai
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

The app includes mock data for demonstration. To integrate with real services:

1. **DeepSeek AI**: Update the API key in `lib/services/ai_service.dart`
2. **Calendar Integration**: Implement calendar sync in `lib/services/event_service.dart`
3. **Voice Recognition**: Configure speech-to-text permissions

## 🚀 Latest Enhancements

### 🎤 Advanced Voice Integration
- **Seamless AI Connection**: Voice input directly opens AI chat for natural conversation
- **Smart Intent Detection**: Automatically recognizes event creation vs. questions
- **Real-time Processing**: Visual feedback during voice recognition
- **Natural Language Understanding**: Create events using conversational speech

### 🔄 Data Synchronization
- **Unified State Management**: Agenda and Forge screens share real-time data
- **Dynamic AI Suggestions**: Recommendations update based on current schedule
- **Conflict Intelligence**: Automatic detection with smart resolution options
- **Cross-Screen Updates**: Changes reflect instantly across all screens

### 🤖 Enhanced AI Capabilities
- **Context-Aware Suggestions**: AI analyzes your schedule patterns
- **Event Parsing**: Extracts title, time, duration, and category from natural language
- **Quick Action Buttons**: One-tap event creation from AI conversations
- **Intelligent Optimization**: Suggests focus time, breaks, and meeting consolidation

## Core Features Implementation

### Event Management
- Create, read, update, delete events with conflict detection
- Category-based organization (Work, Meeting, Focus, Personal)
- Automatic conflict resolution with smart suggestions
- Duration, location, and video call tracking
- Available time slot detection

### AI Integration
- Natural language event creation with voice input
- Dynamic schedule optimization suggestions
- Intelligent conflict resolution with improvement metrics
- Proactive time management and break suggestions
- Context-aware chat interactions

### Voice Interface
- Voice-to-text event creation with AI processing
- Hands-free calendar interaction through natural speech
- Real-time voice feedback with visual indicators
- Intent recognition for commands vs. questions

## Design Philosophy

**From Passive Recording to Active Planning**: Solakai transforms calendar management from a reactive tool to a proactive assistant that anticipates needs and optimizes schedules.

### Key Principles
- **Minimal Friction**: Voice-first interaction reduces input barriers
- **Intelligent Automation**: AI handles routine scheduling decisions
- **Visual Clarity**: Clean, dark theme with gradient accents
- **Contextual Awareness**: System understands user patterns and preferences

## Future Enhancements

- [ ] Calendar sync with Google/Outlook
- [ ] Team collaboration features
- [ ] Advanced AI scheduling algorithms
- [ ] Wearable device integration
- [ ] Meeting room booking
- [ ] Travel time calculation
- [ ] Smart notification timing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.