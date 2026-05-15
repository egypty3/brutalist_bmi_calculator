<div dir="rtl" style="line-height:1.85;max-width:1100px;margin:0 auto;padding:0 10px;">

<style>
pre,
pre code,
code.language-dart {
  direction: ltr;
  text-align: left;
  unicode-bidi: plaintext;
}
</style>

<h1 style="background:linear-gradient(90deg,#0f172a,#1e293b);color:#f8fafc;padding:16px 18px;border-radius:14px;border:2px solid #0ea5e9;">
🧠📊 شرح مفصل جدا للمبتدئين: <span style="color:#67e8f9;">calculator_screen.dart</span>
</h1>

<div style="background:#f0f9ff;border:2px solid #38bdf8;border-radius:12px;padding:14px 16px;margin:14px 0;color:#0f172a;">
<b>✨ هذا الملف هو قلب واجهة التطبيق</b><br>
وهو المسؤول عن:
<ul>
  <li>👤 استقبال مدخلات المستخدم: العمر، الوزن، الطول، الجنس.</li>
  <li>⚡ حساب النتائج مباشرة عند أي تغيير.</li>
  <li>📱🖥️ عرض مختلف للهاتف والتابلت.</li>
  <li>🌍 دعم تغيير اللغة (عربي/إنجليزي) داخل نفس الشاشة.</li>
  <li>⚖️📏 دعم وحدات قياس مختلفة (kg/lb و cm/ft+in).</li>
  <li>📚 عرض نموذج تعليمي عند أول تشغيل للتطبيق.</li>
  <li>📺 عرض إعلانات Banner من Google AdMob.</li>
  <li>🏥 صفوف التصنيفات قابلة للتفاعل (Tappable) - تفتح شاشة الأمراض المرتبطة بكل فئة.</li>
</ul>
</div>

<div style="background:#fff7ed;border-inline-start:8px solid #f97316;border-radius:10px;padding:12px 14px;margin:12px 0;color:#0f172a;">
🎯 <b>الهدف:</b> هذا المستند مكتوب للمبتدئ تماما، لذلك الشرح خطوة بخطوة وبأسلوب بسيط.
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🧭 1) الصورة العامة للملف

<div style="background:#f8fafc;border:1px solid #cbd5e1;border-radius:12px;padding:12px 14px;color:#0f172a;">
الشاشة مبنية كـ <b>StatefulWidget</b>، وهذا يعني:
<ul>
  <li>🔄 يوجد بيانات تتغير أثناء تشغيل التطبيق.</li>
  <li>🛠️ عندما تتغير البيانات، نستخدم <b>setState</b> ليعاد بناء الواجهة.</li>
</ul>

<b>التسلسل العام للعمل:</b>

<ol>
  <li>initState يشتغل مرة واحدة عند فتح الشاشة.</li>
  <li>يتم تحديد اللغة الافتراضية من لغة النظام.</li>
  <li>يتم أول حساب BMI.</li>
  <li>build يرسم الشاشة.</li>
  <li>أي تفاعل من المستخدم يعيد setState ثم _calculate ثم إعادة الرسم.</li>
</ol>
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🧾 2) المتغيرات المهمة ولماذا موجودة

### 👤 مدخلات المستخدم

- age: العمر.
- height: الطول (يخزن داخليا بالسنتيمتر).
- weight: الوزن (يخزن داخليا بالكيلوغرام).
- isMale: لتحديد الجنس (يؤثر على تقدير نسبة الدهون).
- isCm: وحدة عرض الطول (cm أو ft+in).
- isKg: وحدة عرض الوزن (kg أو lb).

### 🌐 اللغة

- \_currentLang: كود اللغة الحالي.
- \_loc: كائن الترجمة الذي يعيد النصوص حسب اللغة.

### 📊 نتائج مشتقة

- bmi: رقم BMI الحالي.
- classificationKey: مفتاح التصنيف (مثل cat_n).
- classificationColor: لون التصنيف.

### 🔢 ثوابت التحويل

- cmPerInch = 2.54
- kgPerLb = 0.45359237

<div style="background:#ecfeff;border:1px solid #67e8f9;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
💡 هذه الثوابت تجعل التحويل <b>دقيقا وثابتا</b> في كل مكان داخل الشاشة.
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🚀 3) دورة الحياة: initState

initState يقوم بعدة خطوات أساسية:

1. يقرأ لغة النظام من PlatformDispatcher.
2. إذا اللغة مدعومة في AppLocalization يستخدمها، وإلا يعود للإنجليزية.
3. استرجاع اللغة المحفوظة (إذا كان المستخدم غيّرها سابقاً).
4. يستدعي \_calculate حتى تظهر الشاشة بنتيجة صحيحة من أول لحظة.
5. بعد ظهور الشاشة يستدعي post-frame callbacks:
   - \_loadBannerAd() لتحميل إعلان Banner.
   - \_checkAndShowTutorial() لعرض النموذج التعليمي عند أول تشغيل.

<div style="background:#fef3c7;border:1px solid #f59e0b;border-radius:10px;padding:10px 12px;color:#0f172a;">
⚠️ <b>لماذا post-frame callbacks مهمة؟</b><br>
لأن بعض العمليات (مثل تحميل الإعلانات والتنقل إلى شاشات جديدة) تحتاج أن تكون الواجهة مرئية بالفعل أولاً. بدونها قد تحدث أخطاء أو تحطيمات في Flutter.
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🎬 3.5) الأنظمة الجديدة في هذا الإصدار

### 🎓 نظام النموذج التعليمي (Tutorial System)

<div style="background:#faf5ff;border:1px solid #c084fc;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هو التطبيق التعليمي؟</b><br>
عند فتح التطبيق <b>لأول مرة</b>، يعرض التطبيق شاشة تعليمية (TutorialScreen) توضح الميزات والتعليمات. يتم تذكر هذا في SharedPreferences حتى لا يظهر مجدداً.

<br><br><b>📌 الدوال المسؤولة:</b>
<ul>
  <li><b>_checkAndShowTutorial()</b> - تقرأ SharedPreferences وتعرض الشاشة عند أول فتح.</li>
  <li><b>_navigateToTutorial()</b> - تفتح النموذج يدويًا من قائمة ⋮.</li>
