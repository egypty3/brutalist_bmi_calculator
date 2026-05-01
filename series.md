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

## **نص الحلقة 1: المخطط الجمالي والتصميم (بالعامية المصرية)**

فكرة العنوان: بناء تطبيق فلاتر "بشخصية جامدة": حاسبة الـ BMI بستايل الـ Neo-Brutalism (حلقة 1)
الوقت المقدر: 10 دقايق

### **[0:00 - 1:30] الدخلة والمقدمة**

(لقطات سريعة لتطبيق حاسبة الـ BMI وهو شغال، مع تركيز على الألوان الجريئة والستايل المختلف.)

السلام عليكم يا جماعة، إزيكم؟ يارب تكونوا بخير دايمًا. بصوا، النهاردة هنتكلم عن حاجة مختلفة شوية عن اللي متعودين عليه في عالم التطبيقات. معظم التطبيقات اللي بنشوفها بتكون هادية وألوانها بسيطة، بس إحنا هنا قررنا نعمل حاجة ليها شخصية قوية وتشد العين من أول نظرة. في السلسلة دي، هنتعلم مع بعض إزاي نبني تطبيق حاسبة BMI بستايل الـ Brutalist، اللي بيعتمد على ألوان واضحة وحدود سميكة وخطوط جريئة. 

على مدار خمس حلقات، هنتعمق في كل تفصيلة من أول فكرة المشروع لحد ما التطبيق يبقى جاهز للاستخدام. مش بس كده، كمان هنتعلم إزاي نخلي الكود منظم وسهل التطوير بعد كده. يلا بينا نبدأ الرحلة دي سوا.

### **[1:30 - 3:30] نظرة عامة على المشروع والمعمارية**

(شاشة بتورينا الـ IDE وقايمة ملفات المشروع مفتوحة.)

أول حاجة، تعالوا نبص على تقسيمة المشروع. جوه فولدر الـ `lib`، هتلاقوا الدنيا متقسمة كده:

- `screens/` فيها الشاشات الأساسية: الـ `splash_screen` والـ `calculator_screen`.
- `utils/` ودي فيها كل الحسابات والمعادلات اللي بعيد عن الواجهة.
- `widgets/` هنا بنحط كل العناصر اللي بنعيد استخدامها زي الكانتينرز والأزرار.
- وفي الآخر خالص، في الروت، عندنا ملف الـ `main.dart`.

لما بنفصل بين المنطق بتاعنا (`utils`) وعناصر البناء اللي بنعيد استخدامها (`widgets`) والشاشات (`screens`)، التطبيق بيبقى سهل جدًا في الصيانة والتطوير. وعلشان كل حاجة تشتغل مع بعض كويس، لازم نبدأ من فوق ونظبط الأساس في `main.dart`.

### **[3:30 - 8:30] غطس جوه الكود: `main.dart` والسمة العامة (Global Theme)**

(الشاشة بتتحول عشان تورينا الكود كامل في `lib/main.dart`.)

تعالوا نفتح `main.dart`. الملف ده هو باب الدخول للتطبيق كله. خلينا نبص على دالة الـ `main()`.

(تمييز السطور 22-24: `void main() { runApp(const BrutalBMICalculator()); }`)

كود فلاتر العادي خالص. بنشغل المحرك وننادي على الـ Root Widget بتاعنا، `BrutalBMICalculator`. بس جوه الـ Stateless Widget ده، هو ده مكان السحر.

(تمييز دالة الـ `build` والـ `MaterialApp` اللي راجعة.)

إحنا بنرجع `MaterialApp`. خد بالك إننا مش سايبين فلاتر يستخدم الستايل الافتراضي بتاعه. الـ Neo-Brutalism محتاج روح معينة، عشان كده بنغير في الـ `ThemeData` بشكل كبير.

(تمييز `useMaterial3: true` والـ `scaffoldBackgroundColor: const Color(0xFFF0F0F0)`)

أول حاجة، بنفعل الـ Material 3. بعدين بنحدد لون خلفية الـ Scaffold. وبدل ما نستخدم الأبيض الصريح، بنستخدم `0xFFF0F0F0` وده رمادي فاتح أوي مائل للأبيض. ليه؟ عشان في الـ Brutalism بنستخدم الأبيض الصريح *جوه* صناديق المحتوى، وعايزينها 'تنطق' وتظهر بوضوح قدام الخلفية.

(تمييز جزء الخطوط: `textTheme: GoogleFonts.lexendTextTheme()`)

اللي بعده: الخطوط. الـ Brutalism ميسواش حاجة من غير خطوط هندسية جرئية وواضحة. إحنا بنستخدم باكيدج الـ `google_fonts` وبنطبق خط `Lexend` على التطبيق كله. وبما إننا عملنا كده في الـ `main.dart` ، فكل نص في التطبيق هياخد الشخصية دي أوتوماتيك.. مش محتاج تظبط الخط في كل شاشة لوحدها.

(تمييز جزء الـ `colorScheme`.)

نيجي بقى للألوان. بنعرف الـ `ColorScheme` بتاعنا من لون أساسي. لوننا الأساسي هو الأصفر الفاقع ده (`0xFFFFDE59`) ، وبنحط معاه لون سيان (Cyan) حاد (`0xFF5CE1E6`) كألوان ثانوية. لما الألوان دي يتحط حواليها البرواز الأسود التخين اللي هنعمله، هتعرفوا فعلاً يعني إيه 'Neo-Brutalism'.

