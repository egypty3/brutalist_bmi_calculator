# Brutalist BMI Calculator: YouTube Series Master Plan

## 5-Episode Series Outline

**Target Duration per Episode:** ~10 Minutes

### **Episode 1: The Blueprint & The Aesthetic**
*   **Focus:** Introduction to the app's Neo-Brutalist concept, project structure, and the root application setup.
*   **Files Covered:** `lib/main.dart`
*   **Key Concepts:** Flutter initialization, global `MaterialApp` configuration, injecting design tokens (Google Fonts Lexend, high-contrast colors, custom scaffold background).

### **Episode 2: Crafting the Brutalist UI Components**
*   **Focus:** Building the reusable, custom widgets that give the app its signature "hard" aesthetic.
*   **Files Covered:** `lib/widgets/brutalist_widgets.dart`
*   **Key Concepts:** Using `Stack` for hard offsets, manipulating `Container` decorations for thick borders, dynamic text color inversion for accessibility.

### **Episode 3: The Engine Room – Math & Health Logic**
*   **Focus:** The domain logic underlying the application. Keeping math out of the UI.
*   **Files Covered:** `lib/utils/bmi_logic.dart`
*   **Key Concepts:** Static utility classes, implementing clinical formulas (BMI, Ideal Weight, Deurenberg Body Fat formula), mapping data ranges to UI colors using DTOs (`BMIResult`).

### **Episode 4: The Main Stage – User Input & State Management**
*   **Focus:** Setting up the main interactive screen where users enter their data.
*   **Files Covered:** `lib/screens/calculator_screen.dart` (State & Layout setup), `lib/utils/localization.dart`
*   **Key Concepts:** Managing state with `StatefulWidget`, building input sliders/forms using the custom Brutalist widgets, handling localization strings.

### **Episode 5: Animations, Results, & Final Polish**
*   **Focus:** Tying everything together, showing the calculated results dynamically, and adding the opening flair.
*   **Files Covered:** `lib/screens/calculator_screen.dart` (Results rendering), `lib/screens/splash_screen.dart`
*   **Key Concepts:** Connecting the `bmi_logic.dart` outputs to the UI, creating the animated `SplashScreen` introduction, final routing walkthrough.

---

## **Episode 1 Script: The Blueprint & The Aesthetic**

**Title Idea:** Building a Flutter App with ATTITUDE: Neo-Brutalist BMI Calculator (Ep. 1)
**Estimated Time:** 10 Minutes

### **[0:00 - 1:30] The Hook & Introduction**

**(Visual: High-energy montage of the Brutalist BMI Calculator app in action. Fast cuts highlighting the bright yellow, thick black borders, and heavy shadows.)**

**Host:** "Forget everything you know about soft, rounded, minimal app design. Today, we are building with *attitude*. Welcome to the Brutalist BMI Calculator series."

**(Visual: Host on camera, smiling.)**

**Host:** "Hey everyone! Over the next five episodes, we're going to tear down and rebuild a complete Flutter application from scratch. But this isn’t just any app. We are utilizing a design trend called 'Neo-Brutalism'—think stark contrasts, thick black borders, unapologetic typography, and hard shadows."

**(Visual: Screen recording showing the app transitioning from the splash screen to the main calculator interface.)**

**Host:** "In this series, we’ll dive deep into the codebase. You're going to learn how to structure a Flutter project cleanly, build reusable custom design system widgets, implement complex clinical math, and tie it all together with a beautiful, responsive UI." 

**Host:** "In this first episode, we're laying the foundation. We’ll look at the overall project architecture and break down our `main.dart` file to see how we inject this aggressive aesthetic globally right from the start. Let’s get into the code."

### **[1:30 - 3:30] Project Overview & Architecture**

**(Visual: Screen showing an IDE (like VS Code or Android Studio) with the project file tree expanded.)**

**Host:** "Alright, here is our project. A well-organized codebase is just as beautiful as a well-designed UI. Inside our `lib` folder, you can see I’ve broken things down logically:"

**(Visual: Zoom in on the specific folders as the host mentions them.)**