</ul>
</div>

### 📺 نظام الإعلانات (AdMob Banner Ads)

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي الإعلانات؟</b><br>
التطبيق يعرض إعلانات Banner من Google AdMob في أسفل الشاشة. الإعلانات تتكيف مع عرض الجهاز وتحتاج إلى معرّف وحدة إعلانية (Ad Unit ID) مختلف حسب النظام.

<br><br><b>📌 الدوال المسؤولة:</b>
<ul>
  <li><b>_bannerAdUnitId</b> - خاصية تعيد معرّف الإعلان المناسب للنظام الحالي (Android/iOS).</li>
  <li><b>_loadBannerAd()</b> - تحمّل الإعلان وتتعامل مع الأخطاء.</li>
  <li><b>_buildBannerArea()</b> - تعرض الإعلان في الواجهة.</li>
</ul>
</div>

### 🏥 صفوف التصنيفات القابلة للتفاعل (Tappable Classification Rows)

<div style="background:#fff7ed;border:1px solid #fb923c;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هو الجديد؟</b><br>
كل صف في جدول التصنيفات الآن <b>قابل للضغط</b>. عند الضغط على أي صف، يتم الانتقال إلى شاشة جديدة (DiseasesScreen) تعرض:
<ul>
  <li>الأمراض والحالات الصحية المرتبطة بهذه الفئة.</li>
  <li>معلومات مفصلة عن المخاطر الصحية.</li>
  <li>نصائح وإرشادات.</li>
</ul>

<br><br><b>📌 التغييرات في الكود:</b>
<ul>
  <li>دالة <b>_buildClassificationRow()</b> الآن تستقبل <b>categoryKey</b> و<b>GestureDetector</b> جديد.</li>
  <li>توجد أيقونة <b>chevron_right</b> (➜) تشير إلى أن الصف قابل للضغط.</li>
  <li>في <b>_classificationSection()</b> يوجد نص hint يقول للمستخدم "اضغط لمزيد من المعلومات".</li>
</ul>
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

<div style="background:#f8fafc;border:1px solid #cbd5e1;border-radius:12px;padding:12px 14px;color:#0f172a;margin-bottom:14px;">
📘 <b>فكرة هذا القسم:</b> في كل دالة سنشرح <b>دورها</b> داخل الشاشة، ثم <b>تسلسل عملها</b>، ثم <b>أهم نقطة يجب أن ينتبه لها المبتدئ</b>، وبعد ذلك سترى <b>الكود الفعلي للدالة</b> مباشرة أسفل الشرح.
</div>

## 4.1 🧮 \_calculate() - حساب BMI + التصنيف + اللون

<div style="background:#f0fdf4;border:1px solid #4ade80;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه هي الدالة المركزية التي تحدّث نتيجة BMI المعروضة على الشاشة. كلما تغيّر أي إدخال مهم، تكون هذه الدالة هي المسؤولة عن إعادة حساب النتيجة وإعادة تصنيفها.

<br><br><b>⚙️ كيف تعمل خطوة بخطوة؟</b>

<ol>
  <li>تدخل إلى <b>setState</b> حتى يعرف Flutter أن هناك بيانات ستتغير ويجب إعادة رسم الواجهة.</li>
  <li>تستدعي <b>BMICalculator.calculateBMI(height, weight)</b> لحساب قيمة BMI الرقمية.</li>
  <li>تستدعي <b>BMICalculator.getClassification(bmi)</b> للحصول على الفئة المناسبة مثل طبيعي أو زيادة وزن، مع اللون المناسب لها.</li>
  <li>تخزن النتيجة داخل متغيرات الحالة:
    <ul>
      <li><b>classificationKey</b> لاستخدام اسم التصنيف داخل الترجمة.</li>
      <li><b>classificationColor</b> لاستخدام اللون نفسه في بطاقة النتيجة.</li>
    </ul>
  </li>
</ol>

<b>🧠 لماذا هذا الأسلوب ممتاز؟</b>

<ul>
  <li>يفصل بين <b>منطق الحساب</b> و<b>واجهة العرض</b>.</li>
  <li>يجعل أي تحديث في المدخلات ينعكس مباشرة على الشاشة.</li>
  <li>يسهل لاحقا تعديل طريقة الحساب بدون تخريب UI.</li>
</ul>

<b>📌 متى يتم استدعاؤها؟</b>

<ul>
  <li>عند تغيير الجنس.</li>
  <li>عند تغيير العمر.</li>
  <li>عند تغيير الوزن.</li>
  <li>عند تحريك Slider الطول.</li>
  <li>عند تغيير وحدة القياس إذا كان العرض يحتاج تحديثا فوريا.</li>
</ul>
</div>

### 💻 الكود الفعلي للدالة: `_calculate()`

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

## 4.2 📱 \_buildPhoneLayout() - تخطيط الهاتف (عمود قابل للتمرير)

<div style="background:#eff6ff;border:1px solid #60a5fa;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تبني نسخة الشاشة الخاصة بالهاتف. بما أن عرض الهاتف ضيق وارتفاعه محدود، فالمحتوى يترتب رأسيًا من الأعلى إلى الأسفل.

<br><br><b>⚙️ كيف يرتب الواجهة؟</b>

<ol>
  <li>يضع كل شيء داخل <b>SingleChildScrollView</b>.</li>
  <li>داخل الـ scroll يستخدم <b>Column</b> رئيسية.</li>
  <li>يضيف أقسام الشاشة بهذا الترتيب:
    <ul>
      <li>اختيار الجنس.</li>
      <li>العمر والوزن.</li>
      <li>بطاقة الطول.</li>
      <li>بطاقة النتائج.</li>
      <li>جدول التصنيفات.</li>
    </ul>
  </li>
</ol>

<b>🧠 لماذا هذا مناسب للهاتف؟</b>

<ul>
  <li>لأن المساحة الأفقية صغيرة.</li>
  <li>ولأن بعض الأقسام قد لا تتسع كلها في نفس الارتفاع.</li>
  <li>لذلك يكون التمرير الرأسي هو السلوك الطبيعي والأبسط للمستخدم.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