(تمييز `home: const SplashScreen()`)

وفي الآخر، بنخلي الـ `home` هو الـ `SplashScreen`. أول ما التطبيق يفتح، بيدخل المستخدم على المقدمة المتحركة بتاعتنا قبل ما يوصلوا للحاسبة.

### **[8:30 - 10:00] الخلاصة واللي جاي**

دلوقتي إحنا رتبنا الأساس بتاعنا. عندنا مشروع منظم، وحطينا لمسات الديزاين الأساسية — خط Lexend، وخلفية الـ Scaffold، وباليتة الألوان القوية — في التطبيق كله. في الحلقة الجاية، هنتكلم عن إزاي نبني عناصر الواجهة اللي ليها طابع Brutalist حقيقي. تابعونا علشان نكمل المشوار سوا.

---

## **نص الحلقة 2: إزاي تعمل ويدجتس (Widgets) بستايل الـ Brutalist**

**فكرة العنوان:** أزرار وكانتينرز بـ "عضلات": بناء الـ UI الـ Brutalist في فلاتر (حلقة 2)
**الوقت المقدر:** 10 دقايق

### **[0:00 - 1:30] مقدمة الحلقة: الـ UI اللي ليه شخصية**

إزيكم يا جماعة؟ مستعدين نكمل مع بعض رحلتنا في عالم الـ Brutalist؟ في الحلقة اللي فاتت، حطينا الأساس للتطبيق بتاعنا. النهاردة بقى هنتكلم عن حاجة مهمة أوي.. إزاي نبني ويدجتس (Widgets) تعبر عن ستايل الـ Brutalist.

الـ Brutalism مش بس تصميم، ده كمان طريقة للتفكير في إزاي العناصر تتفاعل مع بعضها. يعني إيه؟ يعني الأزرار، الكانتينرز، وكل عنصر في التطبيق لازم يكون ليه شخصية واضحة ويفضل ثابت على طول. يلا بينا نبدأ.

### **[1:30 - 5:30] الـ BrutalistContainer: سر الـ Stack والـ Offset**

(مرئي: كود ملف `lib/widgets/brutalist_widgets.dart` مع تركيز على كلاس `BrutalistContainer`.)

أول عنصر هنتكلم عليه هو الـ `BrutalistContainer`. لو بصيتوا على الكود، هتلاقوني مش مستخدم `BoxShadow` العادي بتاع فلاتر.. ليه؟ لأن الـ `BoxShadow` بيدي ضل ناعم (Blurred) ، وإحنا في الـ Brutalism عايزين ضل 'ناشف' وصريح.

عشان كده استخدمنا الـ `Stack`. الفكرة ببساطة إننا بنحط اتنين `Container` فوق بعض. اللي تحت لونه أسود وبنرحله شوية باستخدام `shadowOffset`. واللي فوق هو اللي فيه المحتوى واللون اللي إحنا عايزينه. الحركة دي بتدي تأثير الـ 3D اللي بنسميه 'Hard Shadow'.

لاحظوا كمان إننا استخدمنا `Border.all` بـ `width` كبير (مثلاً 3 بيكسل) عشان ندي البرواز الأسود السميك اللي بيحدد كل عنصر في التطبيق. الـ `borderRadius` هنا اختياري، بس أنا خليته 12 عشان يكسر حدة الديزاين شوية ويخليه مودرن أو Neo-Brutalist.

### **[5:30 - 8:30] الـ BrutalistButton: الذكاء في الألوان والتفاعل**

(مرئي: تمرير الكود لأسفل للوصول لـ `BrutalistButton`.)

تاني عنصر معانا هو الـ `BrutalistButton`. وده بقى تطوير للكانتينر اللي عملناه. هو عبارة عن `BrutalistContainer` بس ضفناله `onTap` عشان المستخدم يقدر يدوس عليه.

بس في حركة ذكية عملناها هنا في التكست.. بصوا على السطر ده: `color: color == Colors.black ? Colors.white : Colors.black`. ليه عملنا كده؟ عشان لو قررنا نخلي الزرار لونه أسود، الكلام يقلب أبيض لوحده أوتوماتيك. دي لمسة بسيطة بس بتبين إنك فاهم إنت بتعمل إيه في الـ Accessibility والـ Readability.

استخدمنا كمان `FontWeight.w900` عشان التكست يبقى 'تقيل' وماشي مع الروح العامة للتطبيق. الأزرار دي هي اللي هتخلي المستخدم يحس إنه بيتعامل مع تطبيق قوي وله طابع خاص.

### **[8:30 - 10:00] الخلاصة وما سيأتي**

بقى معانا دلوقتي 'مكعبات الليجو' اللي هنبني بيها التطبيق كله. أي حاجة تانية بعد كده هتبقى سهلة لأننا عملنا الـ Base صح. الحلقة الجاية بقى هنروح لمنطقة تانية خالص.. منطقة المعادلات والحسابات. هعرفكم إزاي تحسبوا الـ BMI والـ Fat Percentage بدقة طبية.

