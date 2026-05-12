<div dir="rtl" style="line-height:1.85;max-width:1100px;margin:0 auto;padding:0 10px;">

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

initState يقوم بثلاث خطوات أساسية:

1. يقرأ لغة النظام من PlatformDispatcher.
2. إذا اللغة مدعومة في AppLocalization يستخدمها، وإلا يعود للإنجليزية.
3. يستدعي \_calculate حتى تظهر الشاشة بنتيجة صحيحة من أول لحظة.

<div style="background:#fef3c7;border:1px solid #f59e0b;border-radius:10px;padding:10px 12px;color:#0f172a;">
⚠️ <b>لماذا مهم استدعاء _calculate هنا؟</b><br>
بدونه قد تظهر النتائج فارغة أو بقيم غير متناسقة عند أول فتح.
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🧩 4) شرح مفصل للدوال المطلوبة

## 4.1 🧮 \_calculate() - حساب BMI + التصنيف + اللون

<div style="background:#f0fdf4;border:1px solid #4ade80;border-radius:12px;padding:12px 14px;color:#0f172a;">
هذه أهم دالة من ناحية المنطق.

<b>ماذا تفعل؟</b>

<ol>
  <li>تدخل setState حتى أي تغيير ينعكس على الواجهة.</li>
  <li>تستدعي BMICalculator.calculateBMI(height, weight).</li>
  <li>تستدعي BMICalculator.getClassification(bmi).</li>
  <li>تحفظ:
    <ul>
      <li>classificationKey (اسم التصنيف كمفتاح ترجمة).</li>
      <li>classificationColor (اللون المناسب للتصنيف).</li>
    </ul>
  </li>
</ol>

<b>لماذا هذا التصميم جيد؟</b>

<ul>
  <li>🧠 منطق الحساب في ملف منفصل bmi_logic.dart.</li>
  <li>🎨 الشاشة تركز على واجهة المستخدم فقط.</li>
  <li>🧪 سهل الاختبار والصيانة.</li>
</ul>

<b>متى تستدعى \_calculate؟</b>

<ul>
  <li>عند تغيير الجنس.</li>
  <li>عند تغيير العمر.</li>
  <li>عند تغيير الوزن.</li>
  <li>عند تحريك Slider الطول.</li>
  <li>عند تغيير وحدة القياس (لتحديث القيم المعروضة).</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _calculate()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">void _calculate()</span> {
  <span style="color:#22d3ee;">setState</span>(() {
    bmi = <span style="color:#facc15;">BMICalculator.calculateBMI</span>(height, weight);
    final result = <span style="color:#f97316;">BMICalculator.getClassification</span>(bmi);
    classificationKey = <span style="color:#4ade80;">result.key</span>;
    classificationColor = <span style="color:#4ade80;">result.color</span>;
  });
}</pre>
  </div>
</div>

## 4.2 📱 \_buildPhoneLayout() - تخطيط الهاتف (عمود قابل للتمرير)

<div style="background:#eff6ff;border:1px solid #60a5fa;border-radius:12px;padding:12px 14px;color:#0f172a;">
على الهاتف، العرض محدود، لذلك يتم وضع كل الأقسام في Column واحدة داخل SingleChildScrollView.

<b>ترتيب الأقسام:</b>

<ol>
  <li>اختيار الجنس.</li>
  <li>العمر والوزن.</li>
  <li>بطاقة الطول.</li>
  <li>بطاقة النتائج.</li>
  <li>جدول التصنيفات.</li>
</ol>

<b>لماذا SingleChildScrollView؟</b>

<ul>
  <li>لأن المحتوى غالبا أطول من الشاشة.</li>
  <li>يضمن الوصول لكل جزء بالسحب للأعلى/الأسفل.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _buildPhoneLayout()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">Widget _buildPhoneLayout()</span> {
  return <span style="color:#22d3ee;">SingleChildScrollView</span>(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        <span style="color:#facc15;">_genderRow()</span>,
        const SizedBox(height: 24),
        <span style="color:#facc15;">_ageWeightRow()</span>,
        const SizedBox(height: 24),
        <span style="color:#facc15;">_heightCard()</span>,
        const SizedBox(height: 32),
        <span style="color:#facc15;">_resultsCard()</span>,
        const SizedBox(height: 32),
        <span style="color:#facc15;">_classificationSection()</span>,
        const SizedBox(height: 40),
      ],
    ),
  );
}</pre>
  </div>
</div>

## 4.3 🖥️ \_buildTabletLayout() - تخطيط التابلت (عمودان بلا تمرير عام)