SingleChildScrollView
  └─ Column (crossAxisAlignment: stretch)
      ├─ _genderRow()
      │   └─ Row
      │       ├─ _buildGenderCard(Male)
      │       └─ _buildGenderCard(Female)
      │
      ├─ SizedBox (height: 24)
      ├─ _ageWeightRow()
      │   └─ Row
      │       ├─ _buildCounterCard(Age)
      │       └─ _buildCounterCard(Weight)
      │
      ├─ SizedBox (height: 24)
      ├─ _heightCard()
      │   └─ BrutalistContainer
      │       └─ Column
      │           ├─ Text (HEIGHT)
      │           ├─ Row (+/- buttons + display)
      │           └─ Slider
      │
      ├─ SizedBox (height: 32)
      ├─ _resultsCard()
      │   └─ BrutalistContainer
      │       └─ IntrinsicHeight
      │           └─ Row (3 columns)
      │
      ├─ SizedBox (height: 32)
      ├─ _classificationSection()
      │   └─ Column
      │       ├─ Text (REFERENCE)
      │       └─ BrutalistContainer
      │           └─ Column (8 rows)
      │
      └─ SizedBox (height: 40)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمزيد من المخططات التفصيلية</b> لكل دالة، راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_buildPhoneLayout()`

```dart
Widget _buildPhoneLayout() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _genderRow(),
        const SizedBox(height: 24),
        _ageWeightRow(),
        const SizedBox(height: 24),
        _heightCard(),
        const SizedBox(height: 32),
        _resultsCard(),
        const SizedBox(height: 32),
        _classificationSection(),
        const SizedBox(height: 40),
      ],
    ),
  );
}
```

## 4.3 🖥️ \_buildTabletLayout() - تخطيط التابلت (عمودان بلا تمرير عام)

<div style="background:#faf5ff;border:1px solid #c084fc;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تبني نسخة الشاشة الخاصة بالتابلت. الهدف هنا ليس مجرد تكبير عناصر الهاتف، بل إعادة توزيع المحتوى ليستفيد من المساحة الواسعة.

<br><br><b>⚙️ كيف يقسم الشاشة؟</b>

<ul>
  <li>⬅️ <b>العمود الأيسر</b>: مدخلات المستخدم.</li>
  <li>➡️ <b>العمود الأيمن</b>: النتائج + جدول التصنيفات.</li>
</ul>

<b>📚 تفاصيل العمود الأيسر</b>

<ol>
  <li>صف الجنس.</li>
  <li>صف العمر والوزن.</li>
  <li>بطاقة الطول داخل <b>Expanded</b> حتى تملأ المساحة المتبقية.</li>
</ol>

<b>📊 تفاصيل العمود الأيمن</b>

<ol>
  <li>بطاقة النتائج في الأعلى.</li>
  <li>جدول التصنيفات في الأسفل داخل <b>Expanded</b>.</li>
</ol>

<b>🧠 لماذا هذا التصميم أفضل للتابلت؟</b>

<ul>
  <li>يعرض عناصر أكثر في نفس اللحظة.</li>
  <li>يقلل الحاجة إلى التمرير العام.</li>
  <li>يعطي الشاشة شكل dashboard أوضح وأكثر احترافية.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
Padding
  └─ Row (crossAxisAlignment: stretch)
      │
      ├─ Expanded (flex: 5) ← العمود الأيسر (Inputs)
      │   └─ Column
      │       ├─ _genderRow(iconSize: 52)
      │       ├─ SizedBox (height: 16)
      │       ├─ _ageWeightRow()
      │       ├─ SizedBox (height: 16)
      │       └─ Expanded
      │           └─ _heightCard(expandSlider: true)
      │
      ├─ SizedBox (width: 20)
      │
      └─ Expanded (flex: 5) ← العمود الأيمن (Results & Reference)
          └─ Column
              ├─ _resultsCard(tabletMode: true)
              ├─ SizedBox (height: 16)
              └─ Expanded
                  └─ _classificationSection(scrollable: false)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_buildTabletLayout()`

```dart
Widget _buildTabletLayout() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _genderRow(iconSize: 52, fontSize: 16),
              const SizedBox(height: 16),
              _ageWeightRow(),
              const SizedBox(height: 16),
              Expanded(child: _heightCard(expandSlider: true)),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _resultsCard(tabletMode: true),
              const SizedBox(height: 16),
              Expanded(child: _classificationSection(scrollable: false)),
            ],
          ),
        ),
      ],
    ),
  );
}
```

## 4.4 📚 \_classificationSection() - بناء جدول التصنيفات مع hint تفاعلي

<div style="background:#fff7ed;border:1px solid #fb923c;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تبني قسم المرجع الذي يعرض جميع تصنيفات BMI مع حدود كل تصنيف. الجديد أن كل صف قابل للضغط، وتظهر رسالة hint تدل على ذلك.

<br><br><b>⚙️ الفكرة الأساسية</b><br>
الدالة تستقبل باراميتر واحد اسمه <b>scrollable</b>، ومن خلاله تحدد هل ستتصرف كقسم عادي داخل صفحة قابلة للتمرير، أم كقسم يتمدد لملء المساحة داخل تخطيط التابلت.

<br><br><b>🆕 الإضافات الجديدة:</b>
<ul>
  <li>رسالة <b>hint</b> تحت العنوان تقول: "اضغط على أي صف لمعرفة الأمراض المرتبطة".</li>
  <li>كل صف يمرر <b>categoryKey</b> لـ _buildClassificationRow().</li>
  <li>الصفوف الآن لديها أيقونة chevron للدلالة على التفاعلية.</li>
</ul>

<b>📱 إذا كانت القيمة scrollable = true</b>

<ul>
  <li>ترجع <b>Column</b> عادية.</li>
  <li>الجدول يظهر بحجمه الطبيعي.</li>
  <li>يعمل بشكل مناسب داخل الهاتف لأن الصفحة أصلًا قابلة للتمرير.</li>
</ul>

<b>🖥️ إذا كانت القيمة scrollable = false</b>

<ul>
  <li>ترجع <b>Column</b> تحتوي على <b>Expanded(child: table)</b>.</li>
  <li>هذا يجعل الجدول يتمدد ليشغل المساحة المتوفرة في العمود الأيمن بالتابلت.</li>