لو عجبكم الفيديو لحد دلوقتي، متنسوش تعملوا سبسكرايب وتفعلوا الجرس عشان يجيلكم تنبيه لما الحلقة التالتة تنزل. أشوفكم على خير!

---

## **نص الحلقة 3: "غرفة المحركات" - المعادلات الطبية والمنطق**

**فكرة العنوان:** مش مجرد ديزاين.. دي حسابات دقيقة: كود الـ BMI والـ Health Logic (حلقة 3)
**الوقت المقدر:** 10 دقايق

### **[0:00 - 2:00] مقدمة: ليه بنفصل المنطق عن الـ UI؟**

أهلاً بيكم في الحلقة التالتة! النهاردة هنبطل تلوين ورسم شوية، وهنفتح 'دماغ' التطبيق. هنتكلم عن المنطق اللي بيشغل الليلة دي كلها. وعشان إحنا مبرمجين شاطرين، لازم نطبق مبدأ الـ Separation of Concerns.

مينفعش أحط معادلات رياضية معقدة وسط كود الـ UI. إحنا عايزين الـ Widgets تبقى وظيفتها 'العرض' بس، أما 'الحسابات' فليها مكانها الخاص في فولدر الـ `utils`.

### **[2:00 - 6:00] الـ BMICalculator: الدقة في المعادلات**

(مرئي: كود ملف `lib/utils/bmi_logic.dart`.)

تعالوا نفتح ملف `bmi_logic.dart`. عملنا كلاس اسمه `BMICalculator` وكل الدوال اللي جواه `static`.. ليه؟ عشان مش محتاجين ناخد `Instance` من الكلاس ده، إحنا بس عايزين نستخدمه كأنه 'آلة حاسبة' سريعة.

أول دالة هي `calculateBMI`. بسيطة؟ آه، بس لاحظوا إننا بنقسم الطول على 100 عشان نحوله من سنتيمتر لمتر، لأن المعادلة العالمية بتقول: الوزن على مربع الطول بالمتر.

تاني دالة ودي المهمة جداً هي `estimateFatPercentage`. هنا إحنا بنستخدم معادلة 'Deurenberg' الشهيرة. المعادلة دي مش بس بتعتمد على الـ BMI، لا دي بتدخل السن والنوع في الحسابات. وده اللي بيدي التطبيق بتاعنا قيمة حقيقية للمستخدم، إنه بيعرف نسبة الدهون التقريبية في جسمه.

### **[6:00 - 9:00] الـ Classification والـ DTOs**

المضيف: "طيب، حسبنا الأرقام.. هنعمل بيها إيه؟ إحنا عايزين نطلع للمستخدم وصف لحالته وكمان نغير لون الواجهة بناءً على النتيجة. وعشان كده عملنا دالة `getClassification`."

المضيف: "الدالة دي بترجع كائن من نوع `BMIResult`.. وده بنسميه DTO أو Data Transfer Object. الكلاس ده شايل حاجتين: الـ `key` بتاع الترجمة (عشان التطبيق يدعم لغات تانية) والـ `color` المناسب. يعني لو الـ BMI عالي أوي، اللون يقلب أحمر صريح عشان ينبه المستخدم."

المضيف: "استخدمنا ألوان Brutalist صريحة زي الـ `Color(0xFFD32F2F)` للأوبسيتي (Obesity) ، والـ `Color(0xFF4CAF50)` للوزن الطبيعي. كده إحنا ربطنا المنطق الطبي بالألوان اللي المستخدم هيشوفها."

### **[9:00 - 10:00] الخلاصة**

دلوقتي 'العقل' بتاع التطبيق بقى شغال وجاهز. عرفنا إزاي نحسب الأرقام ونحولها لبيانات مفيدة للمستخدم. الحلقة الجاية بقى هنربط 'العقل' ده بـ 'العضلات' اللي عملناها في الحلقة اللي فاتت ونبني الشاشة الرئيسية. استنوني!

---

## **نص الحلقة 4: "المسرح الأساسي" - مدخلات المستخدم والـ State**

**فكرة العنوان:** إزاي تخلي التطبيق يتفاعل معاك: السلايدرز، الفورمز، والـ State (حلقة 4)
**الوقت المقدر:** 10 دقايق

### **[0:00 - 2:30] مقدمة: شاشة الحاسبة والـ StatefulWidget**

وصلنا للمحطة القبل أخيرة! النهاردة هنبني القلب النابض للتطبيق.. شاشة الحاسبة. الشاشة دي هي اللي بتربط كل اللي اتعلمناه في الحلقات اللي فاتت مع بعضه.

بما إن المستخدم هيغير قيم زي الطول والوزن طول الوقت، فإحنا أكيد محتاجين `StatefulWidget`. تعالوا نفتح `calculator_screen.dart` ونشوف إزاي بنهندل الـ State.

### **[2:30 - 6:30] إدارة البيانات والـ `_calculate()`**

(مرئي: كود `_CalculatorScreenState` مع التركيز على المتغيرات ودالة `_calculate`.)

عندنا متغيرات للسن، الطول، الوزن، والنوع. لاحظوا إننا كل ما بنغير أي قيمة من دول، بننادي على دالة اسمها `_calculate()` جوه `setState`. الدالة دي بتروح تنادي على كلاس الـ `BMICalculator` اللي عملناه وتحدث النتايج أوتوماتيك.