<div style="background:#faf5ff;border:1px solid #c084fc;border-radius:12px;padding:12px 14px;color:#0f172a;">
على التابلت، الشاشة أوسع؛ لذلك التصميم يصبح Dashboard من عمودين:
<ul>
  <li>⬅️ العمود الأيسر: المدخلات.</li>
  <li>➡️ العمود الأيمن: النتائج + جدول التصنيفات.</li>
</ul>

<b>تفاصيل العمود الأيسر:</b>

<ol>
  <li>صف الجنس (ارتفاع ثابت).</li>
  <li>صف العمر/الوزن (ارتفاع ثابت).</li>
  <li>بطاقة الطول داخل Expanded لتملأ باقي المساحة.</li>
</ol>

<b>تفاصيل العمود الأيمن:</b>

<ol>
  <li>بطاقة النتائج (ارتفاع ثابت تقريبا).</li>
  <li>جدول التصنيفات داخل Expanded ليملأ ما تبقى.</li>
</ol>

<b>لماذا بلا تمرير عام؟</b>

<ul>
  <li>⚡ تجربة أسرع على الشاشات الكبيرة.</li>
  <li>👀 كل شيء يظهر في نفس الوقت غالبا.</li>
  <li>🧱 إحساس أقرب للوحة معلومات ثابتة.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _buildTabletLayout()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">Widget _buildTabletLayout()</span> {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        <span style="color:#22d3ee;">Expanded</span>(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _genderRow(iconSize: 52, fontSize: 16),
              const SizedBox(height: 16),
              _ageWeightRow(),
              const SizedBox(height: 16),
              <span style="color:#facc15;">Expanded(child: _heightCard(expandSlider: true))</span>,
            ],
          ),
        ),
        const SizedBox(width: 20),
        <span style="color:#22d3ee;">Expanded</span>(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _resultsCard(tabletMode: true),
              const SizedBox(height: 16),
              <span style="color:#f97316;">Expanded(child: _classificationSection(scrollable: false))</span>,
            ],
          ),
        ),
      ],
    ),
  );
}</pre>
  </div>
</div>

## 4.4 📚 \_classificationSection() - بناء جدول التصنيفات بسلوكين (scrollable / non-scrollable)

<div style="background:#fff7ed;border:1px solid #fb923c;border-radius:12px;padding:12px 14px;color:#0f172a;">
هذه الدالة تبني قسم المرجع (Reference) الذي يحتوي على مستويات BMI.

<b>لها باراميتر مهم: scrollable</b>

<ul>
  <li>إذا scrollable = true (وضع الهاتف):
    <ul>
      <li>ترجع Column عادية.</li>
      <li>الجدول يظهر بحجم طبيعي داخل الصفحة القابلة للتمرير.</li>
    </ul>
  </li>
  <li>إذا scrollable = false (وضع التابلت):
    <ul>
      <li>ترجع Column فيها Expanded(child: table).</li>
      <li>الجدول يتمدد ليملأ المساحة في العمود الأيمن.</li>
    </ul>
  </li>
</ul>

<b>لماذا هذا الفرق مهم جدا؟</b>

<ul>
  <li>استخدام Expanded داخل بيئة غير محدودة الارتفاع قد يسبب أخطاء layout.</li>
  <li>هذا التصميم يتجنب المشكلة في الهاتف ويستفيد من التمدد في التابلت.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _classificationSection()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">Widget _classificationSection({bool scrollable = true})</span> {
  final expandRows = <span style="color:#22d3ee;">!scrollable</span>;
  final table = BrutalistContainer(
    backgroundColor: Colors.white,
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        _buildClassificationRow(_loc.translate('cat_vsu'), '&lt; 16',      const Color(0xFFFF5252), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_su'),  '16 - 17',   const Color(0xFFFF7043), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_u'),   '17 - 18.5', const Color(0xFFE65100), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_n'),   '18.5 - 25', const Color(0xFF4CAF50), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o'),   '25 - 30',   const Color(0xFFF57F17), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o1'),  '30 - 35',   const Color(0xFFFF8A65), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o2'),  '35 - 40',   const Color(0xFFF4511E), expand: expandRows),
        _buildClassificationRow(_loc.translate('cat_o3'),  '&gt; 40',      const Color(0xFFD32F2F), isLast: true, expand: expandRows),
      ],
    ),
  );

<span style="color:#f97316;">if (!scrollable)</span> {
return Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text(_loc.translate('reference'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
const SizedBox(height: 12),
<span style="color:#facc15;">Expanded(child: table)</span>,
],
);
}

return Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Text(_loc.translate('reference'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
const SizedBox(height: 12),
table,
],
);
}</pre>

  </div>
</div>

## 4.5 🧱 \_buildClassificationRow() - صف مرجعي مع expand اختياري

