package com.example.pharmacy_alamal

import android.os.Bundle
import com.google.firebase.auth.FirebaseAuth
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        FirebaseAuth.getInstance()
            .firebaseAuthSettings
            .forceRecaptchaFlowForTesting(true)
    }
}