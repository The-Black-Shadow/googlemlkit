# Flutter ProGuard/R8 Rules for Google ML Kit Text Recognition

# Suppress warnings for text recognition script options not packaged with the app
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
