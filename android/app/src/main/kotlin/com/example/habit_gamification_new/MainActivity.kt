package com.example.habit_gamification_new

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(
            "NATIVE_STARTUP",
            "MainActivity.onCreate: ${System.currentTimeMillis()}"
        )

        super.onCreate(savedInstanceState)

        Log.d(
            "NATIVE_STARTUP",
            "MainActivity.onCreate COMPLETE: ${System.currentTimeMillis()}"
        )
    }

    override fun onPostResume() {
        super.onPostResume()

        Log.d(
            "NATIVE_STARTUP",
            "MainActivity.onPostResume: ${System.currentTimeMillis()}"
        )
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)

        Log.d(
            "NATIVE_STARTUP",
            "MainActivity.onWindowFocusChanged($hasFocus): ${System.currentTimeMillis()}"
        )
    }
}