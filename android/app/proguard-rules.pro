# Keep Stripe Push Provisioning classes (to fix R8 errors)
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# General Stripe safety
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