كمان ضفنا دعم لتحويل الوحدات! يعني تقدر تحسب بالـ Metric (كيلوجرام وسنتيمتر) أو بالـ Imperial (باوند وقدم). الحركة دي بتخلي التطبيق بتاعك 'عالمي' وجاهز لأي مستخدم في أي حتة في الدنيا.

### **[6:30 - 8:30] الـ UI المليان تفاصيل: السلايدرز والكروت**

(مرئي: استعراض الـ Widgets في دالة الـ `build`.)

بصوا على الترتيب.. استخدمنا `BrutalistContainer` عشان نغلف كل جزء. عندنا كروت لاختيار النوع (ذكر/أنثى) بتغير لونها لما تدوس عليها. وعندنا سلايدر (Slider) للطول لونه أسود فاحم عشان يكسر اللون الأبيض بتاع الخلفية.

والأهم من ده كله هو الـ `Directionality` ويدجت. دي بتخلي التطبيق بتاعنا يدعم اللغات اللي بتتكتب من اليمين للشمال زي العربي (RTL) بشكل ديناميكي بناءً على اللغة اللي المستخدم بيختارها. ده احتراف بجد!

### **[8:30 - 10:00] الخلاصة وما سيأتي**

التطبيق بقى شغال 100% وبياخد بيانات وبيحسب نتايج حقيقية. الحلقة الجاية هي 'الفنش' الأخير.. هنعمل شاشة نتايج تبهر المستخدم ونظبط شاشة البداية (Splash Screen) عشان التطبيق يبقى جاهز للنشر. اشتركوا عشان ما تفوتوش مسك الختام!

---

## **نص الحلقة 5: الأنيميشن، النتايج، واللمسات الأخيرة**

**فكرة العنوان:** اللحظة الحاسمة: إظهار النتايج، الأنيميشن، وفنش التطبيق (حلقة 5)
**الوقت المقدر:** 10 دقايق

### **[0:00 - 3:30] لوحة النتايج: عرض البيانات بـ "قوة"**

أهلاً بيكم في الحلقة الأخيرة والختامية! النهاردة هنقفل اللوحة الفنية بتاعتنا. أول حاجة هنتكلم عنها هي الـ Results Dashboard اللي في نص الشاشة.

إحنا مش بس بنعرض رقم الـ BMI. إحنا مقسمين الشاشة لـ 3 أجزاء باستخدام `IntrinsicHeight` و `Expanded`. جزء للوزن المثالي، جزء كبير للـ BMI بلونه المميز، وجزء لنسبة الدهون. التصميم ده بيخلي المستخدم يشوف أهم معلومة في النص بوضوح، والمعلومات التانية حواليها.

لاحظوا كمان إننا بنستخدم `_loc.translate(classificationKey)` عشان الوصف يطلع باللغة اللي المستخدم اختارها (مثلاً: 'Normal' أو 'وزن طبيعي').

### **[3:30 - 6:30] الجدول المرجعي وشاشة البداية**

(مرئي: النزول لآخر الشاشة لاستعراض جدول التصنيفات، ثم الانتقال لملف `splash_screen.dart` إن وجد أو وصفه.)

عشان نكون أمناء مع المستخدم، ضفنا في آخر الشاشة جدول مرجعي. الجدول ده بيوري المستخدم كل تصنيفات الـ BMI والألوان بتاعتها. وده جزء مهم في أي تطبيق صحي عشان المستخدم يفهم هو فين بالظبط من المعدلات العالمية.

وطبعاً ميفوتناش الـ `SplashScreen`. عملنا شاشة بسيطة فيها اللوجو بتاعنا وبيتحرك (Animation) بشكل ناعم قبل ما يدخلك على الحاسبة. دي بتدي انطباع إن التطبيق 'مصروف عليه' ومتعوب فيه.

### **[6:30 - 9:00] مراجعة سريعة ودروس مستفادة**

تعالوا نراجع عملنا إيه في السلسلة دي.. اتعلمنا إزاي نصمم بره الصندوق بستايل الـ Brutalist. اتعلمنا إزاي نرتب كود فلاتر ونفصل المنطق عن الواجهة. عرفنا إزاي نهندل لغات مختلفة (Localization) ونحول بين وحدات القياس.

الأهم من الكود نفسه هو إنك تتعلم إزاي تدي للتطبيق بتاعك 'روح' و 'شخصية' تخليه يفرق عن آلاف التطبيقات التانية الموجودة على الستور.

### **[9:00 - 10:00] الخاتمة وشكر المتابعين**

وبكده نكون وصلنا لنهاية سلسلة الـ Brutalist BMI Calculator. أتمنى تكونوا استفدتوا فعلاً وطلعتوا بمعلومات جديدة تطبقوها في مشاريعكم الجاية.

لو السلسلة دي عجبتكم، يا ريت تدعموني بلايك وكومنت، وقولولي إيه نوع التطبيقات اللي تحبوا نعملها المرة الجاية. كل الأكواد هتلاقوها موجودة في اللينك اللي في الوصف. شكراً جداً لمتابعتكم، وأشوفكم في فيديوهات جاية كتير.. سلام!

---

