<div dir="rtl" style="line-height:1.85;max-width:1100px;margin:0 auto;padding:0 10px;">

<style>
pre,
pre code {
  direction: ltr;
  text-align: left;
  unicode-bidi: plaintext;
}
</style>

# 🎨 مخططات الـ Widget Trees - Calculator Screen

هذا المستند يحتوي على مخططات هيكلية (Tree Diagrams) توضح تركيب جميع الـ Widgets داخل كل دالة ترجع Widget.

## 🧱 أساسيات قراءة المخططات

```
Parent Widget
├─ Child 1
│   └─ Grandchild
├─ Child 2
│   ├─ Grandchild A
│   └─ Grandchild B
└─ Child 3
```

---

## _genderRow() - صف الجنس (Male/Female)

```
Row (mainAxisAlignment: spaceEvenly)
├─ Expanded
│   └─ Padding (horizontal: 16)
│       └─ _buildGenderCard('MALE', Icons.man, isMale)
│           └─ BrutalistContainer (onTap)
│               └─ Column
│                   ├─ Icon (Icons.man)
│                   ├─ SizedBox (height: 8)
│                   └─ Text ("MALE")
│
├─ SizedBox (width: 20) ← فاصل بين الخيارين
│
└─ Expanded
    └─ Padding (horizontal: 16)
        └─ _buildGenderCard('FEMALE', Icons.woman, !isMale)
            └─ BrutalistContainer (onTap)
                └─ Column
                    ├─ Icon (Icons.woman)
                    ├─ SizedBox (height: 8)
                    └─ Text ("FEMALE")
```

### نقاط مهمة:
- كل بطاقة جنس داخل `Expanded` بنسب متساوية
- عند الضغط يتغير لون الخلفية (yellow أم white)
- حجم الأيقونة والخط يختلف بين الهاتف والتابلت

---

## _ageWeightRow() - صف العمر والوزن

```
Row (mainAxisAlignment: spaceBetween)
├─ Expanded
│   └─ _buildCounterCard('AGE', 25, onChanged callback)
│       └─ BrutalistContainer
│           └─ Column
│               ├─ Text ('AGE')
│               ├─ SizedBox (height: 8)
│               ├─ FittedBox
│               │   └─ Row (textBaseline)
│               │       ├─ Text ('25')        ← الرقم الأساسي
│               │       ├─ SizedBox (width: 4)
│               │       └─ (بدون unit - العمر بلا وحدة)
│               │
│               ├─ SizedBox (height: 8)
│               └─ Row (mainAxisAlignment: center)
│                   ├─ _buildRoundButton(Icons.remove)
│                   ├─ SizedBox (width: 32)
│                   └─ _buildRoundButton(Icons.add)
│
├─ SizedBox (width: 20)
│
└─ Expanded
    └─ _buildCounterCard('WEIGHT', 70, onChanged callback)
        └─ BrutalistContainer
            └─ Column
                ├─ Text ('WEIGHT')
                ├─ SizedBox (height: 8)
                ├─ FittedBox
                │   └─ Row (textBaseline)
                │       ├─ Text ('70')        ← الرقم
                │       ├─ SizedBox (width: 4)
                │       └─ GestureDetector (onUnitTap)
                │           └─ Container (tappable unit)
                │               └─ Text ('KG' أو 'LB')
                │
                ├─ SizedBox (height: 8)
                └─ Row (mainAxisAlignment: center)
                    ├─ _buildRoundButton(Icons.remove)
                    ├─ SizedBox (width: 32)
                    └─ _buildRoundButton(Icons.add)
```

### نقاط مهمة:
- البطاقتان متساويتان في الحجم (Expanded)
- زر الوزن له وحدة قابلة للنقر بخلاف العمر
- عند الضغط على الوحدة يفتح Dialog لاختيار الوحدة الجديدة

---

## _heightCard() - بطاقة الطول

```
BrutalistContainer
└─ LayoutBuilder
    └─ Column
        │
        ├─ if (expandSlider && !compact)
        │   └─ Spacer() ← للتوسع العمودي على التابلت
        │
        ├─ Text ('HEIGHT')
        ├─ SizedBox (height: 4 أو 8)
        │
        ├─ Row (mainAxisAlignment: spaceBetween)
        │   ├─ _buildRoundButton(Icons.remove)
        │   │
        │   ├─ Expanded
        │   │   └─ Row (textBaseline)
        │   │       ├─ if (isCm)
        │   │       │   └─ Text ('170')        ← الارتفاع بـ CM
        │   │       │else
        │   │       │   └─ Text ('5\' 7\"')    ← الارتفاع بـ FT+IN
        │   │       │
        │   │       ├─ SizedBox (width: 6 أو 8)
        │   │       │
        │   │       └─ GestureDetector (onTap: show unit dialog)
        │   │           └─ Container
        │   │               └─ Text ('CM' أو 'FT+IN')
        │   │
        │   └─ _buildRoundButton(Icons.add)
        │
        ├─ SizedBox (height: 2 أو 8)
        │
        ├─ Slider
        │   ├─ value: height
        │   ├─ min: 100
        │   └─ max: 220
        │
        └─ if (expandSlider && !compact)
            └─ Spacer() ← للتوسع العمودي على التابلت
```

### نقاط مهمة:
- الـ LayoutBuilder يحدد ما إذا كان هناك مساحة كافية (compact mode)
- الـ Slider يتحدث مباشرة بدون إعادة حساب (state update أثناء السحب)
- الوحدة قابلة للنقر (GestureDetector)