</ul>

<b>🧠 لماذا هذا الفرق مهم؟</b>

<ul>
  <li>لأن <b>Expanded</b> لا يعمل بشكل صحيح داخل بعض السياقات القابلة للتمرير.</li>
  <li>لذلك الدالة تتجنب الخطأ في الهاتف، وتستفيد من التمدد في التابلت.</li>
  <li>هذه نقطة مهمة جدا لفهم الفرق بين <b>bounded height</b> و<b>unbounded height</b> في Flutter.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
Column
├─ Text ('REFERENCE')
├─ SizedBox (height: 4)
├─ Text ('diseases_tap_hint')  ← نص hint صغير
├─ SizedBox (height: 12)
│
└─ if (!scrollable)
   └─ Expanded ← للتابلت
       └─ table
else
   └─ table   ← للهاتف

حيث table =
BrutalistContainer
└─ Column (8 صفوف)
    ├─ _buildClassificationRow('VERY SEVERE', '< 16', ...)
    ├─ _buildClassificationRow('SEVERE', '16-17', ...)
    ├─ _buildClassificationRow('UNDERWEIGHT', '17-18.5', ...)
    ├─ ...
    └─ _buildClassificationRow('OBESE III', '> 40', isLast: true)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي الكامل</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_classificationSection()`

```dart
Widget _classificationSection({bool scrollable = true}) {
  final expandRows = !scrollable;

  final table = BrutalistContainer(
    backgroundColor: Colors.white,
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        _buildClassificationRow(_loc.translate('cat_vsu'), '< 16',      const Color(0xFFFF5252), categoryKey: 'cat_vsu', expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_su'),  '16 - 17',   const Color(0xFFFF7043), categoryKey: 'cat_su',  expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_u'),   '17 - 18.5', const Color(0xFFE65100), categoryKey: 'cat_u',   expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_n'),   '18.5 - 25', const Color(0xFF4CAF50), categoryKey: 'cat_n',   expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o'),   '25 - 30',   const Color(0xFFF57F17), categoryKey: 'cat_o',   expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o1'),  '30 - 35',   const Color(0xFFFF8A65), categoryKey: 'cat_o1',  expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o2'),  '35 - 40',   const Color(0xFFF4511E), categoryKey: 'cat_o2',  expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o3'),  '> 40',      const Color(0xFFD32F2F), categoryKey: 'cat_o3',  isLast: true, expand: expandRows),
      ],
    ),
  );

  final header = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        _loc.translate('reference'),
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
      ),
      const SizedBox(height: 4),
      Text(
        _loc.translate('diseases_tap_hint'),
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black45,
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: 12),
    ],
  );

  if (!scrollable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, Expanded(child: table)],
    );
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [header, table],
  );
}
```

## 4.5 🧱 \_buildClassificationRow() - صف مرجعي قابل للضغط مع expand اختياري

<div style="background:#f9fafb;border:1px solid #d1d5db;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تبني <b>صفًا واحدًا فقط</b> داخل جدول التصنيفات. الجديد أنها أصبحت <b>قابلة للضغط</b> بفضل GestureDetector وتنقلك إلى شاشة الأمراض.

<br><br><b>📦 ما الذي تمثله بيانات الصف؟</b>

<ul>
  <li><b>label</b>: اسم الفئة.</li>
  <li><b>range</b>: المجال الرقمي لهذه الفئة.</li>
  <li><b>color</b>: اللون البصري المرتبط بها.</li>
  <li><b>categoryKey</b>: مفتاح الفئة (مثل 'cat_n') - يستخدم للتنقل إلى DiseasesScreen.</li>
</ul>

<b>⚙️ ما وظيفة الباراميترات الإضافية؟</b>

<ul>
  <li><b>isLast</b>: يمنع رسم الحد السفلي إذا كان هذا آخر صف.</li>
  <li><b>expand</b>: يحدد هل الصف سيأخذ ارتفاعًا ثابتًا أم يتمدد داخل <b>Expanded</b>.</li>
</ul>

<b>🆕 ما الجديد؟</b>

<ul>
  <li>الصف يُغلف بـ <b>GestureDetector</b> لاستقبال الضغطات.</li>
  <li>عند الضغط يتم الانتقال إلى DiseasesScreen مع تمرير <b>highlightCategoryKey</b>.</li>
  <li>توجد أيقونة <b>chevron_right</b> (➜) في نهاية الصف للدلالة على التفاعلية.</li>
  <li>حجم النص في الصف أصبح 13 بدلاً من 14 (أصغر قليلاً).</li>
</ul>

<b>🧠 لماذا هذا التصميم جيد؟</b>

<ul>
  <li>يعيد استخدام نفس البنية بدل كتابة 8 صفوف يدويًا بأكواد مختلفة.</li>
  <li>يوحّد شكل الصفوف بالكامل.</li>
  <li>يسمح بتغيير السلوك بين الهاتف والتابلت من خلال باراميتر صغير فقط.</li>
  <li>الآن كل صف له وظيفة تفاعلية واضحة (التنقل إلى الأمراض).</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
GestureDetector (onTap: navigate to DiseasesScreen)
└─ Container
    ├─ height: expand ? null : 52
    ├─ padding: EdgeInsets(16, 0)
    ├─ decoration: Border (bottom if not isLast)
    └─ Row (mainAxisAlignment: spaceBetween)
        ├─ Expanded
        │   └─ Text ('NORMAL' ...) ← اسم الفئة
        │
        ├─ Text ('18.5 - 25')     ← المجال الرقمي
        ├─ SizedBox (width: 4)
        └─ Icon (chevron_right)   ← دلالة على التفاعل
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_buildClassificationRow()`

```dart
Widget _buildClassificationRow(
  String label,
  String range,
  Color color, {
  required String categoryKey,
  bool isLast  = false,
  bool expand  = false,
}) {
  final row = GestureDetector(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DiseasesScreen(
          highlightCategoryKey: categoryKey,
          localization: _loc,
        ),
      ),
    ),
    child: Container(
      height: expand ? null : 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            range,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(width: 4),
          // Chevron يشير إلى أن الصف قابل للضغط
          const Icon(Icons.chevron_right, size: 16, color: Colors.black38),
        ],
      ),
    ),
  );

  if (expand) return Expanded(child: row);
  return row;
}
```