## 🧠 `bmi_logic.dart` Explained for Flutter Beginners

Hello everyone 👋  
In this part, we will understand in a simple way how `bmi_logic.dart` works as the calculation brain of the app, and how `CalculatorScreen` uses it to show live results.

> ✅ Core idea:  
> The UI collects user input, `BMICalculator` performs the math, then the result is rendered on screen.

---

### 🎯 What `bmi_logic.dart` is responsible for

In your app, `CalculatorScreen` calls methods like:

- `calculateBMI(height, weight)`
- `getClassification(bmi)`
- `getIdealWeightRange(height)`
- `estimateFatPercentage(bmi, age, isMale)`

That means:
- `CalculatorScreen` handles interaction and visuals 🎨
- `BMICalculator` handles all health and math logic 🧮

This separation is clean and beginner-friendly.

---

### 🧮 1) `calculateBMI(height, weight)`

This is the main formula.

#### Formula:
\[
BMI = \frac{weight\ (kg)}{(height\ in\ meters)^2}
\]

Your app stores:
- height in **cm**
- weight in **kg**

So height must be converted first:

```dart
double heightMeters = heightCm / 100;
double bmi = weightKg / (heightMeters * heightMeters);
```

#### Example:
- Height = 170 cm -> 1.70 m
- Weight = 70 kg
- BMI = 70 / (1.7 x 1.7) = 24.2 (approx)

---

### 🏷️ 2) `getClassification(bmi)`

After BMI is calculated, it must be mapped to a human-readable health category.

This method usually returns:
- a translation key (like `cat_n`)
- a color for the category badge

Used in `CalculatorScreen` like this:

```dart
final result = BMICalculator.getClassification(bmi);
classificationKey = result.key;
classificationColor = result.color;
```

Then label text is localized with:

```dart
_loc.translate(classificationKey)
```

#### Typical category ranges:
- 🔻 `< 16`
- 🔸 `16 - 17`
- 🟠 `17 - 18.5`
- ✅ `18.5 - 25` (normal)
- ⚠️ `25 - 30`
- 🚨 `30 - 35`
- 🚨 `35 - 40`
- ⛔ `> 40`

---

### ⚖️ 3) `getIdealWeightRange(height)`

This estimates an ideal weight range from height using normal BMI boundaries.

Rearranged BMI formula:

\[
weight = BMI \times (height\ in\ meters)^2
\]

So:
- minimum ideal weight = `18.5 x h²`
- maximum ideal weight = `24.9 x h²` (or 25 by table style)

#### Example for 170 cm:
- h² = 2.89
- Min ~= 53.5 kg
- Max ~= 72.0 kg

---

### 📉 4) `estimateFatPercentage(bmi, age, isMale)`

This gives an estimated body fat percentage based on:
- BMI
- age
- gender

A common estimate formula is:

- 👨 Male: `1.20 * BMI + 0.23 * age - 16.2`
- 👩 Female: `1.20 * BMI + 0.23 * age - 5.4`

> ℹ️ Note: This is an estimate, not a medical-grade measurement.

---

### 🔄 How `CalculatorScreen` uses these calculations

Whenever the user changes:
- age
- weight
- height
- gender
- units

`_calculate()` runs and updates:
1. BMI value
2. Classification key + color
3. UI labels and numbers

That is why the app feels real-time and responsive.

---

### 🌍 Important: Unit handling strategy

Even if the user views values in LB or FT+IN, calculations are kept internally in **kg + cm**.

✅ Benefits:
- fewer calculation errors
- consistent logic
- easier maintenance and testing

---

### 🧱 Beginner best practice

Keep this architecture:

- **UI layer:** `CalculatorScreen` (widgets + interaction)
- **Logic layer:** `bmi_logic.dart` (pure functions)

This is one of the best habits for scalable Flutter apps.

---

### 🚫 Common beginner mistakes to avoid

- Forgetting cm -> meter conversion before BMI
- Mixing display units with internal math units
- Rounding too early
- Ignoring invalid edge values (like height = 0)
- Putting all math directly inside widget build code

---

## ✅ Final takeaway

`BMICalculator` in `bmi_logic.dart` is the engine of your app:  
it computes BMI, picks the category, estimates body fat, and calculates ideal weight range while `CalculatorScreen` turns that into a clean, interactive experience.

✨ If you fully understand this part, you have made excellent progress in understanding real Flutter app architecture.

---

## 🎨 `brutalist_widgets.dart` Explained for Flutter Beginners

Hello everyone 👋  
In this part, we will walk through `brutalist_widgets.dart` — the file that gives the app its bold, unique visual personality. Every card, button, and container you see in the UI comes from here.

> ✅ Core idea:  
> Instead of repeating the same styling everywhere, we build **reusable widgets** once and use them throughout the entire app. That's the power of a custom design system in Flutter.

---

### 🧱 The Big Picture: What This File Contains

`brutalist_widgets.dart` has two main building blocks:

| Widget | Role |
|---|---|
| `BrutalistContainer` 📦 | The foundation — a styled box with a hard shadow |
| `BrutalistButton` 🔘 | A tappable button built on top of `BrutalistContainer` |

Think of `BrutalistContainer` as a **LEGO brick** — everything in the app is assembled from it.

---