---

## _resultsCard() - بطاقة النتائج (3 أعمدة)

```
BrutalistContainer
└─ IntrinsicHeight
    └─ Row (crossAxisAlignment: stretch)
        │
        ├─ Expanded (flex: 1)
        │   └─ Padding
        │       └─ Column (mainAxisAlignment: center)
        │           ├─ Text ('IDEAL')         ← اللاب
        │           ├─ SizedBox (height: 4)
        │           └─ FittedBox
        │               └─ Text ('65kg' أو '143lb')
        │
        ├─ Container (width: 2, black border)
        │
        ├─ Expanded (flex: 2)
        │   └─ Container
        │       ├─ backgroundColor: Color(0xFF5CE1E6) ← أزرق
        │       ├─ padding: EdgeInsets.symmetric(16, 8)
        │       └─ Column (mainAxisAlignment: center)
        │           ├─ Text ('BMI')
        │           ├─ Text ('22.5')          ← الرقم الكبير
        │           ├─ SizedBox (height: 8)
        │           └─ Container (black badge)
        │               └─ Text ('NORMAL')
        │
        ├─ Container (width: 2, black border)
        │
        └─ Expanded (flex: 1)
            └─ Padding
                └─ Column (mainAxisAlignment: center)
                    ├─ Text ('FAT %')        ← اللاب
                    ├─ SizedBox (height: 4)
                    └─ Text ('18.5%')
```

### نقاط مهمة:
- استخدام `IntrinsicHeight` لجعل جميع الأعمدة نفس الارتفاع
- العمود الأوسط (BMI) أكبر من الجانبين (flex: 2 vs flex: 1)
- الفواصل السوداء بسمك 2 بكسل بين الأعمدة
- خلفية زرقاء للـ BMI لجعلها بارزة

---

## _classificationSection() - جدول التصنيفات

```
Column
├─ Text ('REFERENCE')
├─ SizedBox (height: 4)
├─ Text ('diseases_tap_hint')  ← نص hint صغير
├─ SizedBox (height: 12)
│
└─ if (!scrollable)
   │   ← للتابلت
   └─ Expanded
       └─ table
else
   │   ← للهاتف
   └─ table

حيث table =
BrutalistContainer
└─ Column
    ├─ _buildClassificationRow('VERY SEVERE', '< 16', Red, categoryKey: 'cat_vsu')
    │   └─ GestureDetector (onTap → DiseasesScreen)
    │       └─ Container (height: 52)
    │           └─ Row
    │               ├─ Text ('VERY SEVERE')
    │               ├─ Text ('< 16')
    │               └─ Icon (chevron_right)
    │
    ├─ _buildClassificationRow('SEVERE', '16-17', Orange, ...)
    ├─ _buildClassificationRow('UNDERWEIGHT', '17-18.5', ...)
    ├─ _buildClassificationRow('NORMAL', '18.5-25', Green, ...)
    ├─ _buildClassificationRow('OVERWEIGHT', '25-30', Yellow, ...)
    ├─ _buildClassificationRow('OBESE I', '30-35', LightOrange, ...)
    ├─ _buildClassificationRow('OBESE II', '35-40', ...)
    └─ _buildClassificationRow('OBESE III', '> 40', Red, isLast: true)
```

### نقاط مهمة:
- كل صف قابل للضغط (GestureDetector)
- الصف الأخير بدون خط سفلي (isLast: true)
- في التابلت: الصفوف تتمدد (Expanded)
- في الهاتف: الصفوف بارتفاع ثابت (52)

---

## _buildGenderCard() - بطاقة الجنس الفردية

```
BrutalistContainer
├─ onTap: setState callback
├─ backgroundColor: isMale ? Yellow : White
└─ Column
    ├─ mainAxisAlignment: center
    ├─ Icon (Icons.man أو Icons.woman)
    ├─ SizedBox (height: 8)
    └─ Text ('MALE' أو 'FEMALE')
```

### نقاط مهمة:
- تتغير الخلفية حسب الحالة (selected/unselected)
- تستقبل iconSize و fontSize من الدالة الأب (_genderRow)
- عند الضغط: setState + _calculate

---

## _buildCounterCard() - بطاقة العداد

```
BrutalistContainer
├─ backgroundColor: White
└─ Column
    ├─ Text ('AGE' أو 'WEIGHT')
    ├─ SizedBox (height: 8)
    ├─ FittedBox
    │   └─ Row (textBaseline: alphabetic)
    │       ├─ Text ('25')                   ← الرقم الأساسي
    │       ├─ SizedBox (width: 4)
    │       └─ if (onUnitTap != null)
    │           └─ GestureDetector
    │               └─ Container (tappable)
    │                   └─ Text ('KG' أو 'LB')
    │           else
    │               └─ Text ('KG' أو 'LB')  ← غير قابل للتفاعل
    │
    ├─ SizedBox (height: 8)
    └─ Row
        ├─ mainAxisAlignment: center
        ├─ _buildRoundButton(Icons.remove)
        ├─ SizedBox (width: 32)
        └─ _buildRoundButton(Icons.add)
```

### نقاط مهمة:
- الوحدة قابلة للنقر فقط للوزن (onUnitTap parameter)
- استخدام FittedBox لتقليل حجم النص إذا لزم الأمر
- الأزرار +/- متساوية الحجم وملونة بالأسود

</div>
