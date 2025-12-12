# كيفية الحصول على SHA1 Fingerprint للـ Firebase

## المشكلة
على Windows، الأمر `./gradlew signingReport` لا يعمل لأن:
1. يجب استخدام `gradlew.bat` بدلاً من `./gradlew`
2. يجب تشغيل الأمر من داخل مجلد `android`

## الحلول

### الطريقة 1: استخدام gradlew.bat (موصى بها)

1. **افتح Terminal/PowerShell**
2. **انتقل إلى مجلد android:**
   ```powershell
   cd android
   ```

3. **شغل الأمر التالي:**
   ```powershell
   .\gradlew signingReport
   ```
   أو
   ```powershell
   gradlew.bat signingReport
   ```

4. **ابحث عن SHA1 في الناتج:**
   ```
   Variant: debug
   Config: debug
   Store: C:\Users\...\.android\debug.keystore
   Alias: AndroidDebugKey
   MD5: ...
   SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
   SHA-256: ...
   ```

### الطريقة 2: استخدام keytool مباشرة

1. **افتح PowerShell أو Command Prompt**

2. **شغل الأمر التالي:**
   ```powershell
   keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
   ```

3. **ابحث عن SHA1 في الناتج:**
   ```
   Certificate fingerprints:
        SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
        SHA256: ...
   ```

### الطريقة 3: للحصول على SHA1 من Android Studio

1. **افتح Android Studio**
2. **اذهب إلى:**
   - File → Project Structure
   - أو انقر بزر الماوس الأيمن على المشروع → Open Module Settings
3. **اذهب إلى:**
   - Signing → Debug
   - ستجد SHA1 هناك

### الطريقة 4: استخدام Flutter Command

1. **شغل الأمر التالي من المجلد الرئيسي للمشروع:**
   ```powershell
   cd android
   .\gradlew signingReport
   ```

2. **أو استخدم:**
   ```powershell
   flutter build apk --debug
   ```
   ثم
   ```powershell
   cd android
   .\gradlew signingReport
   ```

## خطوات إضافة SHA1 إلى Firebase

بعد الحصول على SHA1:

1. **اذهب إلى Firebase Console:**
   - https://console.firebase.google.com/
   - اختر مشروعك

2. **اذهب إلى Project Settings:**
   - انقر على الإعدادات (⚙️) → Project settings

3. **اذهب إلى Your apps:**
   - انزل للأسفل إلى قسم "Your apps"
   - اختر تطبيق Android

4. **أضف SHA-1 certificate fingerprint:**
   - انقر على "Add fingerprint"
   - الصق SHA1 الذي حصلت عليه
   - انقر "Save"

5. **حمّل google-services.json الجديد:**
   - بعد إضافة SHA1، قد تحتاج لتحميل ملف `google-services.json` الجديد
   - ضعه في `android/app/`

## استكشاف الأخطاء

### الخطأ: "gradlew: command not found"
**الحل:** استخدم `gradlew.bat` بدلاً من `./gradlew`

### الخطأ: "The system cannot find the path specified"
**الحل:** تأكد أنك في مجلد `android`:
```powershell
cd android
.\gradlew signingReport
```

### الخطأ: "Task 'signingReport' not found"
**الحل:** تأكد أن ملف `build.gradle` موجود وصحيح

### الخطأ: "Keystore file does not exist"
**الحل:** 
- قم ببناء التطبيق مرة واحدة أولاً:
  ```powershell
  flutter build apk --debug
  ```
- أو أنشئ keystore يدوياً

### الخطأ: Permission denied
**الحل:** 
- على Windows، قد تحتاج لتشغيل PowerShell كمسؤول
- أو استخدم `keytool` مباشرة

## أوامر سريعة

### للحصول على SHA1 للـ Debug:
```powershell
cd android
.\gradlew signingReport
```

### للحصول على SHA1 باستخدام keytool:
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### للحصول على SHA1 للـ Release (إذا كان لديك keystore):
```powershell
keytool -list -v -keystore "path\to\your\keystore.jks" -alias your-alias
```

## ملاحظات مهمة

1. **SHA1 للـ Debug vs Release:**
   - Debug SHA1: للتطوير والاختبار
   - Release SHA1: للإنتاج (يحتاج keystore خاص)

2. **إضافة عدة SHA1:**
   - يمكنك إضافة عدة SHA1 في Firebase
   - أضف SHA1 للـ Debug و Release

3. **بعد إضافة SHA1:**
   - قد تحتاج لإعادة بناء التطبيق
   - تأكد من تحديث `google-services.json`

4. **للإنتاج:**
   - أنشئ keystore للإنتاج
   - احصل على SHA1 من keystore الإنتاج
   - أضفه إلى Firebase

## مثال كامل

```powershell
# 1. انتقل إلى مجلد android
cd C:\Users\mabou\Desktop\NexBuy\nexbuy\android

# 2. شغل الأمر
.\gradlew signingReport

# 3. ابحث عن SHA1 في الناتج
# 4. انسخ SHA1
# 5. أضفه إلى Firebase Console
# 6. حمّل google-services.json الجديد
# 7. ضعه في android/app/
```

## نصائح

- استخدم PowerShell بدلاً من Command Prompt للحصول على نتائج أفضل
- إذا لم يعمل `gradlew.bat`، جرب `keytool` مباشرة
- تأكد من وجود Java JDK مثبت
- تحقق من أن `JAVA_HOME` مضبوط بشكل صحيح

## التحقق من Java

إذا كان هناك مشكلة، تحقق من تثبيت Java:
```powershell
java -version
keytool -help
```

إذا لم يعمل، قم بتثبيت Java JDK أولاً.