<div style="background:#f9fafb;border:1px solid #d1d5db;border-radius:12px;padding:12px 14px;color:#0f172a;">
كل صف في الجدول يمثل:
<ul>
  <li>اسم الفئة (label).</li>
  <li>النطاق الرقمي (range).</li>
  <li>اللون الدلالي (color).</li>
</ul>

<b>الباراميترات:</b>

<ul>
  <li>isLast: إذا الصف الأخير، لا يضيف خط سفلي.</li>
  <li>expand:
    <ul>
      <li>false: ارتفاع ثابت (52).</li>
      <li>true: يرجع Expanded(child: row) لتوزيع المساحة عموديا.</li>
    </ul>
  </li>
</ul>

<b>متى نستخدم expand=true؟</b>

<ul>
  <li>في وضع التابلت غير القابل للتمرير حتى تتوازن الصفوف بصريا.</li>
</ul>

<b>متى نستخدم expand=false؟</b>

<ul>
  <li>في وضع الهاتف القابل للتمرير لتجنب مشاكل القيود.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _buildClassificationRow()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">Widget _buildClassificationRow(
  String label,
  String range,
  Color color, {
  bool isLast = false,
  bool expand = false,
})</span> {
  final row = Container(
    <span style="color:#22d3ee;">height: expand ? null : 52</span>,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    decoration: BoxDecoration(
      border: isLast ? null : const Border(bottom: BorderSide(color: Colors.black, width: 1)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        Text(range, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
      ],
    ),
  );

<span style="color:#f97316;">if (expand)</span> {
return <span style="color:#facc15;">Expanded(child: row)</span>;
}

return row;
}</pre>

  </div>
</div>

## 4.6 🧩 \_buildAdaptiveDialog() - قالب dialog بعرض متكيف للتابلت/الهاتف

<div style="background:#ecfeff;border:1px solid #22d3ee;border-radius:12px;padding:12px 14px;color:#0f172a;">
هذه دالة تصميم (UI shell) وليست دالة منطق.

<b>ماذا تفعل؟</b>

<ol>
  <li>تقرأ عرض الشاشة من MediaQuery.</li>
  <li>تعتبر الجهاز تابلت إذا العرض >= 600.</li>
  <li>ترجع Dialog شفاف الخلفية.</li>
  <li>داخل Dialog تستخدم ConstrainedBox:
    <ul>
      <li>maxWidth = 480 في التابلت.</li>
      <li>maxWidth غير محدود تقريبا في الهاتف.</li>
    </ul>
  </li>
</ol>

<b>الفائدة:</b>

<ul>
  <li>🎨 توحيد شكل الحوارات.</li>
  <li>📐 منع التمدد المزعج على الشاشات العريضة.</li>
  <li>♻️ إعادة استخدام القالب في أكثر من مكان.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _buildAdaptiveDialog()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">Widget _buildAdaptiveDialog(BuildContext dialogContext, Widget child)</span> {
  final screenWidth = <span style="color:#22d3ee;">MediaQuery.sizeOf(dialogContext).width</span>;
  final isTablet = <span style="color:#f97316;">screenWidth &gt;= _tabletBreakpoint</span>;

return Dialog(
backgroundColor: Colors.transparent,
insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
child: Center(
child: ConstrainedBox(
constraints: BoxConstraints(
<span style="color:#facc15;">maxWidth: isTablet ? 480 : double.infinity</span>,
),
child: child,
),
),
);
}</pre>

  </div>
</div>

## 4.7 ⚖️ \_showUnitDialog() - اختيار وحدة الوزن/الطول

<div style="background:#fefce8;border:1px solid #facc15;border-radius:12px;padding:12px 14px;color:#0f172a;">
هذه الدالة تفتح نافذة اختيار وحدة قياس.

<b>مدخلاتها:</b>

<ul>
  <li>title: عنوان النافذة.</li>
  <li>options: الخيارات (KG/LB أو CM/FT + IN).</li>
  <li>currentOption: الخيار الحالي.</li>
  <li>onSelected: ما ينفذ عند اختيار المستخدم.</li>
</ul>

<b>كيف تعمل؟</b>

<ol>
  <li>showDialog يفتح النافذة.</li>
  <li>تستخدم _buildAdaptiveDialog لعرض مناسب لكل جهاز.</li>
  <li>تعرض الخيارات كعناصر قابلة للنقر.</li>
  <li>عند اختيار عنصر:
    <ul>
      <li>تنفذ onSelected(option).</li>
      <li>تغلق النافذة Navigator.pop.</li>
    </ul>
  </li>
  <li>يوجد زر Close للإغلاق اليدوي.</li>
</ol>

<b>لماذا مفيدة؟</b>