*   **Host:** "`screens/` holds our main views: the `splash_screen` and the `calculator_screen`."
*   **Host:** "`utils/` is the brains of the operation. This is where `bmi_logic.dart` lives, keeping our heavy math completely separated from our UI. We also have `localization.dart` here for handling text."
*   **Host:** "`widgets/` is our design system factory. `brutalist_widgets.dart` contains the custom containers and buttons we'll use everywhere."
*   **Host:** "And finally, at the root, we have `main.dart`."

**(Visual: Host on camera.)**

**Host:** "By keeping our logic (`utils`), our reusable building blocks (`widgets`), and our layouts (`screens`) separate, this app is incredibly easy to maintain and scale. But to make all these pieces look cohesive, we need to set the global stage. And that happens in `main.dart`."

### **[3:30 - 8:30] Deep Dive: `main.dart` & The Global Theme**

**(Visual: Screen switches to show the full code of `lib/main.dart`.)**

**Host:** "Let's open up `main.dart`. This file is the entry point of our entire application. Let's look at the `main()` function."

**(Visual: Highlight lines 22-24: `void main() { runApp(const BrutalBMICalculator()); }`)**

**Host:** "Standard Flutter stuff here. We initialize the engine and run our root widget, `BrutalBMICalculator`. But inside this stateless widget is where the magic happens."

**(Visual: Highlight the `build` method and the `MaterialApp` return.)**

**Host:** "We return a `MaterialApp`. Notice we aren't just letting Flutter use its default styles. Neo-Brutalism requires a specific vibe. So, we heavily customize the `ThemeData`."

**(Visual: Highlight `useMaterial3: true` and `scaffoldBackgroundColor: const Color(0xFFF0F0F0)`)**

**Host:** "First, we enable Material 3. Then, we set the `scaffoldBackgroundColor`. Instead of pure white, we use `0xFFF0F0F0`, which is a slightly off-white, light gray. Why? Because in Brutalism, we use pure white *inside* our content boxes, and we want them to pop against the background. It emphasizes the structural containers."

**(Visual: Highlight the typography section: `textTheme: GoogleFonts.lexendTextTheme()`)**

**Host:** "Next up: Typography. Brutalism is nothing without bold, readable, geometric fonts. We are importing the `google_fonts` package and applying `Lexend` globally. By doing it here in `main.dart`, every text widget in our app inherits this geometric character automatically. No need to style text individually everywhere."

**(Visual: Highlight the `colorScheme` section.)**

**Host:** "Now, the colors. We define our `ColorScheme` from a seed color. Our primary color is this vibrant, high-contrast Yellow (`0xFFFFDE59`), and we pair it with a stark Cyan (`0xFF5CE1E6`) as a secondary accent. When these colors are outlined with thick black borders later on, they scream 'Neo-Brutalism'."

**(Visual: Highlight `home: const SplashScreen()`)**

**Host:** "Finally, we set the `home` property to our `SplashScreen`. When the app launches, it immediately routes the user to our animated intro before they hit the calculator."

### **[8:30 - 10:00] Outro & What's Next**

**(Visual: Host on camera.)**

**Host:** "And just like that, our foundation is set. We have a cleanly structured project, and we've successfully injected our core design tokens—the Lexend font, the off-white scaffold, and our stark yellow and cyan palette—globally into the app."

**(Visual: Quick teaser montage of the `brutalist_widgets.dart` code and the UI elements with hard shadows.)**

**Host:** "But colors and fonts aren't enough to make it Brutalist. We need those thick borders and harsh shadows. In Episode 2, we are going to dive into the `widgets` folder and build our `BrutalistContainer` and `BrutalistButton` from scratch. We’ll learn how to manipulate the Flutter `Stack` widget to create that artificial 3D depth effect."

**(Visual: End screen with 'Subscribe', 'Next Episode' thumbnail, and social links.)**

**Host:** "You won't want to miss it. Make sure you subscribe so you get notified when Episode 2 drops. Let me know in the comments what your favorite design trend is right now. Thanks for watching, and I'll see you in the next one!"