### 📦 1) `BrutalistContainer` — The Foundation Widget

This is the most important widget in the whole app. Let's break it down piece by piece.

#### 🔧 Its properties (the knobs you can turn):

```dart
final Widget child;           // 👶 What goes inside the box
final Color backgroundColor;  // 🎨 The fill color (default = white)
final double borderRadius;    // 🔲 How rounded the corners are (default = 12)
final double borderWidth;     // 📏 How thick the border is (default = 3)
final Offset shadowOffset;    // 🌑 How far the shadow is shifted (default = 4,4)
final EdgeInsets padding;     // 📐 Space between border and content (default = 16)
final VoidCallback? onTap;    // 👆 Optional: makes it tappable like a button
```

> ℹ️ Notice that `onTap` is **nullable** (`?`). That means it is optional — if you don't pass it, the container is just a display box. If you do pass it, it becomes interactive.

---

#### 🪄 The Magic Trick: Two Containers in a Stack

The Neo-Brutalist "hard shadow" effect is NOT done with Flutter's built-in `BoxShadow`. Instead, it uses a clever trick:

```dart
Stack(
  children: [
    // 🌑 BOTTOM layer: a black box shifted down-right
    Container(
      margin: EdgeInsets.only(left: shadowOffset.dx, top: shadowOffset.dy),
      decoration: BoxDecoration(color: Colors.black, ...),
      child: Opacity(opacity: 0, child: ...), // invisible copy to match size
    ),

    // 🎨 TOP layer: the real content with color and border
    Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: child,
    ),
  ],
)
```

**Why this works:**

```
┌─────────────┐
│  TOP layer  │  ← you see this (white box with border)
└─────────────┘
    ┌─────────────┐
    │ BOTTOM layer│  ← shifted right+down (solid black box = fake shadow)
    └─────────────┘
```

This creates the illusion of a **3D hard offset shadow** — the signature look of Neo-Brutalism.

> 💡 Beginner tip: `Stack` in Flutter places children on top of each other. The last child in the list appears on top.

---

#### 👻 Why is the bottom layer invisible?

```dart
child: Opacity(opacity: 0, child: Padding(padding: padding, child: child)),
```

The shadow box needs to be **exactly the same size** as the top content box. The easiest way to do that is to put the same `child` inside it, but make it invisible with `Opacity(opacity: 0)`. It takes up space (for sizing) but shows nothing.

---

### 🔘 2) `BrutalistButton` — The Interactive Button

`BrutalistButton` is simply `BrutalistContainer` with a tap handler and a centered text label.

```dart
BrutalistContainer(
  onTap: onTap,           // 👆 Makes the whole box tappable
  backgroundColor: color, // 🎨 Uses the chosen color
  child: Center(
    child: Text(
      label,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: color == Colors.black ? Colors.white : Colors.black,
                                       // ☝️ Smart color flip!
      ),
    ),
  ),
)
```

#### 🧠 The smart color flip explained:

```dart
color: color == Colors.black ? Colors.white : Colors.black
```

| Button background | Text color |
|---|---|
| Black 🖤 | White 🤍 (so you can read it) |
| Any other color | Black 🖤 (default) |

This is called **automatic contrast** — the text always stays readable no matter what color the button is.

---

### 🔄 How These Widgets Are Used in the App

In `CalculatorScreen`, you will see patterns like:

```dart
// A display box (not tappable)
BrutalistContainer(
  backgroundColor: Colors.white,
  child: Column(...),
)

// A tappable card (e.g. gender selection)
BrutalistContainer(
  onTap: () => setState(() => isMale = true),
  backgroundColor: isMale ? Color(0xFFFFDE59) : Colors.white,
  child: Column(...),
)

// A button (e.g. close dialog)
BrutalistButton(
  label: 'Close',
  color: Color(0xFFD32F2F), // red
  onTap: () => Navigator.pop(context),
)
```

---

### 🌈 Why Reusable Widgets Matter (Beginner Insight)

Without `BrutalistContainer`, you would need to copy-paste the same `Stack + Container + Border` code **every single time** you want a styled box. That leads to:

- ❌ Repeated code everywhere
- ❌ Hard to update styles later (change in one place = change nowhere else)
- ❌ Easy to make mistakes

With reusable widgets:
- ✅ Write once, use everywhere
- ✅ Change the style in one place, the whole app updates
- ✅ Clean, readable code

---

### 🚫 Common beginner mistakes to avoid

- Forgetting that `Stack` children overlap — order matters (last child = on top)
- Using `BoxShadow` when you want a hard shadow — it will always be blurry
- Making `onTap` required when it should be optional — use `?` for optional callbacks
- Not using `const` constructors when values don't change — it improves performance
- Putting all styling inline in every screen instead of extracting it into a widget

---

## ✅ Final takeaway

`BrutalistContainer` and `BrutalistButton` are the **visual DNA** of this app.  
The `Stack` trick gives the hard 3D shadow. The smart color flip keeps text readable. And because everything is in one reusable widget, the whole app stays consistent and easy to maintain.

✨ Once you understand how to build your own reusable widgets like this, you have levelled up from a Flutter beginner to a Flutter developer.

---

## 🖥️ `calculator_screen.dart` Explained for Flutter Beginners

