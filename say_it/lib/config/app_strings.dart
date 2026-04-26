class AppStrings {
  static const Map<String, String> languages = {
    'en': 'English',
    'hi': 'हिंदी',
    'te': 'తెలుగు',
  };

  static const Map<String, String> en = {
    'appTitle': 'SayIt',
    'appSubtitle': 'Voice-Driven Onboarding',
    'selectLanguage': 'Select Language',
    'continueButton': 'Continue',
    'startButton': 'Start Onboarding',
    'nextButton': 'Next',
    'submitButton': 'Submit',
    'restartButton': 'Restart',
    'editButton': 'Edit',
    'recording': 'Recording...',
    'recording_stopped': 'Recording Stopped',
    'listening': 'Listening...',
    'processing': 'Processing...',
    'error': 'Error',
    'permission_denied': 'Microphone permission denied',
    'speech_not_available': 'Speech recognition not available',
    'question1': 'What is your name?',
    'question2': 'What are your skills?',
    'question3': 'Tell us about your experience',
    'question4': 'What motivates you?',
    'question5': 'Any additional comments?',
    'yourProfile': 'Your Profile',
    'name': 'Name',
    'skills': 'Skills',
    'experience': 'Experience',
    'motivation': 'What Motivates You',
    'comments': 'Additional Comments',
    'tapMic': 'Tap the microphone to speak',
    'editText': 'Edit text',
    'step': 'Step',
    'of': 'of',
    'loading': 'Loading...',
    'success': 'Success!',
    'tryAgain': 'Try Again',
  };

  static const Map<String, String> hi = {
    'appTitle': 'सेइट',
    'appSubtitle': 'वॉयस-ड्रिवन ऑनबोर्डिंग',
    'selectLanguage': 'भाषा चुनें',
    'continueButton': 'जारी रखें',
    'startButton': 'ऑनबोर्डिंग शुरू करें',
    'nextButton': 'अगला',
    'submitButton': 'जमा करें',
    'restartButton': 'पुनः शुरू करें',
    'editButton': 'संपादित करें',
    'recording': 'रिकॉर्डिंग...',
    'recording_stopped': 'रिकॉर्डिंग बंद',
    'listening': 'सुन रहे हैं...',
    'processing': 'प्रक्रिया जारी है...',
    'error': 'त्रुटि',
    'permission_denied': 'माइक्रोफ़ोन अनुमति अस्वीकृत',
    'speech_not_available': 'वाक् पहचान उपलब्ध नहीं है',
    'question1': 'आपका नाम क्या है?',
    'question2': 'आपके कौशल क्या हैं?',
    'question3': 'अपने अनुभव के बारे में बताएं',
    'question4': 'आपको क्या प्रेरित करता है?',
    'question5': 'कोई अतिरिक्त टिप्पणी?',
    'yourProfile': 'आपकी प्रोफाइल',
    'name': 'नाम',
    'skills': 'कौशल',
    'experience': 'अनुभव',
    'motivation': 'आपको क्या प्रेरित करता है',
    'comments': 'अतिरिक्त टिप्पणीयां',
    'tapMic': 'बोलने के लिए माइक्रोफ़ोन को टैप करें',
    'editText': 'पाठ संपादित करें',
    'step': 'चरण',
    'of': 'का',
    'loading': 'लोड हो रहा है...',
    'success': 'सफलता!',
    'tryAgain': 'फिर से कोशिश करें',
  };

  static const Map<String, String> te = {
    'appTitle': 'సేఐట్',
    'appSubtitle': 'వాయిస్-డ్రివెన్ ఆన్‌బోర్డింగ్',
    'selectLanguage': 'భాషను ఎంచుకోండి',
    'continueButton': 'కొనసాగించండి',
    'startButton': 'ఆన్‌బోర్డింగ్ ప్రారంభించండి',
    'nextButton': 'తరువాత',
    'submitButton': 'సమర్పించండి',
    'restartButton': 'పునः ప్రారంభించండి',
    'editButton': 'సవరించండి',
    'recording': 'రికార్డింగ్...',
    'recording_stopped': 'రికార్డింగ్ ఆపబడింది',
    'listening': 'వింటున్నాను...',
    'processing': 'ప్రక్రియ జరుగుతుంది...',
    'error': 'లోపం',
    'permission_denied': 'మైక్రోఫోన్ అనుమతి నిరాకరించబడింది',
    'speech_not_available': 'ప్రసంగ గుర్తింపు అందుబాటులో లేదు',
    'question1': 'మీ పేరు ఏమిటి?',
    'question2': 'మీ నైపుణ్యాలు ఏమిటి?',
    'question3': 'మీ అనుభవం గురించి చెప్పండి',
    'question4': 'మీకు ఏమి ప్రేరణ ఇస్తుంది?',
    'question5': 'ఏదైనా అదనపు వ్యాఖ్యలు?',
    'yourProfile': 'మీ ప్రొఫైల్',
    'name': 'పేరు',
    'skills': 'నైపుణ్యాలు',
    'experience': 'అనుభవం',
    'motivation': 'మీకు ఏమి ప్రేరణ ఇస్తుంది',
    'comments': 'అదనపు వ్యాఖ్యలు',
    'tapMic': 'మాట్లాడటానికి మైక్రోఫోన్‌ను నొక్కండి',
    'editText': 'వచనాన్ని సవరించండి',
    'step': 'దశ',
    'of': 'యొక్క',
    'loading': 'లోడ్ చేస్తుంది...',
    'success': 'విజయం!',
    'tryAgain': 'మళ్లీ ప్రయత్నించండి',
  };

  static String getString(String key, String languageCode) {
    final strings = _getStringsForLanguage(languageCode);
    return strings[key] ?? key;
  }

  static Map<String, String> _getStringsForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return hi;
      case 'te':
        return te;
      default:
        return en;
    }
  }
}