## 4.6 🧩 \_buildAdaptiveDialog() - قالب dialog بعرض متكيف للتابلت/الهاتف

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة لا تحسب شيئا، لكنها تبني <b>القالب العام</b> لأي Dialog في الشاشة. بمعنى آخر: هي الهيكل الخارجي الموحد الذي ستوضع بداخله نافذة اختيار اللغة أو نافذة اختيار الوحدة.

<br><br><b>⚙️ كيف تعمل؟</b>

<ol>
  <li>تقرأ عرض الشاشة الحالي باستخدام <b>MediaQuery</b>.</li>
  <li>تحدد هل العرض يعتبر تابلت أم لا.</li>
  <li>تبني <b>Dialog</b> بخلفية شفافة.</li>
  <li>تغلف المحتوى داخل <b>ConstrainedBox</b> حتى لا يصبح الحوار عريضًا أكثر من اللازم على التابلت.</li>
</ol>

<b>🧠 لماذا هذه الدالة مهمة؟</b>

<ul>
  <li>توحد شكل الحوارات في كل الشاشة.</li>
  <li>تمنع الأحجام المزعجة على الأجهزة الكبيرة.</li>
  <li>تجعل أي Dialog جديد أسهل في الإضافة لاحقا.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
Dialog
  ├─ backgroundColor: transparent
  ├─ insetPadding: EdgeInsets(20, 24)
  └─ Center
      └─ ConstrainedBox
          ├─ maxWidth: isTablet ? 480 : infinity
          └─ [child] ← المحتوى الفعلي يمرر هنا
              (BrutalistContainer مثلا)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_buildAdaptiveDialog()`

```dart
Widget _buildAdaptiveDialog(BuildContext dialogContext, Widget child) {
  final screenWidth = MediaQuery.sizeOf(dialogContext).width;
  final isTablet = screenWidth >= _tabletBreakpoint;

  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isTablet ? 480 : double.infinity),
        child: child,
      ),
    ),
  );
}
```

## 4.7 ⚖️ \_showUnitDialog() - اختيار وحدة الوزن/الطول

<div style="background:#fefce8;border:1px solid #facc15;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تعرض للمستخدم نافذة لاختيار وحدة القياس، سواء لوحدة الوزن أو لوحدة الطول. الجميل فيها أنها <b>عامة</b> وليست مكتوبة لوحدة واحدة فقط.

<br><br><b>📥 ما الذي تستقبله؟</b>

<ul>
  <li><b>title</b>: عنوان النافذة.</li>
  <li><b>options</b>: قائمة الخيارات.</li>
  <li><b>currentOption</b>: الخيار المحدد حاليا.</li>
  <li><b>onSelected</b>: الدالة التي تنفذ عند اختيار قيمة جديدة.</li>
</ul>

<b>⚙️ كيف تعمل؟</b>

<ol>
  <li>تفتح Dialog باستخدام <b>showDialog</b>.</li>
  <li>تستخدم <b>_buildAdaptiveDialog</b> كقالب خارجي.</li>
  <li>تبني قائمة الخيارات بشكل قابل للنقر.</li>
  <li>عند الضغط على خيار:
    <ul>
      <li>تحدّث القيمة عبر <b>onSelected</b>.</li>
      <li>تغلق الحوار مباشرة عبر <b>Navigator.pop</b>.</li>
    </ul>
  </li>
</ol>

<b>🧠 لماذا هي مفيدة؟</b>

<ul>
  <li>تصلح للوزن والطول معًا.</li>
  <li>تختصر تكرار الكود.</li>
  <li>توحد سلوك نوافذ الاختيار.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
Dialog
└─ _buildAdaptiveDialog (قالب عام)
    └─ Center
        └─ ConstrainedBox (maxWidth: 480 للتابلت)
            └─ BrutalistContainer (backgroundColor: white)
                └─ Column (mainAxisSize.min)
                    ├─ Text (العنوان)
                    ├─ SizedBox
                    ├─ For each option:
                    │   └─ Padding
                    │       └─ BrutalistContainer (onTap)
                    │           └─ Row
                    │               ├─ Icon (radio button)
                    │               ├─ SizedBox
                    │               └─ Text (option label)
                    ├─ SizedBox
                    └─ BrutalistButton (Close)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_showUnitDialog()`

```dart
void _showUnitDialog(String title, List<String> options, String currentOption, Function(String) onSelected) {
  showDialog(
    context: context,
    builder: (dialogContext) => _buildAdaptiveDialog(
      dialogContext,
      BrutalistContainer(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ...options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BrutalistContainer(
                onTap: () {
                  onSelected(option);
                  Navigator.pop(dialogContext);
                },
                backgroundColor: option == currentOption ? const Color(0xFFFFDE59) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(option == currentOption ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 8),
            BrutalistButton(
              label: _loc.translate('close'),
              color: const Color(0xFFD32F2F),
              onTap: () => Navigator.pop(dialogContext),
            ),
          ],
        ),
      ),
    ),
  );
}
```

## 4.8 🌍 \_showLanguageDialog() - تغيير اللغة داخل الشاشة

<div style="background:#f0fdf4;border:1px solid #4ade80;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 الدور الرئيسي</b><br>
هذه الدالة تعرض نافذة تغيير اللغة من داخل الشاشة نفسها، بدون الحاجة للخروج من الصفحة أو إعادة تشغيل التطبيق.

<br><br><b>⚙️ كيف تختلف عن \_showUnitDialog؟</b>

<ul>
  <li>الشكل العام متشابه.</li>
  <li>لكن البيانات هنا تأتي من <b>AppLocalization.languages</b>.</li>
  <li>وعند اختيار لغة جديدة يتم استدعاء <b>_changeLanguage(entry.key)</b>.</li>
</ul>

<b>🔁 ماذا يحدث بعد اختيار اللغة؟</b>

<ol>
  <li>يتغير <b>_currentLang</b>.</li>
  <li>يعاد إنشاء كائن <b>_loc</b>.</li>
  <li>تعمل الشاشة rebuild.</li>
  <li>تتغير النصوص واتجاه الواجهة فورا.</li>