Hello everyone 👋  
This is the **heart of the entire app** — the screen where the user interacts, inputs data, and sees live results. Let's break it down step by step so it's crystal clear.

> ✅ Core idea:  
> `CalculatorScreen` is a `StatefulWidget` that listens to user input, triggers calculations via `BMICalculator`, and rebuilds the UI instantly to reflect the new results.

---

### 🗂️ The Big Picture: What This Screen Does

```
User Input (sliders, buttons, taps)
        ↓
   setState() called
        ↓
  _calculate() runs
        ↓
BMICalculator computes results
        ↓
  UI rebuilds with fresh data
```

All of this happens in **milliseconds** on every single interaction — that's what makes the app feel real-time.

---

### ⚡ 1) `StatefulWidget` vs `StatelessWidget` — Why We Need State Here

A `StatelessWidget` can't change after it's built. Since the user will constantly change:
- age 🎂
- weight ⚖️
- height 📏
- gender 🚻
- units (KG/LB, CM/FT)

…we **must** use a `StatefulWidget` so the screen can update dynamically.

```dart
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
```

> 💡 Beginner tip: The `StatefulWidget` itself is just a wrapper. All the actual data and logic lives in `_CalculatorScreenState`.

---

### 🗃️ 2) State Variables — The Memory of the Screen

These are all the values the screen "remembers":

```dart
int age = 25;           // 🎂 User's age in years
double height = 170.0;  // 📏 Always stored in CM internally
double weight = 70.0;   // ⚖️ Always stored in KG internally
bool isMale = true;     // 🚻 Gender: true = Male, false = Female

bool isCm = true;       // 📐 Display unit for height
bool isKg = true;       // ⚖️ Display unit for weight

double bmi = 0;                         // 🔢 Calculated BMI result
String classificationKey = "cat_n";     // 🏷️ Key for localized label
Color classificationColor = Colors.black; // 🎨 Badge color

late String _currentLang;  // 🌍 Active language code
late AppLocalization _loc;  // 🔤 Translation helper
```

> 💡 Notice: height and weight are always stored in metric internally (cm/kg), even when the user picks lb or ft+in. This is intentional — it keeps all formulas consistent.

---

### 🔢 3) Conversion Constants — The Math Helpers

```dart
static const double cmPerInch = 2.54;       // 1 inch = 2.54 cm
static const double kgPerLb = 0.45359237;   // 1 pound = 0.453 kg
```

These are `static const` because:
- `static` — they belong to the class, not any specific instance
- `const` — they never change, so Flutter can optimize them at compile time

---

### 🚀 4) `initState()` — What Happens Before the Screen Appears

```dart
@override
void initState() {
  super.initState();

  // 🌍 Detect the device's system language
  String systemLang = PlatformDispatcher.instance.locale.languageCode;

  // ✅ Use it if supported, otherwise fall back to English
  _currentLang = AppLocalization.languages.containsKey(systemLang) ? systemLang : 'en';
  _loc = AppLocalization(_currentLang);

  // 🔢 Run the first calculation so BMI shows a value on launch
  _calculate();
}
```

`initState()` runs **once**, right before the widget appears. Think of it as the screen's "setup routine".

> 💡 Always call `super.initState()` first — it's required by Flutter.

---

### 🧠 5) `_calculate()` — The Reactive Engine

This is the most important method in the screen:

```dart
void _calculate() {
  setState(() {
    bmi = BMICalculator.calculateBMI(height, weight);

    final result = BMICalculator.getClassification(bmi);
    classificationKey = result.key;
    classificationColor = result.color;
  });
}
```

**Two things happen here:**

1. **`BMICalculator` does the math** → returns BMI, classification key, and color
2. **`setState()`** tells Flutter: *"something changed, please redraw the screen"*

Every time the user touches any input, `_calculate()` is called immediately.

> 💡 Without `setState()`, the screen would NOT update — even if the variable changed. Always wrap data changes in `setState()`.

---

### 🏗️ 6) The `build()` Method — Structure Overview

The entire UI is built inside `build()`. Here's the layout at a glance:

```
Directionality (RTL/LTR based on language)
  └── Scaffold
        ├── AppBar (title + language button)
        └── SingleChildScrollView
              └── Column
                    ├── 🚻 Gender cards (Male / Female)
                    ├── 🎂⚖️ Age + Weight counter cards
                    ├── 📏 Height slider
                    ├── 📊 Results dashboard (Ideal / BMI / Fat %)
                    └── 📋 Classification reference table
```

Everything is wrapped in a `SingleChildScrollView` so the page scrolls on small screens.

---

### 🌍 7) `Directionality` — Built-in RTL Support

```dart
Directionality(
  textDirection: _loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
  child: Scaffold(...),
)
```

This is how the app supports **Arabic** (right-to-left) automatically.  
When the user picks Arabic, `_loc.isRtl` becomes `true`, and the **entire UI flips direction** without any extra work.

> 💡 This is a professional pattern — no need to build separate versions for RTL languages.

---

### 🚻 8) Gender Cards — Interactive Selection

```dart
BrutalistContainer(
  onTap: () => setState(() {
    isMale = true;
    _calculate();
  }),
  backgroundColor: isMale ? const Color(0xFFFFDE59) : Colors.white,
  child: Column(
    children: [
      Icon(Icons.man, size: 40),
      Text(_loc.translate('male')),
    ],
  ),
)
```