<ul>
  <li>نفس الدالة تصلح للوزن والطول.</li>
  <li>تقلل تكرار الكود.</li>
  <li>سلوك موحد للمستخدم.</li>
</ul>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _showUnitDialog()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">void _showUnitDialog(String title, List&lt;String&gt; options, String currentOption, Function(String) onSelected)</span> {
  <span style="color:#22d3ee;">showDialog</span>(
    context: context,
    builder: (dialogContext) =&gt; <span style="color:#facc15;">_buildAdaptiveDialog</span>(
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
            ...options.map((option) =&gt; Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BrutalistContainer(
                onTap: () { <span style="color:#4ade80;">onSelected(option)</span>; <span style="color:#f97316;">Navigator.pop(dialogContext)</span>; },
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
              onTap: () =&gt; Navigator.pop(dialogContext),
            ),
          ],
        ),
      ),
    ),
  );
}</pre>
  </div>
</div>

## 4.8 🌍 \_showLanguageDialog() - تغيير اللغة داخل الشاشة

<div style="background:#f0fdf4;border:1px solid #4ade80;border-radius:12px;padding:12px 14px;color:#0f172a;">
تشبه _showUnitDialog في الشكل، لكن المصدر مختلف:
<ul>
  <li>الخيارات تأتي من AppLocalization.languages.</li>
  <li>عند الاختيار تستدعي _changeLanguage(entry.key).</li>
</ul>

<b>نتيجة اختيار اللغة:</b>

<ol>
  <li>تحديث _currentLang.</li>
  <li>إعادة إنشاء _loc.</li>
  <li>إعادة بناء الشاشة مباشرة.</li>
  <li>كل النصوص تتغير فورا عبر _loc.translate(...).</li>
</ol>
</div>

<div dir="ltr" style="margin:10px 0 18px 0;text-align:left;">
  <div style="background:#0b1220;border:1px solid #334155;border-radius:12px;overflow:auto;padding:12px 14px;color:#e2e8f0;">
    <div style="color:#93c5fd;font-weight:800;margin-bottom:8px;">Actual Method Code: _showLanguageDialog()</div>
    <pre style="margin:0;white-space:pre;direction:ltr;text-align:left;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.65;"><span style="color:#c084fc;">void _showLanguageDialog()</span> {
  <span style="color:#22d3ee;">showDialog</span>(
    context: context,
    builder: (dialogContext) =&gt; <span style="color:#facc15;">_buildAdaptiveDialog</span>(
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
            ...AppLocalization.languages.entries.map((entry) =&gt; Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BrutalistContainer(
                onTap: () { <span style="color:#4ade80;">_changeLanguage(entry.key)</span>; <span style="color:#f97316;">Navigator.pop(dialogContext)</span>; },
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
              onTap: () =&gt; Navigator.pop(dialogContext),
            ),
          ],
        ),
      ),
    ),
  );
}</pre>
  </div>
</div>

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🛠️ 5) شرح باقي أجزاء الملف بالتفصيل للمبتدئ

## 5.1 🧭 build + Directionality + LayoutBuilder

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

\_genderRow ينشئ بطاقتين Male/Female باستخدام \_buildGenderCard.

عند الضغط:

1. يتم تغيير isMale.
2. يتم استدعاء \_calculate.

\_buildGenderCard يعرض حالة selected بلون مختلف، وهذا يعطي Feedback بصري واضح.

## 5.3 🔢 \_ageWeightRow و \_buildCounterCard

\_ageWeightRow يحتوي بطاقتين:

- العمر: عداد +/−.
- الوزن: عداد + زر وحدة.

نقطة مهمة جدا:

- الوزن يخزن دائما بالكيلوغرام داخليا، حتى لو المستخدم يعرضه بالباوند.
- عند العرض فقط يتم التحويل.

هذا يقلل أخطاء التحويل المتكرر ويحافظ على دقة الحساب.

\_buildCounterCard هو كومبوننت قابل لإعادة الاستخدام لأي قيمة رقمية.

## 5.4 📏 \_heightCard و \_formatHeightInFeet

\_heightCard يعرض:

- عنوان Height.
- الرقم الحالي (cm أو ft+in).
- زر تغيير الوحدة.
- Slider من 100 إلى 220 cm.

حتى عندما تعرض FT+IN، التخزين الداخلي يبقى cm.

\_formatHeightInFeet يحول من cm إلى feet/inches للعرض فقط.

في وضع التابلت، expandSlider=true يضيف Spacer لتحسين توزيع العناصر عموديا.

## 5.5 📊 \_resultsCard

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

<hr style="border:none;height:3px;background:linear-gradient(90deg,#38bdf8,#f97316,#22c55e);border-radius:999px;" />

## 🏗️ 6) لماذا هذا الملف مناسب للتوسع مستقبلا

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