</ol>

<b>🧠 لماذا هذا ممتاز لتجربة المستخدم؟</b>

<ul>
  <li>لأن المستخدم يرى أثر اختياره مباشرة.</li>
  <li>ولأن تغيير اللغة لا يحتاج خطوات إضافية.</li>
  <li>كما أن نفس البنية قابلة للتوسع إذا أضيفت لغات جديدة لاحقا.</li>
</ul>
</div>

### 🎨 هيكل الـ Widgets:

```
Dialog
└─ _buildAdaptiveDialog
    └─ Center
        └─ ConstrainedBox
            └─ BrutalistContainer (white)
                └─ Column
                    ├─ Text ('select_language')
                    ├─ SizedBox
                    ├─ For each language:
                    │   └─ Padding
                    │       └─ BrutalistContainer (onTap, yellow if current)
                    │           └─ Row
                    │               ├─ Icon (radio button)
                    │               ├─ SizedBox
                    │               └─ Text (language name)
                    ├─ SizedBox
                    └─ BrutalistButton (Close - Red)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود الفعلي للدالة: `_showLanguageDialog()`

```dart
void _showLanguageDialog() {
  showDialog(
    context: context,
    builder: (dialogContext) => _buildAdaptiveDialog(
      dialogContext,
      BrutalistContainer(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_loc.translate('select_language'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ...AppLocalization.languages.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BrutalistContainer(
                onTap: () {
                  _changeLanguage(entry.key);
                  Navigator.pop(dialogContext);
                },
                backgroundColor: entry.key == _currentLang ? const Color(0xFFFFDE59) : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(entry.key == _currentLang ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.black),
                    const SizedBox(width: 12),
                    Text(entry.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 8),
            BrutalistButton(
              label: _loc.translate('close'),
              color: const Color(0xFFD32F2F),
              onTap: () => Navigator.pop(dialogContext),
            ),
          ],
        ),
      ),
    ),
  );
}
```

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🛠️ 5) شرح باقي أجزاء الملف بالتفصيل للمبتدئ

## 5.1 🧭 build + Directionality + LayoutBuilder

### 🎨 هيكل الـ Widgets:

```
Scaffold
├─ backgroundColor: Colors.white
│
└─ body:
    Directionality (textDirection based on language)
    └─ Padding
        └─ LayoutBuilder
            └─ if width < 600:
                   _buildPhoneLayout()
               else:
                   _buildTabletLayout()
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط الكامل التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

build يلف الشاشة داخل Directionality:

- RTL للعربية.
- LTR للإنجليزية.

ثم LayoutBuilder يحدد التخطيط حسب العرض:

- أقل من 600 -> \_buildPhoneLayout.
- 600 أو أكثر -> \_buildTabletLayout.

<div style="background:#e0f2fe;border:1px solid #38bdf8;border-radius:10px;padding:10px 12px;color:#0f172a;">
📌 هذه الطريقة أدق من الاعتماد على اسم الجهاز، لأنها تعتمد على <b>العرض الفعلي</b>.
</div>

## 5.2 👥 \_genderRow و \_buildGenderCard

### 🎨 هيكل الـ Widgets - \_genderRow:

```
Row (mainAxisAlignment: spaceBetween)
├─ Expanded
│   └─ _buildGenderCard('MALE', Icons.male, isMale, size=40)
│
└─ Expanded
    └─ _buildGenderCard('FEMALE', Icons.female, !isMale, size=40)
```

### 🎨 هيكل الـ Widgets - \_buildGenderCard:

```
GestureDetector (onTap: toggle gender)
└─ Column (mainAxisAlignment.center)
    ├─ Container
    │   ├─ padding & decoration
    │   └─ Icon (size variable)
    │
    └─ SizedBox (height: 8)
    └─ Text (label, fontWeight.w900)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

\_genderRow ينشئ بطاقتين Male/Female باستخدام \_buildGenderCard.

عند الضغط:

1. يتم تغيير isMale.
2. يتم استدعاء \_calculate.

\_buildGenderCard يعرض حالة selected بلون مختلف، وهذا يعطي Feedback بصري واضح.

## 5.3 🔢 \_ageWeightRow و \_buildCounterCard

### 🎨 هيكل الـ Widgets - \_ageWeightRow:

```
Row (mainAxisAlignment: spaceBetween)
├─ Expanded
│   └─ _buildCounterCard(
│       'AGE', age, ±1, 
│       showUnitBadge=false
│     )
│
└─ Expanded
    └─ _buildCounterCard(
        'WEIGHT', weight, ±0.5,
        showUnitBadge=true,
        unit=isKg?'kg':'lb'
      )
```

### 🎨 هيكل الـ Widgets - \_buildCounterCard:

```
BrutalistContainer
├─ padding & backgroundColor
├─ Column
│   ├─ Row (spaceBetween)
│   │   ├─ Expanded
│   │   │   └─ Text (title)
│   │   │
│   │   └─ if showUnitBadge:
│   │       └─ Container (badge)
│   │           └─ Text (unit)
│   │
│   ├─ SizedBox (height: 12)
│   │
│   └─ Row (mainAxisAlignment.spaceBetween)
│       ├─ _buildRoundButton('-', decrement)
│       ├─ Text (value)
│       └─ _buildRoundButton('+', increment)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

\_ageWeightRow يحتوي بطاقتين:

- العمر: عداد +/−.
- الوزن: عداد + زر وحدة.

نقطة مهمة جدا:

- الوزن يخزن دائما بالكيلوغرام داخليا، حتى لو المستخدم يعرضه بالباوند.
- عند العرض فقط يتم التحويل.

هذا يقلل أخطاء التحويل المتكرر ويحافظ على دقة الحساب.

\_buildCounterCard هو كومبوننت قابل لإعادة الاستخدام لأي قيمة رقمية.

## 5.4 📏 \_heightCard و \_formatHeightInFeet

### 🎨 هيكل الـ Widgets - \_heightCard:

```
BrutalistContainer
└─ Column
    ├─ Row (spaceBetween)
    │   ├─ Expanded
    │   │   └─ Text ('HEIGHT')
    │   │
    │   └─ _buildRoundButton(
    │       Icons.settings_outlined,
    │       _showUnitDialog (for height)
    │     )
    │
    ├─ SizedBox (height: 12)
    │
    ├─ Row (mainAxisAlignment.center)
    │   ├─ _buildRoundButton('-', decrement height)
    │   ├─ SizedBox (width: 12)
    │   ├─ Expanded
    │   │   └─ Text (formatted height)
    │   │
    │   └─ _buildRoundButton('+', increment height)
    │
    ├─ SizedBox (height: 12)
    │
    └─ if expandSlider:
        └─ Expanded
            └─ Slider
       else:
        └─ Slider
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

\_heightCard يعرض:

- عنوان Height.
- الرقم الحالي (cm أو ft+in).
- زر تغيير الوحدة.
- Slider من 100 إلى 220 cm.

حتى عندما تعرض FT+IN، التخزين الداخلي يبقى cm.

\_formatHeightInFeet يحول من cm إلى feet/inches للعرض فقط.

في وضع التابلت، expandSlider=true يضيف Spacer لتحسين توزيع العناصر عموديا.

## 5.5 📊 \_resultsCard

### 🎨 هيكل الـ Widgets:

```
BrutalistContainer
└─ Column
    ├─ Text ('RESULTS') - header
    ├─ SizedBox
    │
    └─ IntrinsicHeight
        └─ Row (mainAxisAlignment.spaceBetween)
            │
            ├─ Column (flex: expand)
            │   ├─ Text ('IDEAL WEIGHT')
            │   ├─ SizedBox
            │   └─ FittedBox
            │       └─ Text (idealWeight + unit)
            │
            ├─ VerticalDivider
            │
            ├─ Column (flex: 1.5) ← أكبر حجم
            │   ├─ Text ('BMI')
            │   ├─ SizedBox
            │   ├─ Container (color background)
            │   │   └─ Text (bmi value, fontSize: 32)
            │   │
            │   └─ Text (classification label)
            │
            ├─ VerticalDivider
            │
            └─ Column (flex: expand)
                ├─ Text ('FAT %')
                ├─ SizedBox
                └─ FittedBox
                    └─ Text (fat percentage)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

بطاقة النتائج مقسمة 3 أجزاء:

1. Ideal weight.
2. BMI (أكبر جزء بصري).
3. Fat percentage.

تفاصيل مهمة:

- BMI في الوسط وبخلفية مميزة لأنه القيمة الأساسية.
- التصنيف يترجم عبر \_loc.translate(classificationKey).
- نص الوزن المثالي داخل FittedBox + سطر واحد لتجنب التفاف kg/lb.

## 5.6 🌐 \_changeLanguage

وظيفتها بسيطة لكن أساسية:

1. تحديث كود اللغة.
2. إنشاء كائن ترجمة جديد.
3. setState لإعادة بناء النصوص.

## 5.7 ➕➖ \_buildRoundButton

زر دائري صغير للزيادة والنقصان:

- يستخدم GestureDetector.
- تصميم بسيط وثابت.
- قابل لإعادة الاستخدام داخل العدادات.

### 🎨 هيكل الـ Widgets:

```
GestureDetector (onTap)
  └─ Container
      ├─ padding: EdgeInsets.all(12)
      ├─ decoration: 
      │   ├─ color: Colors.black
      │   ├─ shape: BoxShape.circle
      │   └─ border: 2px black
      └─ Icon (white color)
```

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:10px;padding:10px 12px;margin-top:8px;color:#0f172a;">
📌 <b>للمخطط التفصيلي</b> راجع: <b>widget_trees.md</b>
</div>

### 💻 الكود مع الملاحظات:

```dart
/// Custom widget factory لزر دائري قابل لإعادة الاستخدام
Widget _buildRoundButton(
  IconData icon,                            // أيقونة الزر (add أو remove)
  VoidCallback onTap, {                     // الدالة المطلوبة عند الضغط
  double iconSize = 24,                     // حجم الأيقونة
  EdgeInsets padding = const EdgeInsets.all(12), // الحشوة الداخلية
}) {
  return GestureDetector(
    onTap: onTap,                           // عند الضغط استدعي الدالة
    child: Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black,                // خلفية سوداء
        shape: BoxShape.circle,             // شكل دائري مثالي
        border: Border.all(
            color: Colors.black, width: 2),
      ),
      child: Icon(icon, color: Colors.white, size: iconSize), // أيقونة بيضاء
    ),
  );
}
```

## 5.8 🎓 \_checkAndShowTutorial و \_navigateToTutorial

<div style="background:#faf5ff;border:1px solid #c084fc;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي وظيفتهما؟</b><br>

**\_checkAndShowTutorial():**
- تُستدعى مرة واحدة فقط من initState في post-frame callback.
- تقرأ من SharedPreferences هل شاهد المستخدم النموذج قبلا.
- إذا لم يشاهده، تعرض TutorialScreen.
- بعدها تحفظ في SharedPreferences أنه شاهد النموذج.

**\_navigateToTutorial():**
- تُستدعى من قائمة ⋮ Menu إذا أراد المستخدم فتح النموذج مجددا.
- تفتح TutorialScreen بدون التحقق من SharedPreferences.

<b>📌 لماذا هذا التقسيم؟</b>

- النموذج التعليمي ظاهر فقط للمستخدم الجديد.
- لكن المستخدم الخبير يستطيع أن يراه مرة أخرى إذا أراد.
</div>

### 💻 الكود:

```dart
Future<void> _checkAndShowTutorial() async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenTutorial = prefs.getBool(_prefKeyTutorial) ?? false;
  if (!hasSeenTutorial && mounted) {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TutorialScreen(localization: _loc)),
    );
    await prefs.setBool(_prefKeyTutorial, true);
  }
}

Future<void> _navigateToTutorial() async {
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => TutorialScreen(localization: _loc)),
  );
}
```

## 5.9 📺 \_loadBannerAd و \_buildBannerArea

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي الإعلانات؟</b><br>

**\_loadBannerAd():**
- تحمّل إعلان Banner متكيف حسب عرض الشاشة.
- تستخدم معرّف الإعلان المناسب للنظام (Android/iOS).
- عند نجاح التحميل: تحدّث \_bannerAd و \_isBannerAdReady.
- عند الفشل: تطبع رسالة debug وتخفي الإعلان.