**How it works:**
- Tapping a card calls `setState()` which flips the `isMale` flag
- The `backgroundColor` expression changes the color instantly:
  - Selected = 🟡 Yellow (`0xFFFFDE59`)
  - Not selected = ⬜ White

---

### 🎂⚖️ 9) Counter Cards — Age & Weight with +/– Buttons

```dart
_buildCounterCard(
  _loc.translate('weight'),
  isKg ? weight.toInt() : (weight / kgPerLb).round(), // 🔄 Display in chosen unit
  (val) => setState(() {
    weight = isKg ? val.toDouble() : val * kgPerLb;    // 💾 Store in KG always
    _calculate();
  }),
  unit: isKg ? 'KG' : 'LB',
  onUnitTap: () => _showUnitDialog(...), // 🗂️ Open unit picker
)
```

Notice the **unit conversion pattern**:  
- **Display**: shows the value in the user's chosen unit (KG or LB)
- **Storage**: always saves back to KG internally

This is a key professional technique for handling multi-unit apps.

---

### 📏 10) Height Slider — Real-Time Updates

```dart
Slider(
  value: height,
  min: 100,
  max: 220,
  activeColor: Colors.black,
  onChanged: (val) {
    setState(() {
      height = val;
      _calculate(); // ⚡ Recalculate on every single slider move
    });
  },
)
```

`onChanged` fires **continuously** as the user drags — so BMI updates live as they move the slider.

---

### 📊 11) Results Dashboard — `IntrinsicHeight` Trick

```dart
BrutalistContainer(
  child: IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 1, child: /* Ideal Weight */),
        Container(width: 2, color: Colors.black), // divider
        Expanded(flex: 2, child: /* BMI (bigger) */),
        Container(width: 2, color: Colors.black), // divider
        Expanded(flex: 1, child: /* Body Fat % */),
      ],
    ),
  ),
)
```

**`IntrinsicHeight`** makes all columns the same height, even if they have different content sizes.  
**`flex`** controls how much space each column gets:
- Ideal weight → `flex: 1` (small)
- BMI → `flex: 2` (double width — most important!)
- Fat % → `flex: 1` (small)

---

### 📋 12) Classification Table — The Reference Guide

At the bottom of the screen is a BMI reference table for the user:

```dart
_buildClassificationRow(_loc.translate('cat_n'), '18.5 - 25', Color(0xFF4CAF50))
```

Each row shows:
- A color-coded label (based on health risk)
- The BMI range number

The `isLast` parameter removes the bottom border on the final row to avoid a double border:

```dart
Widget _buildClassificationRow(String label, String range, Color color, {bool isLast = false}) {
  return Container(
    decoration: BoxDecoration(
      border: isLast ? null : Border(bottom: BorderSide(color: Colors.black)),
    ),
    ...
  );
}
```

---

### 🗂️ 13) Unit & Language Dialogs

Both dialogs use the same pattern:

```dart
showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent, // 🪟 lets our custom widget show through
    child: BrutalistContainer(
      child: Column(
        children: [
          // title
          // list of options (each is a tappable BrutalistContainer)
          // Close button
        ],
      ),
    ),
  ),
);
```

> 💡 `backgroundColor: Colors.transparent` on `Dialog` is intentional — it removes the default white dialog background so our custom `BrutalistContainer` style is fully visible.

---

### 📐 14) `_formatHeightInFeet()` — Unit Conversion Helper

```dart
String _formatHeightInFeet(double cm) {
  double totalInches = cm / 2.54;          // cm → inches
  int feet = (totalInches / 12).floor();   // full feet
  int inches = (totalInches % 12).round(); // remaining inches
  return "$feet' $inches\"";               // e.g. "5' 7\""
}
```

Simple math:
- divide by `2.54` to get total inches
- divide by `12` for feet
- remainder is the leftover inches

---

### 🔄 15) How Everything Connects — Full Flow

```
User taps "+" on weight card
        ↓
onChanged(value + 1) triggers
        ↓
setState() called → weight updated
        ↓
_calculate() → BMICalculator.calculateBMI()
        ↓
bmi, classificationKey, classificationColor updated
        ↓
build() runs again → new values shown instantly
```

---

### 🚫 Common beginner mistakes to avoid

- Forgetting `setState()` → data changes but UI doesn't update
- Calling `_calculate()` outside `setState()` → partial updates, unexpected behavior
- Storing display values (LB/FT) instead of metric internally → formula bugs
- Not calling `super.initState()` inside `initState()`
- Putting `showDialog` inside `build()` instead of in a method → dialog opens on every frame
- Forgetting `mounted` check before using `context` after async operations

---

## ✅ Final takeaway

`CalculatorScreen` is where everything comes together:
- 🎨 Reusable `BrutalistContainer` widgets build the UI
- 🧮 `BMICalculator` handles all the math
- 🌍 `AppLocalization` + `Directionality` handle multilingual support
- ⚡ `setState()` + `_calculate()` keep everything reactive and live

✨ Understanding this screen means you understand the **full Flutter data flow**: input → state → calculation → UI rebuild. That's the foundation of every real-world Flutter app.