**\_buildBannerArea():**
- تعرض الإعلان في الواجهة داخل SafeArea.
- إذا لم يتم تحميل الإعلان: ترجع SizedBox.shrink() (ارتفاع صفر).
- الإعلان يظهر في bottomNavigationBar.

<b>📌 نقاط مهمة:</b>
<ul>
  <li>معرف الإعلان للـ Android: ca-app-pub-5785609346141040/9590890493</li>
  <li>معرف الإعلان للـ iOS: test unit id (للاختبار فقط).</li>
  <li>الإعلان <b>يتكيف</b> مع عرض الجهاز تلقائيا.</li>
  <li>إذا فشل التحميل، الواجهة لا تنهار - تبقى طبيعية.</li>
</ul>
</div>


## 5.10 ⚙️ \_bannerAdUnitId - اختيار معرف الإعلان حسب النظام

<div style="background:#fff7ed;border:1px solid #fb923c;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي وظيفتها؟</b><br>

خاصية (property) تعيد معرف الإعلان الصحيح حسب النظام الحالي:

- إذا كان Android: ترجع معرف الإعلان الحقيقي للإنتاج.
- إذا كان iOS: ترجع معرف إعلان اختبار (test unit).
- غير ذلك: ترجع null (لا توجد إعلانات).

<b>📌 لماذا test unit للـ iOS؟</b>

لأن Google AdMob تطلب استخدام test units للاختبار، وإلا فقد تُعلّق الحساب إذا لاحظت استخدام معرف إنتاج أثناء التطوير.
</div>

### 💻 الكود:

```dart
String? get _bannerAdUnitId {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android: return _androidBannerAdUnitId;
    case TargetPlatform.iOS:     return _iosTestBannerAdUnitId;
    default:                     return null;
  }
}
```

## 5.11 🔄 \_changeHeightByStep و \_heightStep

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي وظيفتهما؟</b><br>

**\_heightStep** (getter):
- ترجع خطوة التغيير حسب الوحدة الحالية.
- إذا كان cm: 1 cm.
- إذا كان ft+in: 2.54 cm (تقريباً 1 inch).

**\_changeHeightByStep(direction)**:
- تزيد أو تنقص الطول بمقدار الخطوة.
- تضمن أن القيمة تبقى بين 100-220 cm باستخدام clamp.
- تستدعي \_calculate لإعادة حساب BMI.

<b>📌 مثال:</b>
<ul>
  <li>إذا كنت في cm وضغطت + : الطول يزيد 1 cm.</li>
  <li>إذا كنت في ft+in وضغطت + : الطول يزيد 2.54 cm (~ 1 inch).</li>
</ul>
</div>

### 💻 الكود:

```dart
double get _heightStep => isCm ? 1.0 : cmPerInch;

void _changeHeightByStep(int direction) {
  final updated =
      (height + (direction * _heightStep)).clamp(_minHeightCm, _maxHeightCm);
  setState(() {
    height = updated.toDouble();
    _calculate();
  });
}
```

## 5.12 🌐 \_restoreSavedLanguage و \_changeLanguage

<div style="background:#f0fdf4;border:1px solid #4ade80;border-radius:12px;padding:12px 14px;color:#0f172a;">
<b>🎯 ما هي وظيفتهما؟</b><br>

**\_restoreSavedLanguage()**:
- تُستدعى من initState بعد تحديد اللغة الافتراضية.
- تقرأ من SharedPreferences آخر لغة اختارها المستخدم.
- إذا كانت موجودة وآمنة: تستخدمها.
- هذا يضمن أن تفضيل المستخدم يُحفظ بين التطبيقات.

**\_changeLanguage(langCode)**:
- تُستدعى عند اختيار لغة جديدة من القائمة.
- تحفظ اللغة الجديدة في SharedPreferences.
- تحدّث \_currentLang و \_loc.
- تستدعي setState لإعادة رسم الواجهة بالكامل.

<b>🧠 لماذا هذا ضروري؟</b>

- المستخدم قد يختار لغة غير لغة النظام.
- يجب أن نتذكر اختياره عند فتح التطبيق مجددا.
- SharedPreferences توفر طريقة سهلة وخفيفة للحفظ الدائم.
</div>

### 💻 الكود:

```dart
Future<void> _restoreSavedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString(_prefKeyLanguage);

  if (!mounted || savedLang == null) return;
  if (!AppLocalization.languages.containsKey(savedLang)) return;
  if (savedLang == _currentLang) return;

  setState(() {
    _currentLang = savedLang;
    _loc = AppLocalization(savedLang);
  });
}

Future<void> _changeLanguage(String langCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_prefKeyLanguage, langCode);

  setState(() {
    _currentLang = langCode;
    _loc         = AppLocalization(langCode);
  });
}
```

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

أسباب القوة المعمارية:

- فصل منطق الحساب عن الواجهة.
- وجود دوال builder صغيرة لكل جزء.
- إعادة استخدام قوالب مشتركة (counter card, adaptive dialog).
- دعم RTL/LTR من نفس الشجرة بدون نسخة واجهة ثانية.
- تصميم متكيف حقيقي بين الهاتف والتابلت.

<div style="background:#f0fdf4;border:1px dashed #22c55e;border-radius:10px;padding:10px 12px;color:#0f172a;">
✅ هذا يجعل صيانة الشاشة أسهل وإضافة ميزات مستقبلية أسرع.
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🔁 7) ملخص سريع للمبتدئ

إذا أردت فهم الملف بسرعة، احفظ هذه الفكرة:

1. أي Input يتغير -> setState.
2. setState يستدعي \_calculate.
3. \_calculate يحدث BMI والتصنيف واللون.
4. build يرسم الواجهة حسب عرض الشاشة.
5. localization تحدد اللغة والاتجاه تلقائيا.

<div style="background:linear-gradient(90deg,#111827,#1f2937);color:#f9fafb;border-radius:12px;padding:12px 14px;margin-top:10px;">
🌟 بهذا تكون فهمت البنية الأساسية كلها، ثم يمكنك التعمق في كل دالة كما شرحنا فوق.
</div>

</div>
